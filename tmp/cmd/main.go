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
