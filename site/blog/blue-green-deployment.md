# Blue green deployment

## Motivation

I follow [Pieter Levels](https://x.com/levelsio?lang=en) and he uses (and inspires others to use) a simple tech stack and process.
At the time of this post he uses:

- PHP and JQuery for the programming language
- A VPS in vendors like Linode or Hetzner
- SQLite

And codes directly on the production VPS. That saves him tons of money (no cloud, k8s, etc) and makes fixing bugs in production
very simple.

That works well for an indie dev and with interpreted languages. For compiled languages things get a bit trickier:

- You need to compile the app
  - You do not want to use resources of the production VPS to do so
- You need to stop one version and start the next creating some downtime

That got me thinking about how I could (hypothetically) use this lean approach for Go.
For that reason I created this post. It tries to adapt [levelsio](https://x.com/levelsio?lang=en)'s way of working to a compiled server like Go.

With this post I am not inviting people to use this approach in production systems. We need to consider all the tradeoffs of going fully hacker, fully corporate, or something in between.
I am not responsible for any issues caused in production systems due to following this post.

## What are we going to do

In this post we will create a simple blue-green deployment for our Go app.

**Block 1: Configure the VM with nginx and the simple golang server**

- Create a simple Go server with health endpoint
- Create a local VM with multipass
- Install nginx in the VM
- Deploy the Go server to the VM
- Configure nginx to proxy requests to our application

**Block 2: Configure blue green deployment**

- Add status endpoint and color attribute to the server
- Implement blue-green deployment scripts
- Test the complete blue-green deployment process

I assume knowledge of Go and HTTP servers and basic knowledge about nginx (at least that it exists and what it does).

## Block 1: Configure the VM with nginx and the simple golang server

```nagare
@layout(w:800,h:300)

browser:Browser@home
vps:VM@ubuntu {
    nginx:Server@nginx
    app:Server@app
}

browser.e --> nginx.w
nginx.e --> app.w

@browser(x:50,y:25,w:250,h:200)
@home(url: "http://multipass/home", bg: "#e6f3ff", fg: "#333", text: "Home Page")

@vps(x:350,y:&browser.c,w:400,h:200)
@ubuntu(title: "ubuntu@multipass", bg: "#666", fg: "#eee", text: "Ubuntu", contentBg: "#f0f8ff")

@nginx(x:20,y:&browser.c,w:150,h:40, title: "nginx", icon: "nginx", port: 80, bg: "#f0f8ff", fg: "#333")
@app(x:200,y:&browser.c,w:150,h:40, title: "app", icon: "golang", port: 8081, bg: "#f0f8ff", fg: "#333")
```

### Simple Go server

Let's first initialize our Go project:

```shell
go mod init bluegreen-demo
```

The official way to initialize a Go module is using a git repo, but for our use case we are using this simple name.
Let's create our server:

```shell
mkdir -p cmd
touch cmd/main.go
```

The server will look like this:

```golang
package main

import (
	"encoding/json"
	"flag"
	"net/http"
)

func writeJsonResponse(w http.ResponseWriter, data map[string]string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(data)
}

func main() {
	var port = flag.String("port", "", "Port to listen on")
	flag.Parse()

	if *port == "" {
		panic("port is required")
	}

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		writeJsonResponse(w, map[string]string{"message": "ok"})
	})

	http.ListenAndServe(":"+*port, nil)
}
```

What this code does:

- Read `--port` flag (required)
- Create one endpoint:
  - `/healthz`: standard endpoint to check if a service is running

We can run a quick test:

```shell
go build -o bluegreendemo cmd/main.go
./bluegreendemo --port 8080 &
sleep 1
curl -s http://localhost:8080/healthz | jq
pkill -f "./bluegreendemo --port 8080"
```

(`jq` is optional. I use it to add some color to the JSON content)

You should see something like:

````json
...
{
  "message": "ok"
}
...
```


### Create a local VM with multipass

First we need to install multipass following the [official docs](https://canonical.com/multipass/install).

For example, for macOS with Homebrew you can just run:

```shell
brew install multipass
````

We will create a VM locally with:

- Ubuntu 24.04
- 2 CPUs
- 4 GB of RAM
- 15GB of HD

Feel free to tweak your numbers.

Creating the VM is as simple as running the following command:

```shell
multipass launch 24.04 --name bluegreen-demo --cpus 2 --memory 4G --disk 15G
```

After some time we should be able to find our VM running:

```shell
multipass list
```

```text
Name                    State             IPv4             Image
bluegreen-demo          Running           192.168.64.8     Ubuntu 24.04 LTS
```

We can open a shell to the VM by running:

```shell
multipass shell bluegreen-demo
```

We should see a prompt like:

```shell
ubuntu@bluegreen-demo:~$
```

### Install nginx

We need to install nginx in Ubuntu.

```shell
sudo apt update
sudo apt install nginx -y
nginx -v
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

What are we doing?

- Install nginx
- Start it and configure it to start on boot
- Check the status

At the end of the script you should see something like:

```text
Sep 13 10:26:14 bluegreen-demo systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
Sep 13 10:26:14 bluegreen-demo systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
```

### Deploy and start the application in the VM

We will start building our application.
We will run it on port `8081`.

We will create a small script that will handle the deployment of our app.

```text
cmd/
    main.go
scripts/
    deploy.sh <-- this file
go.mod
```

```shell
mkdir -p scripts
touch scripts/deploy.sh
chmod +x scripts/deploy.sh
```

These are the contents of the script for now:

```bash
#! /bin/bash

GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo

multipass exec bluegreen-demo -- sudo mkdir -p /app/
multipass exec bluegreen-demo -- sudo chown ubuntu:ubuntu /app/
multipass exec bluegreen-demo -- mv bluegreendemo /app/app
multipass exec bluegreen-demo -- chmod +x /app/app
multipass exec bluegreen-demo -- /app/app --port 8081 &
```

This script builds the server, transfers it to the VM, and executes it on port 8081.

We can test that it is running by accessing `http://<vm ip>:8081/healthz`

To do so we can do:

```shell
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

curl -s http://$VM_IP:8081/healthz | jq
```

(again `jq` is optional)

We have now our application running in the VM.

### Configure nginx to server our application

Let's define a configuration for nginx.
Let's create this file in our local machine:

```text
cmd/
    main.go
nginx/
    nginx.conf <-- this file
scripts/
    deploy.sh
go.mod
```

```shell
mkdir -p nginx
touch nginx/nginx.conf
```

These are the contents:

```text
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://localhost:8081;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

We will transfer this file and run a step to apply the config for nginx.

We need to add this line after the app compilation:

```bash
multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx/nginx.conf
```

And this line at the end to load the new configuration

```bash
multipass exec bluegreen-demo -- sudo mv nginx/nginx.conf /etc/nginx/nginx.conf
multipass exec bluegreen-demo -- sudo nginx -s reload
```

Let's try all out by running:

```shell
./scripts/deploy.sh
```

Now we should be able to access our app using the port 80.
We can testing by curling our app without any port defined.

```shell
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

curl -s http://$VM_IP/healthz | jq
```

We have nginx serving our app.

## Block 2: Configure blue green deployment

```nagare
@layout(w:800,h:300)

browser:Browser@home
vps:VM@ubuntu {
    nginx:Server@nginx
    blue:Server@app
    green:Server@app
}

browser.e --> nginx.w
nginx.e --> blue.w

@browser(x:50,y:10,w:250,h:200)
@home(url: "http://multipass/home", bg: "#e6f3ff", fg: "rgb(0, 119, 194)", text: "Blue")

@vps(x:350,y:&browser.c,w:400,h:200)
@ubuntu(title: "ubuntu@multipass", bg: "#666", fg: "#eee", text: "Ubuntu", contentBg: "#f0f8ff")

@nginx(x:20,y:&browser.c,w:150,h:40, title: "nginx", icon: "nginx", port: 80, bg: "#f0f8ff", fg: "#333")
@app(x:200,w:150,h:40,icon: "golang")

@blue(y:&nginx.c,title: "blue",  port: 8081, bg: "rgb(0, 119, 194)", fg: "#fff")
@green(y:120,title: "green", port: 8082, bg: "rgb(0, 118, 108)", fg: "#fff")

```

```nagare
@layout(w:800,h:300)

browser:Browser@home
vps:VM@ubuntu {
    nginx:Server@nginx
    blue:Server@app
    green:Server@app
}

browser.e --> nginx.w
nginx.e --> green.w

@browser(x:50,y:10,w:250,h:200)
@home(url: "http://multipass/home", bg: "#e6f3ff", fg: "rgb(0, 118, 108)", text: "Green")

@vps(x:350,y:&browser.c,w:400,h:200)
@ubuntu(title: "ubuntu@multipass", bg: "#666", fg: "#eee", text: "Ubuntu", contentBg: "#f0f8ff")

@nginx(x:20,y:&browser.c,w:150,h:40, title: "nginx", icon: "nginx", port: 80, bg: "#f0f8ff", fg: "#333")
@app(x:200,w:150,h:40,icon: "golang")

@blue(y:120,title: "blue",  port: 8081, bg: "rgb(0, 119, 194)", fg: "#fff")
@green(y:&nginx.c,title: "green", port: 8082, bg: "rgb(0, 118, 108)", fg: "#fff")

```

### Blue Green Deployment

Now that we have our basic setup with the VM, nginx, and a simple Go server, let's implement blue-green deployment.

First, we need to enhance our Go server to support the status endpoint and color attribute.

Update the server code to include the color flag and status endpoint:

```golang
package main

import (
	"encoding/json"
	"flag"
	"net/http"
)

func writeJsonResponse(w http.ResponseWriter, data map[string]string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(data)
}

func main() {
	var port = flag.String("port", "", "Port to listen on")
	var color = flag.String("color", "", "Color value to return in responses")
	flag.Parse()

	if *port == "" || *color == "" {
		panic("port and color are required")
	}

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		writeJsonResponse(w, map[string]string{"message": "ok"})
	})

	http.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		writeJsonResponse(w, map[string]string{
			"color": *color,
		})
	})

	http.ListenAndServe(":"+*port, nil)
}
```

What this code does:

- Read `--color` and `--port` flags (required)
- Create two endpoints:
  - `/healthz`: standard endpoint to check if a service is running
  - `/status`: returns the color of the deployment

We will define that `blue` listens on port `8081` and `green` listens on port `8082`.

- Blue: 8081
- Green: 8082

### Enhanced Deployment Scripts

Now our script runs from our host and we are mixing commands for transfering files and commands for executing actions in our VPS.

It will make more sense on the next post in this series, but we will split our `deploy.sh` script into:

- `apply.sh`: it will run within the VPS and will run all the commands required to release our next deployment.
- `prepare.sh`: it build the app and transfer all the files we need, including `apply.sh`
- `ci.sh`: it will call both

The file structure will look like:

```text
cmd/
    main.go
