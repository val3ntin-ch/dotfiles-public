function myip -d "Show local and public IP addresses"
    set -l local_ip
    if test (uname) = Darwin
        set local_ip (ipconfig getifaddr en0 2>/dev/null; or ipconfig getifaddr en1 2>/dev/null; or echo N/A)
    else
        set local_ip (ip route get 1 2>/dev/null | awk '{print $7}'; or echo N/A)
    end
    set -l public_ip (curl -s --max-time 3 https://api.ipify.org 2>/dev/null; or echo N/A)
    printf "Local:  %s\nPublic: %s\n" $local_ip $public_ip
end
