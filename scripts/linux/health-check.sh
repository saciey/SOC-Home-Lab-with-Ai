#!/usr/bin/env bash
# Read-only educational service health check, not historically executed.
set -u
printf 'SOC lab health snapshot: %s\n' "$(date -Is)"
hostnamectl || true
ip -br address || true
ip route || true
free -h
df -h
systemctl --failed --no-pager || true
for svc in wazuh-manager wazuh-indexer wazuh-dashboard filebeat; do
  printf '\n--- %s ---\n' "$svc"
  systemctl is-active "$svc" || true
  systemctl status "$svc" --no-pager -n 4 || true
done
sudo ss -ltnp | grep -E ':(1514|1515|443|9200|55000|3000|20211)\\b' || true
if command -v docker >/dev/null 2>&1; then sudo docker ps -a; fi
echo "Check end-to-end event flow separately. Service state is not enough."