nginx/
    nginx.conf
scripts/
    apply.sh <-- new
    ci.sh <-- new
    prepare.sh <-- new
go.mod
```

To create the files:

```shell
touch scripts/apply.sh
touch scripts/ci.sh
touch scripts/prepare.sh

chmod +x scripts/apply.sh
chmod +x scripts/ci.sh
chmod +x scripts/prepare.sh
```

#### prepare.sh

We will take the first part of the `deployment.sh` file and move it to `prepare.sh`.
We will also add the transfer of the `apply.sh` file itself.

```bash
#! /bin/bash

# Cross-compile for Linux ARM64 (typical for multipass VMs)
GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go

# Transfer files to the VM
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo
multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx.conf
multipass transfer ./scripts/apply.sh bluegreen-demo:apply.sh
```

### apply.sh

We will take the second part of the `deploy.sh` file and move it to `apply.sh`.
We will run within the VPS so we can get rid of `multipass exec`:

```bash
#! /bin/bash

sudo mkdir -p /app/
sudo chown ubuntu:ubuntu /app/
mv bluegreendemo /app/blue
chmod +x /app/blue
/app/blue --port 8081 --color blue &

sudo mv nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload
sleep 1
```

### ci.sh

We will invoke both files, one after the other along side some messages:

```bash
#! /bin/bash

