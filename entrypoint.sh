#!/usr/bin/env sh

set -ex

# dockerhost
echo -e "`/sbin/ip route | awk '/default/ { print $3 }'`\tdockerhost" | tee -a /etc/hosts > /dev/null

exec -- /usr/bin/caddy -email $APPLICANT_EMAIL "$@"
