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
* hold tone option 425Hz .2 on .2 off .2 on 3.4 off
* ring back dialing internal phones 440+480 1 on 3 off / external telco 440+480 2 on 4 off
* beep 880Hz .1s / boop 440Hz .1s / bloop 840+500 .1s / doorbell 800Hz .075 400Hz .050 / doorbell chord 1450+725 .075 725+360 .050
* honk 500+700 .1s / tumbleweed 1000 .020 800 .020 600 .020
* probably should expand beyond tags/vars into a series of roles with different playbooks
* template out places where branding is an issue
* TFTP separated out in firewall, controlled probably in the network.yml defaults var file
* /etc/hosts needs adjustment when domain name changes (only issue in cloned test VMs ??)
* reduce number of FreePBX reloads/restarts
* use git clone for development environment in addition to git zip downloads (maybe in /srv or /home ?)
* add app_softmodem
* add FreePBX modules for res_speech_vosk, app_espeak, app_flite (ASR and TTS)
* better DNS support
* geolocation, for emergency calling improvements
* geolocation, for IP address blocking
* STIR/SHAKEN
* make systemd Conflicts with Asterisk service?
* git clone each module from freepbx GitHub, to make it easier to patch
* initial web user should be available to auto-generate [see](https://community.freepbx.org/t/create-1st-admin-user-from-cli/65133)
* ARI interfaces
* Wazo repo

## phoneprov
* phoneprov should probably be a FreePBX module with proxying via Apache instead of NGINX
* HTTP PUTs on the VLAN for the phones
* use the timezone vars
* automatically add the entries for new phones configured via GUI in a /etc/asterisk/phones.d/ directory,
  as they boot up via DNSMASQ command (currently a TODO with simple MAC/IP echo to syslogh)