echo "Preparing the VM..."
./scripts/prepare.sh



echo "Deploying the new version..."
multipass exec bluegreen-demo -- ./apply.sh

curl -s http://$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')/status
```

We should be able to run `ci.sh` without erros:

```shell
./scripts/ci.sh
```

The response is always the same for now.

### prepre.sh

We will take the first part of the `deployment.sh` file and move it to `prepare.sh`.
We will also add the transfer of the `apply.sh` file itself.

```bash
#! /bin/bash

# Cross-compile for Linux ARM64 (typical for multipass VMs)
GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go

# Transfer files to the VM
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo
multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx.conf
multipass transfer ./scripts/apply.sh bluegreen-demo:apply.sh
```

### apply.sh

We will take the second part of the `deploy.sh` file and move it to `apply.sh`.
We will run within the VPS so we can get rid of `multipass exec`:

```bash
#! /bin/bash

sudo mkdir -p /app/
sudo chown ubuntu:ubuntu /app/
mv bluegreendemo /app/blue
chmod +x /app/blue
/app/blue --port 8081 --color blue &

sudo mv nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload
sleep 1
```

### ci.sh

We will invoke both files, one after the other along side some messages:

```bash
#! /bin/bash

echo "Preparing the VM..."
./scripts/prepare.sh



echo "Deploying the new version..."
multipass exec bluegreen-demo -- ./apply.sh

