import http.server
import socketserver
import webbrowser
import os
import sys

# Check if port is provided as command line argument
if len(sys.argv) > 1:
    PORT = int(sys.argv[1])
else:
    PORT = 8005  # Default port

handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), handler) as httpd:
    print(f"Serving at http://localhost:{PORT}")
    webbrowser.open(f"http://localhost:{PORT}/index.html")
    httpd.serve_forever()
