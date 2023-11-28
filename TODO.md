# TODO

* DAHDI builds but is not loaded at boot -- need systemd setup (and wanpipe too)
* uninstall and splat tags should do more uninstalling
* remove old asterisk modules from /usr/lib/asterisk/modules/ when upgrading major versions
* IPv6 mostly in the firewall parts
* refactor the FreePBX module install to loop better
* move libdir to 64 bits (or whatever the target is)
* outbound exim email server setup
* letsencrypt setup for HTTPS, or at least certs on the VLAN
* T.38 faxing and PDF conversion
* pat fleet sounds
* probably should expand beyond tags/vars into a series of roles with different playbooks
* template out places where branding is an issue
* TFTP separated out in firewall, controlled probably in the network.yml defaults var file
* /etc/hosts needs adjustment when domain name changes (only issue in cloned test VMs ??)
* reduce number of FreePBX reloads/restarts
* use git clone for development environment in addition to git zip downloads (maybe in /srv or /home ?)

## phoneprov
* phoneprov should probably be a FreePBX module with proxying via Apache instead of NGINX
* syslog on the VLAN for the phones
* HTTP PUTs on the VLAN for the phones
* use the timezone vars