curl -s http://$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')/status
```

We should be able to run `ci.sh` without erros:

```shell
./scripts/ci.sh
```

The response is always the same for now.

### Implementing Blue-Green Deployment

We will run our blue/green deployment. This is what we will need to do:

- Discover the current color so we decide the next color.
- Copy the new app into the right directory (next color).
- Start the application with the right args.
- Update nginx to serve the next color.

#### Discover the color

We just need to request our /status endpoint:

```bash
CURRENT_COLOR=$(curl -s http://localhost/status | jq -r .color)
```

- `jq -r` returns the raw value, in this case `blue` or `green`. Without -r we would get `"blue"` or `"green"`.

Based on the color we get we decide what is the next color and next port:

```bash
if [ -z "$CURRENT_COLOR" ]; then
    # If CURRENT_COLOR is empty (no application is running), start with blue
    NEXT_COLOR="blue"
    NEXT_PORT="8081"
elif [ "$CURRENT_COLOR" = "blue" ]; then
    # If current is blue, next is green
    NEXT_COLOR="green"
    NEXT_PORT="8082"
elif [ "$CURRENT_COLOR" = "green" ]; then
    # If current is green, next is blue
    NEXT_COLOR="blue"
    NEXT_PORT="8081"
else
    echo -e "Color not supported $CURRENT_COLOR"
    exit 1
fi

echo "Deploying $NEXT_COLOR on port $NEXT_PORT"
```

And then we use the variables in the contents we had and:

- in case the next color is already running we kill it before Deploying
- we check that the running color is the one we expect

```bash
sudo mkdir -p /app/
sudo chown ubuntu:ubuntu /app/

pkill -f /app/$NEXT_COLOR || true

mv bluegreendemo /app/$NEXT_COLOR
chmod +x /app/$NEXT_COLOR

# Start the application in background
echo "Starting /app/$NEXT_COLOR on port $NEXT_PORT"
nohup /app/$NEXT_COLOR --port $NEXT_PORT --color $NEXT_COLOR &

# Give it a moment to start
sleep 2

NEXT_COLOR_CHECK=$(curl -s http://localhost:$NEXT_PORT/status | jq -r .color)

if [ "$NEXT_COLOR_CHECK" != "$NEXT_COLOR" ]; then
    echo -e "$RED Deployment failed! $NEXT_COLOR did not start correctly $NC"
    exit 1
fi

sudo mv nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload

CURRENT_COLOR=$(curl -s http://localhost/status | jq -r .color)

if [ "$CURRENT_COLOR" = "$NEXT_COLOR" ]; then
    echo -e "$GREEN Deployment successful! Current color is now $CURRENT_COLOR $NC"
    exit 0
else
    echo -e "$RED Deployment failed! Current color is still $CURRENT_COLOR $NC"
    exit 1
fi
```

If we run the ci again we should find this line:

```shell
./scripts/ci.sh

...
Deployment failed! Current color is still blue
```

If we check from the host:

```bash
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

echo "Checking green"
curl -s http://$VM_IP:8082/status | jq -r .color


echo "Checking default"
curl -s http://$VM_IP/status | jq -r .color
```

We should see:

```text
Checking green
green
Checking default
blue
```

Green is running properly but nginx still points to `blue` (we hardcoded it, remember?)

### Update nginx to point to next color:

We are going to add 2 files to the nginx directory:

```text
cmd/
    main.go
nginx/
    blue.conf <-- new
    green.conf <-- new
    nginx.conf
scripts/
    apply.sh
    ci.sh
    prepare.sh
go.mod
```

They will contain the upstream config for their respective colors:

Blue:

```text
upstream app_backend {
    server 127.0.0.1:8081;
}
```

Green:

```text
upstream app_backend {
    server 127.0.0.1:8082;
}
```

We will update nginx conf to include the upstream config from another file:

We will replace:

```text
proxy_pass http://localhost:8081;
```

with

```text
proxy_pass http://app_backend;
```

And add this line under http:

```text
include /etc/nginx/upstream.conf;
```

We will need to update our prepare.sh to transfer all files within the nginx directory.
Replace

```bash
multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx.conf
```

with

```bash
multipass transfer ./nginx/* bluegreen-demo:.
```

And create a link to point to the right color so upstream.conf is dynamic:
We will update `apply.sh` and add this line before we reload nginx:

```bash
...
sudo mv *.conf /etc/nginx/
sudo ln -sf /etc/nginx/$NEXT_COLOR.conf /etc/nginx/upstream.conf
sudo nginx -s reload
...
```

If we run our ci again and again we should be seeing our color changing from green to blue:

```shell
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

./scripts/ci.sh
curl -s http://$VM_IP/status | jq -r .color
```

### Conclusion

Using simple scripts and nginx we could create a basic blue/green deployment that would allow us deploy our application to a VPS without down time.

In the next post we will explore how to perform this deployment using Github Actions as part of a real CI instead of deploying the application from our local machine.
