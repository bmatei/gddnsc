## Generic Dynamic DNS Client

Minimal shell script intented to run on machines with volatile IP addresses.

It's purpose is to update the DNS configuration by calling particular service with the new IP address after it has changed.

This repo includes a systemd integration running this script at boot time and then hourly: if IP address has changed since last run then all configured domains get updated with the new address.

Configuration allows for multiple domains to be handled each with it's own DNS hosting service.

Currently there are just a few DNS services supported, but more can very easily be added. Just read the script it's really not that complicated.

Supported DNS Services:
 * Aware DNS -- https://github.com/AwareRO/owndyndns/blob/main/README.md
 * Hetzner DNS -- https://dns.hetzner.com/api-docs


## Configuration
```
################################################
# domain dns_update_method method_specific_args#
################################################


# Method: aware
# args: key_file

# Method: hetzner
# args: key_file zone_id record_id
```