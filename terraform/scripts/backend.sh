#!/bin/bash
apt update -y
apt install -y python3 python3-pip

cat <<EOF >/home/backend.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(b"Backend Tier Working!")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), Handler)
    server.serve_forever()
EOF

nohup python3 /home/backend.py &
