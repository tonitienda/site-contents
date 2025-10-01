# Blue green deployment

## Motivation

I follow [Pieter Levels](https://x.com/levelsio?lang=en) and he uses (and inspires others to use) a simple tech stack and process. And codes directly on the production VPS. That saves him tons of money (no cloud, k8s, etc) and makes fixing bugs in production very simple.

At the time of this post [the tools he uses are](https://ramen.tools/@levelsio):

- PHP and JS (with JQuery) as programming language
- A VPS in vendors like Linode or Hetzner
- SQLite
- Cloudflare for cdn and content caching

That works well for an indie dev and with interpreted languages.
For compiled languages, thought, things get a bit trickier:

- You need to compile the app
  - You do not want to use resources of the production VPS to do so
- In order to deploy a new version you need to stop the previous one

That got me thinking about how I could (hypothetically) use this lean approach for Go.
For that reason I created this post. It tries to adapt [levelsio](https://x.com/levelsio?lang=en)'s way of working to a compiled server like Go.

With this post I am not inviting people to use this approach in production systems. We need to consider all the tradeoffs of going fully hacker, fully corporate, or something in between.
I am not responsible for any issues caused in production systems due to following this post.

## What are we going to do

In this post we will create a simple blue-green deployment for our Go app.

**Block 1: Configure the VM with nginx and the simple golang server**

- Create a simple Go server with a health endpoint
- Create a local VM with multipass
- Install nginx in the VM
- Deploy the Go server to the VM
- Configure nginx to proxy requests to our application

**Block 2: Configure blue green deployment**

- Add status endpoint and color attribute to the server
- Implement blue-green deployment scripts
- Test the complete blue-green deployment process

I assume knowledge of Go and HTTP servers and basic knowledge about nginx (at least that it exists and what it does).

Let's start!

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
@home(url: "http://multipass/home", bg: "#e6f3ff", fg: "#666", text: "Home Page")

@vps(x:350,y:&browser.c,w:400,h:200)
@ubuntu(title: "ubuntu@multipass", bg: "#666", fg: "#eee", text: "Ubuntu", contentBg: "#f0f8ff")

@nginx(x:20,y:&browser.c,w:150,h:40, title: "nginx", icon: "nginx", port: 80, bg: "#f0f8ff", fg: "#333")
@app(x:200,y:&browser.c,w:150,h:40, title: "app", icon: "golang", port: 8081, bg: "#f0f8ff", fg: "#333")
```

### Creating our simple Go server

Let's first initialize our Go project with `go mod init bluegreen-demo`

The official way to initialize a Go module is using a git repo, but for our use case we are using this simple name.
Let's create our server:

```text
cmd/
    main.go <-- this file
```

We will create a http server with a healthcheck that will return a json and the status 200.
We can pass the port it has to listen to via cli args.

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

We can run a quick test:

```shell
go build -o bluegreendemo cmd/main.go
./bluegreendemo --port 8080 &
sleep 1
curl -s http://localhost:8080/healthz | jq
pkill -f "./bluegreendemo --port 8080"
```

You should see the health response:

```json
{
  "message": "ok"
}
```

### Create a local VM with multipass

We will create a VM in our computer using multipass following the [official docs](https://canonical.com/multipass/install).

Our VM locally will have the following specs:

- Ubuntu 24.04
- 2 CPUs
- 4 GB of RAM
- 15GB of HD

Feel free to tweak your numbers.

For example, for macOS with Homebrew you can just run:

```shell
brew install multipass
multipass launch 24.04 --name bluegreen-demo --cpus 2 --memory 4G --disk 15G
multipass list
```

We should see that the machine is running:

```text
Name                    State             IPv4             Image
bluegreen-demo          Running           192.168.64.8     Ubuntu 24.04 LTS
```

### Deploy and start the application in the VM

To handle our deployment process cleanly, we'll create three specialized scripts:

```text
cmd/
    main.go
scripts/
    prepare.sh   # Handles building and file transfers
    apply.sh     # Manages deployment in the VM
    ci.sh        # Orchestrates the whole process
go.mod
```

Make the scripts executable:

```shell
chmod +x scripts/prepare.sh scripts/apply.sh scripts/ci.sh
```

Let's implement each script:

#### prepare.sh - Building and File Transfers

This script handles the build process and transferring files to the VM:

```bash
#! /bin/bash

# Cross-compile for Linux ARM64
GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go

# Transfer files to the VM
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo
multipass transfer ./scripts/apply.sh bluegreen-demo:apply.sh
```

#### apply.sh - VM-side Deployment

This script runs inside the VM and handles the application deployment:

```bash
#! /bin/bash

# Prepare app directory
sudo mkdir -p /app/
sudo chown ubuntu:ubuntu /app/

# Deploy application
mv bluegreendemo /app/app
chmod +x /app/app

# Start the application
/app/app --port 8081 &
```

#### ci.sh - Orchestrating the Process

This script coordinates the whole deployment:

```bash
#! /bin/bash

echo "Preparing deployment..."
./scripts/prepare.sh

echo "Deploying new version..."
multipass exec bluegreen-demo -- ./apply.sh

# Verify deployment
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')
curl -s http://$VM_IP:8081/healthz | jq
```

Run the deployment:

```shell
./scripts/ci.sh
```

If you see a JSON response with `{"message": "ok"}`, congratulations! Your app is running.

### Install nginx

We need to install and configure nginx in our VM:

- Install nginx
- Start it and configure it to start on boot
- Check the status

For that we will open a shell in the VM using `multipass shell bluegreen-demo` and run the following set of commands:

```shell
sudo apt update
sudo apt install nginx -y
nginx -v
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

At the end of the script you should see something like:

```text
Sep 13 10:26:14 bluegreen-demo systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
Sep 13 10:26:14 bluegreen-demo systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
```

### Configure nginx to serve our application

We will configure nginx to serve our application in port 80 (default for http). For that we will create a minimum nginx.conf file to listen to port 80 and forward the requests to our app in port 8081.

```text
cmd/
    main.go
nginx/
    nginx.conf <-- this file
scripts/
    apply.sh
    ci.sh
    prepare.sh
go.mod
```

These are the contents:

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://localhost:8081;
        }
    }
}
```

We will need to update our scripts to handle the nginx configuration:

1. Add nginx.conf transfer to `prepare.sh`:

```bash
multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx/nginx.conf
```

2. Add nginx configuration to `apply.sh`:

```bash
sudo mv nginx/nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload
```

Let's try it out by running:

````shell
./scripts/ci.sh

Now we should be able to access our app using the port 80:

```shell
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

