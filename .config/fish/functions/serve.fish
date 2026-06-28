function serve -d "Quick HTTP server in current directory (default port 8080)"
    set -l port 8080
    if test (count $argv) -gt 0
        set port $argv[1]
    end
    set -l ip (ipconfig getifaddr en0 2>/dev/null; or hostname -I | awk '{print $1}')
    echo "Serving on:"
    echo "  http://localhost:$port"
    echo "  http://$ip:$port"
    python3 -m http.server $port
end
