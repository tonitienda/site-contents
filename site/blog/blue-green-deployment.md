# Blue green deployment

In this post we will create a simple blue green deployment for our golang app.
Steps:

- Create a simple golang server
- Create a local VM with multipass
- Install nginx in the VM
- Deploy the golang server to the VM
- Switch applications

I assume knowledge in golang and http severs and basic knowledge about nginx (at least that it exists and what it does).

## Simple golang server

Let's first init our go project:

```shell
go mod init bluegreen-demo
```

The official way to init a go mod is using a github repo, but for our use case we are using this simple name.
Let's create our server

```shell
mkdir -p cmd
touch cmd/main.go
```

The server will look like

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

- Read --color and --port flags (required)
- Create two endpoints:
  - healthz: standard endpoint to check if a service is running
  - status: in this demo status will just return the color of the deployment (we will use it later)

We can run a quick test:

```shell
go build -o bluegreendemo cmd/main.go
./bluegreendemo --port 8080 --color orange &
sleep 1
curl http://localhost:8080/status | jq
pkill -f "./bluegreendemo --port 8080 --color orange"
```

(`jq` is optional. I use it to see some color in the json content)

You should see something like:

```json
...
{
  "color": "orange"
}
...
```

## Create a local VM with multipass

First we need to install multipass following the [official docs](https://canonical.com/multipass/install).

For example for MacOS with brew you can just run:

```shell
brew install multipass
```

We will create a VM in our local with:

- Ubuntu 24.04
- 2 CPUs
- 4 GB of RAM
- 15GB of HD

Feel free to tweak your numbers.

Creating the VM is as simple as running the following command:

```shell
multipass launch 24.04 --name bluegreen-demo --cpus 2 --memory 4G --disk 15G
```

After time we should be able to find our VM running:

```shell
multipass list
```

```text
Name                    State             IPv4             Image
bluegreen-demo          Running           192.168.64.8     Ubuntu 24.04 LTS
```

We can open a shell to the VM by doing:

```shell
multipass shell bluegreen-demo
```

We should see a prompt like:

```shell
ubuntu@bluegreen-demo:~$
```

## Install nginx

We need to install nginx in ubuntu.

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
- Checking the status

At the end of the script you should see something like:

```text
Sep 13 10:26:14 bluegreen-demo systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
Sep 13 10:26:14 bluegreen-demo systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
```

## Deploy and start the application in the VM

We will start building the `blue` version of our application.
We will define that `blue` listens on port `8081` and `green` listens on ports `8082`.

- Blue: 8081
- Green: 8082

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
multipass exec bluegreen-demo -- mv bluegreendemo /app/blue
multipass exec bluegreen-demo -- chmod +x /app/blue
multipass exec bluegreen-demo -- /app/blue --port 8081 --color blue &
```

This script builds the server, transfers it to the VM and executes it with the `blue` settings.

We can test that it is running by accessing `http://<vm ip>:8081/status`

To do so we can do:

```shell
VM_IP=$(multipass info bluegreen-demo | grep IPv4 | awk '{print $2}')

curl http://$VM_IP:8081/status | jq
```

(again `jq` is optional)

We have now our blue version running in the VM.

## Configure nginx to server our application

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
```