curl -s http://$VM_IP/healthz | jq
````

We have nginx serving our app.

## Block 2: Configure blue green deployment

Let's implement a blue-green deployment strategy that allows us to deploy new versions without downtime. The idea is simple:

- Run two instances of our application (blue and green)
- Only one instance receives traffic at a time
- Deploy new versions to the inactive instance
- Switch traffic to the new version once it's ready

Here's how it works:

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

And after deploying and switching:

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

### Adding Color Support to Our Server

First, let's enhance our Go server to identify which version (blue or green) it is:

- Add a `--color` flag to identify blue/green instances
- Add a `/status` endpoint to report the current color

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

    // NEW: Get "color" as arg when the server starts
	var color = flag.String("color", "", "Color value to return in responses")
	flag.Parse()

	if *port == "" || *color == "" {
		panic("port and color are required")
	}

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		writeJsonResponse(w, map[string]string{"message": "ok"})
	})

    // NEW: Return the "color" in the status endpoint
	http.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		writeJsonResponse(w, map[string]string{
			"color": *color,
		})
	})

	http.ListenAndServe(":"+*port, nil)
}
```

### Updating the Deployment Scripts for Blue-Green

Now that we've added color support to our server, we need to update our existing deployment scripts to handle the blue-green deployment strategy. Let's modify each script to support this new functionality:

#### Updates to prepare.sh

We'll update our existing `prepare.sh` script to handle the nginx configuration files for blue-green deployment:

```bash
#! /bin/bash

# Cross-compile for Linux ARM64
GOOS=linux GOARCH=arm64 go build -o bluegreendemo cmd/main.go

# Transfer all required files to the VM
multipass transfer ./bluegreendemo bluegreen-demo:bluegreendemo
multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx/nginx.conf
multipass transfer ./scripts/apply.sh bluegreen-demo:apply.sh
```

#### Updates to apply.sh

We'll enhance our existing `apply.sh` script to handle the blue-green deployment logic:

```bash
#! /bin/bash

