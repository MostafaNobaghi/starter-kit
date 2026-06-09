#!/usr/bin/env bash
# Run once per machine after cloning the repo.
# Configures *.codespacex.ir to resolve locally so requests never touch
# your internet DNS — keeping them fast regardless of network quality.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if systemctl is-active --quiet dnsmasq 2>/dev/null; then
    # ----------------------------------------------------------------
    # Path A: a dnsmasq service is already running on this machine.
    # Add a drop-in config so it handles codespacex.ir too.
    # The Docker dnsmasq container is not needed in this case.
    # ----------------------------------------------------------------
    echo "Existing dnsmasq detected — adding codespacex.ir config to it."

    sudo tee /etc/dnsmasq.d/codespacex.conf > /dev/null << 'EOF'
# Never forward codespacex.ir upstream
local=/codespacex.ir/

# All *.codespacex.ir → 127.0.0.1 (nginx on host, port 80)
address=/codespacex.ir/127.0.0.1
EOF

    sudo systemctl reload dnsmasq

    echo ""
    echo "Done. Your existing dnsmasq now handles *.codespacex.ir."
    echo "You do not need to start the dnsmasq Docker container:"
    echo "  docker compose up -d mariadb postgres redis ... nginx"
    echo "  (omit dnsmasq from the list)"

else
    # ----------------------------------------------------------------
    # Path B: no local dnsmasq — use the Docker container.
    # Tell systemd-resolved to forward codespacex.ir queries to it.
    # ----------------------------------------------------------------
    echo "Configuring systemd-resolved to use the dnsmasq Docker container ..."

    sudo mkdir -p /etc/systemd/resolved.conf.d
    sudo tee /etc/systemd/resolved.conf.d/codespacex.conf > /dev/null << 'EOF'
[Resolve]
DNS=127.0.0.2
Domains=~codespacex.ir
EOF

    sudo systemctl restart systemd-resolved

    echo ""
    echo "Done. Start the dnsmasq container if it isn't running yet:"
    echo "  docker compose up -d dnsmasq"
fi

echo ""
echo "Also disable DNS-over-HTTPS in your browser (it bypasses the system resolver):"
echo "  Firefox : about:config  ->  network.trr.mode = 5"
echo "  Chrome  : Settings -> Privacy and security -> Security -> disable 'Use secure DNS'"
