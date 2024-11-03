#!/bin/bash

config_read() { cat "$CONF" | sed -e '/^#/d' -e '/^$/d'; }
fail() { echo "$@" >&2; exit 1; }

domain_get() { awk '{print $1}'; }
method_get() { awk '{print $2}'; }
method_args_get() { awk '{$1=$2=""; print $0}' | sed 's/^  *//'; }

ip_current_get() {
	local do=1
	local retries=5
	while [ $do -ne 0 ] && [ $retries -ne 0 ]; do
		curl -s https://ipecho.aware.ro
		do=$?
		retries=$(($retries - 1))
	done
}
ip_old_get() { cat $OLDIPCACHE 2>/dev/null; }
ip_old_update() { echo "$1" > $OLDIPCACHE; }

dns_aware() {
	local domain="$1"
	local ip="$2"
	local key_file="$3"
	[ ! -f "$key_file" ] && echo "dns_aware: can't find key file: $key_file" ||\
		curl "https://dns.aware.ro/$(cat $key_file)/chip/$domain/$ip/"
}

dns_hetzner() {
	local domain="$1"
	local ip="$2"
	local key_file="$3"
	local zone_id="$4"
	local record_id="$5"
	[ ! -f "$key_file" ] && echo "dns_hetzner: can't find key file: $key_file" ||\
		curl -H "Auth-API-Token: $(cat $key_file)" -X PUT\
			https://dns.hetzner.com/api/v1/records/$record_id -d '{
				"zone_id": "'"$zone_id"'",
				"type": "A",
				"name": "@",
				"value": "'"$ip"'"
			}'
}

CONF=${CONF:-/etc/gddnsc/domains.conf}
OLDIPCACHE=${OLDIPCACHE:-/tmp/gddnsc.old}

[ ! -f "$CONF" ] && fail "Failed to read configuration"

domains=$(config_read)
ip_current="$(ip_current_get)"
ip_old="$(ip_old_get)"

[ -z "$ip_current" ] && fail "Failed to get current ip"
[ "$ip_old" = "$ip_current" ] && exit 0

ip_old_update $ip_current

OIFS="$IFS"
IFS=$'\n'
for rule in $domains; do
	domain="$(domain_get <<< "$rule")"
	method="$(method_get <<< "$rule")"
	args=$(method_args_get <<< "$rule")

	echo "Updating IP of $domain to $ip_current using dns_$method"
	eval dns_$method "$domain" "$ip_current" $args

done
IFS="$OIFS"