# Get current active color
CURRENT_COLOR=$(curl -s http://localhost/status | jq -r .color)

# Determine next deployment color
if [ "$CURRENT_COLOR" = "blue" ]; then
    NEXT_COLOR="green"
    NEXT_PORT="8082"
else
    NEXT_COLOR="blue"
    NEXT_PORT="8081"
fi

echo "Deploying $NEXT_COLOR on port $NEXT_PORT"

# Prepare deployment
sudo mkdir -p /app/
sudo chown ubuntu:ubuntu /app/
pkill -f /app/$NEXT_COLOR || true

# Deploy new version
mv bluegreendemo /app/$NEXT_COLOR
chmod +x /app/$NEXT_COLOR
/app/$NEXT_COLOR --port $NEXT_PORT --color $NEXT_COLOR &
sleep 2  # Wait for startup

# Verify deployment
if curl -s http://localhost:$NEXT_PORT/status | grep -q "$NEXT_COLOR"; then
    # Switch traffic
    sudo mv *.conf /etc/nginx/
    sudo ln -sf /etc/nginx/$NEXT_COLOR.conf /etc/nginx/upstream.conf
    sudo nginx -s reload
    echo "Switched to $NEXT_COLOR"
else
    echo "Deployment failed - new version not responding"
    exit 1
fi
```

#### Updates to ci.sh

We'll update our existing `ci.sh` script to handle the verification of the deployment switch:

```bash
#! /bin/bash

echo "Preparing deployment..."
./scripts/prepare.sh

echo "Deploying new version..."
multipass exec bluegreen-demo -- ./apply.sh

# Verify the switch
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')
echo "Current version:"
curl -s http://$VM_IP/status | jq
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

### Configuring Nginx for Zero-Downtime Switching

The final piece is setting up nginx to smoothly switch between versions. The key is to use nginx's upstream feature and symbolic links to make the switch instant and atomic.

#### 1. Setting up the Configuration Structure

We'll create three configuration files:

```text
nginx/
    nginx.conf         # Main configuration with routing logic
    blue.conf          # Blue instance configuration (port 8081)
    green.conf         # Green instance configuration (port 8082)
```

#### 2. Creating Instance-Specific Configs

Each color gets its own configuration that defines where its instance runs:

`blue.conf`:

```nginx
upstream app_backend {
    server 127.0.0.1:8081;
}
```

`green.conf`:

```nginx
upstream app_backend {
    server 127.0.0.1:8082;
}
```

#### 3. Setting up the Main Configuration

Update `nginx.conf` to use the dynamic backend:

```nginx
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    include /etc/nginx/upstream.conf;  # Dynamic backend selection

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://app_backend;  # Routes to active instance
        }
    }
}
```

#### 4. Implementing the Switch Mechanism

The switching mechanism is simple but effective:

1. Upload the configuration:

   ```bash
   multipass transfer ./nginx/nginx.conf bluegreen-demo:nginx/nginx.conf
   ```

2. Set up the active configuration using a symbolic link:
   ```bash
   sudo mv *.conf /etc/nginx/
   sudo ln -sf /etc/nginx/$NEXT_COLOR.conf /etc/nginx/upstream.conf
   sudo nginx -s reload
   ```

This setup gives us two key benefits:

- **Zero Downtime**: The switch is instant and atomic
- **Easy Rollback**: We can quickly switch back by changing the symbolic link

If we run our ci again and again we should be seeing our color changing from green to blue:

```shell
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

./scripts/ci.sh
curl -s http://$VM_IP/status | jq -r .color
```

### Conclusion

We've successfully created a simple but effective blue-green deployment system that:

- Enables zero-downtime deployments on a single VPS
- Uses nginx for instant traffic switching
- Keeps the previous version ready for quick rollbacks
- Requires minimal infrastructure

This approach shows how we can adapt modern deployment practices to a lean, cost-effective setup inspired by [levelsio](https://x.com/levelsio?lang=en)'s philosophy. While this example uses Go, the same principles can work with any compiled language.

#### Next Steps

In the upcoming post, we'll take this solution further by:

- Integrating it with GitHub Actions for automated deployments
- Adding Cloudflare on top of our server to minimize the amount of traffic and process the app has to perform

Stay tuned to see how we can make this simple setup even more robust!
