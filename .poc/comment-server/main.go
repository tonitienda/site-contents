package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

// Small http server that returns a hardcoded HTML content

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("Received request")
		w.Header().Set("Content-Type", "text/html")
		fmt.Fprintf(w, "<h1>Hello, World! %s </h1>", time.Now().Format(time.RFC1123))
	})

	fmt.Println("Starting server on :3001")
	log.Fatal(http.ListenAndServe(":3001", nil))
}
