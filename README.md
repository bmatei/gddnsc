## Generic Dynamic DNS Client

Minimal shell script intented to run on machines with volatile IP addresses.

It's purpose is to update the DNS configuration by calling particular service with the new IP address after it has changed.

This repo includes a systemd integration running this script at boot time and then hourly: if IP address has changed since last run then all configured domains get updated with the new address.

Configuration allows for multiple domains to be handled each with it's own DNS hosting service.

Currently there are just a few DNS services supported, but more can very easily be added. Just read the script it's really not that complicated.

Supported DNS Services:
 * Aware DNS -- https://github.com/AwareRO/owndyndns/blob/main/README.md
 * Hetzner DNS -- https://dns.hetzner.com/api-docs

## Install
Check out the releases. There is a debian `.deb` version (for apt/dpkg) and a generic `.tar.gz` for everyone else. If you want me to support more package formats send me a request at matei@busui.ro

For more generic instructions:
 * the `.sh` file goes anywhere in `PATH`
 * the systemd files (`.service` and `.timer`) go in `/etc/systemd/system` or `/lib/systemd/system`

## Configuration
Default configuration goes in `/etc/gddnsc/domains.conf`. If you want to change that set `CONF` environment variable to a different file.

`domains.conf` format:
```
################################################
# domain dns_update_method method_specific_args#
################################################


# Method: aware
# args: key_file

# Method: hetzner
# args: key_file zone_id record_id
```

Example:
```
some.example.com hetzner /etc/gddnsc/hetzner.key <hetzner-zone-id-for-example.com> <hetzner-record-id-for-A-of-some.example.com>
```
