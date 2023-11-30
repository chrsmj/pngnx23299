# pngnx23299
**An Ansible Role for installing FreePBX 17 on Asterisk 20 on Debian 12**

Currently for testing purposes only.

Designed to get a few desk phones quickly ringing by manually configuring them in FreePBX and then allowing the PBX to (mostly) auto-provision them on a private, dedicated voice VLAN where the PBX acts as the DHCP and NTP server.

---

# Table of Contents

1. [License](#license)
2. New to ... [Asterisk ?](#new-to-asterisk-) [FreePBX ?](#new-to-freepbx-) [Debian ?](#new-to-debian-) [Ansible ?](#new-to-ansible-)
3. [Basic Installation](#basic-installation)
4. [Advanced Installation](#advanced-installation): [Variable: freepbx_upstream](#variable-freepbx_upstream) | [Skip Tags: extra,plus](#skip-tags-extraplus)
5. [Fine Tuning with Tags](#fine-tuning-with-tags): [apache](#tag-apache) | [catbert](#tag-catbert) | [confirm](#tag-confirm) | [dahdi](#tag-dahdi) | [db](#tag-db) | [drwho](#tag-drwho) | [extra](#tag-extra) | [firewall](#tag-firewall) | [gui](#tag-gui) | [logrotate](#tag-logrotate) | [nonfree](#tag-nonfree) | [nopants](#tag-nopants) | [packages](#tag-packages) | [phoneprov](#tag-phoneprov) | [plus](#tag-plus) | [splat](#tag-splat) | [star](#tag-star) | [tests](#tag-tests) | [uninstall](#tag-uninstall) | [vlan](#tag-vlan)

---

## License

Copyright 2023 Penguin PBX Solutions <chris at penguin p b x dot com>

This file is part of pngnx23299.

pngnx23299 is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

pngnx23299 is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
pngnx23299. If not, see <https://www.gnu.org/licenses/>. 

---

## New to ... ?

### New to Asterisk ?

[Asterisk](https://www.asterisk.org) is an open source telecommunications toolkit for VoiP and more, written mostly in C.

### New to FreePBX ?

[FreePBX](https://www.freepbx.org) is a Web GUI for Asterisk, written mostly in PHP and SQL.

With this role, you can install either the FreePBX BETA EDGE tarball or the FreePBX GitHub GIT ZIP files.
These are downloaded by the role from the latest version 17 branches.

By default, the FreePBX GIT ZIPs from GitHub will be installed.
You can change this by setting an Ansible variable called '[freepbx_upstream](#variable-freepbx_upstream)' in various locations eg. global, per host, on the command line, etc.

Also by default, this role will only install FLOSS components eg. no non-free or commercial licenses.
This may mean that some things you are used to seeing on FreePBX distros and other installers are missing.
You can change this by running the role again post-install using an Ansible tag called '[nonfree](#tag-nonfree)'.

### New to Debian ?

To proceed with this role, you Must have [Debian GNU/Linux 12 "bookworm"](https://www.debian.org) running on your TARGET
with at least the following tasks selected during installation:

* SSH server
* standard system utilities

There is no need to install any of the Desktop GUI parts on your PBX.
However, installing the web server is a good idea, so please do select:

* web server

Installing Debian is outside the scope of this document.

### New to Ansible ?

You run [Ansible](https://www.ansible.com) playbooks (scripts) on your LOCAL machine.
Then things happen (over SSH) on your TARGET machine(s).

So on your LOCAL machine...

```
$ sudo apt-get install ansible sshpass
```

...should be good enough.

You can check the version number with:

```
$ ansible --version
```

This role was tested initially with ansible version 2.10.8 on Debian 11 and currently with version 2.14.3 on Debian 12.

**PRO-TIP:**
Add an entry for TARGET in the ~/.ssh/config file on your LOCAL machine.
This works because Ansible and SSH are friends! Ansible uses SSH Host names.
The following basic ssh command should work with only your password needed on most new Debian 12 installs:

```
$ ssh TARGET
```

*If you can SSH to the TARGET, then Ansible can do the rest.*

**PRO-TIP 2:**
Now is a good time to setup SSH keys and add those to the IdentityFile line in your ~/.ssh/config file.

---

## Basic Installation

Replace TARGET with the SSH Host name you will be installing on, and run these commands:

```
$ wget https://github.com/chrsmj/pngnx23299/archive/refs/tags/v0.23.28-alpha.tar.gz
$ tar xvzf v0.23.28-alpha.tar.gz
$ cd pngnx23299-0.23.28-alpha
$ ansible-playbook --become-method=su -k -K -i TARGET, playbook.yml
```

You will be prompted for your SSH password for TARGET. Type it in and press Enter.
Then you will be prompted for the root password. Type it in and press Enter.

One confirmation prompt question will pop-up at the start of the install.
Answer that, wait a minute, and possibly restart the TARGET if prompted.
(Sometimes TARGET does not reboot cleanly automatically eg. some virtual machines.)

The rest should take care of itself, providing you a link to access the web GUI when finished.
Typically, the install takes about 15-30 minutes on modern PBX DIY'er hardware.

**PRO-TIP 3:**
Always keep an SSH connection alive in another terminal when making changes that involve SSH eg. installing this system.
Then test-drive a new SSH connection when done, just to make sure you can still get in.

---

## Advanced Installation

Different variables and tags in this role allow finer-grained control of the operations.

### Variable: freepbx_upstream

Installs system but changes upstream source, to either 'edge' or 'git'.

To use the BETA EDGE tarball:

`$ ansible-playbook --become-method=su -k -K -i TARGET, -e freepbx_upstream=edge playbook.yml`

Or, to use ZIP files pulled from new FreePBX GIT repo on GitHub (this is the default if not specified):

`$ ansible-playbook --become-method=su -k -K -i TARGET, -e freepbx_upstream=git playbook.yml`

*Currently (28 November 2023) both the edge tarball and the new github zips are installing properly, but some modules are buggy.*

### Skip Tags: extra,plus

Installs but with limited FreePBX modules -- just enough to send and receive calls:

`$ ansible-playbook --become-method=su -k -K -i TARGET, --skip-tags extra,plus playbook.yml`

*See detailed list of modules in the default/main/freepbx_modules.yml file.*

---

## Fine Tuning with Tags

Idempotence is not perfectly supported, but it is fairly well-respected by this role, and so with certain Tags you can re-run portions of the role at different times.
The rest of these examples assume that you have passwordless sudo working on TARGET and are connecting to TARGET using currently in-memory SSH keys.

### Tag: apache

Prepares Apache webserver for FreePBX installation (but does not actually install Apache):

`$ ansible-playbook -i TARGET, -t apache playbook.yml`

### Tag: catbert

Adds some users and groups, fixes up some permissions, and prepares Asterisk configuration for fresh FreePBX installation:

`$ ansible-playbook -i TARGET, -t catbert playbook.yml`

### Tag: confirm

Confirmation steps at the beginning of the installation. Most often this would be used in the negative to skip the confirmation steps; such as during a completely automated install, or if you want to force install on a non-Debian 12 system (not recommended unless you really know what you are doing):

`$ ansible-playbook -i TARGET, --skip-tags confirm playbook.yml`

### Tag: dahdi

Builds and installs only the DAHDI hardware drivers:

`$ ansible-playbook -i TARGET, -t dahdi playbook.yml`

### Tag: db

Prepares MySQL/MariaDB for use by FreePBX including ODBC configuration (but does not actually install MySQL/MariaDB):

`$ ansible-playbook -i TARGET, -t db playbook.yml`

### Tag: drwho

Installs and configures ChronyD as the Network Time Protocol (NTP) server on LANs and/or VLANs:

`$ ansible-playbook -i TARGET, -t drwho playbook.yml`

### Tag: extra

Installs the extra FreePBX modules, beyond basic ones from the default basic installation (useful if you skipped this tag previously because you only wanted the basic FreePBX modules -- see above in the [Advanced Installation](#advanced-installation) section). *See detailed list of modules in the default/main/freepbx_modules.yml file*:

`$ ansible-playbook -i TARGET, -t extra playbook.yml`

### Tag: firewall

Resets only the firewall portions. *Firewalling via UFW with limited SSH from anywhere and only LAN access to SIP and HTTP/S*:

`$ ansible-playbook -i TARGET, -t firewall playbook.yml`

### Tag: logrotate

Configures log rotation policies for Asterisk and FreePBX log files, with some reasonable defaults:

`$ ansible-playbook -i TARGET, -t logrotate playbook.yml`

### Tag: gui

Installs only the FreePBX parts -- potentially useful if you already installed Asterisk, MySQL/MariaDB, Apache, and all other FreePBX package dependencies. *You need to set the web interface admin user/pass using the web GUI immediately after this role is played out*:

`$ ansible-playbook -i TARGET, -t gui playbook.yml`

### Tag: nonfree

Installs nonfree Asterisk codecs and DAHDI firmware. *By default, this role attempts to install only FLOSS software. You will need to explicitly pass command-line tag "nonfree" to install non-free software*:

`$ ansible-playbook -i TARGET, -t nonfree playbook.yml`

### Tag: nopants

Only used in combination with the [uninstall tag](#tag-uninstall) to stop the firewall parts (not recommended):

`$ ansible-playbook -i TARGET, -t uninstall,nopants playbook.yml`

### Tag: packages

Updates and installs needed Debian packages using apt:

`$ ansible-playbook -i TARGET, -t packages playbook.yml`

### Tag: phoneprov

Automates phone provisioning of certain Aastra, Polycom and SNOM phones; using an NGINX front-end proxy to the backend Asterisk HTTP server and PJSIP phoneprov modules, utilized to serve up some Penguin PBX Solutions customized template files for the phones. *See the /etc/asterisk/pjsip.endpoint_custom_post.conf file for a sample for how to configure your phones to auto-provision. This sample is installed as part of the [basic installation](#basic-installation)*:

`$ ansible-playbook -i TARGET, -t phoneprov playbook.yml`

### Tag: plus

Installs only the rest of the main-line FreePBX modules, beyond basic gui and extra. *See detailed list of modules in the default/main/freepbx_modules.yml file*:

`$ ansible-playbook -i TARGET, -t plus playbook.yml`

### Tag: splat

Removes most of the Asterisk parts -- must be in combination with uninstall:

`$ ansible-playbook -i TARGET, -t uninstall,splat playbook.yml`

### Tag: star

Installs only the Asterisk parts:

`$ ansible-playbook -i TARGET, -t star playbook.yml`

### Tag: tests

Runs a test or two. Debugging use only:

`$ ansible-playbook -i TARGET, -t tests playbook.yml`

### Tag: uninstall

Removes most of the FreePBX parts:

`$ ansible-playbook -i TARGET, -t uninstall playbook.yml`

### Tag: vlan

Installs and configures dnsmasq to provide DHCP server functions on a VLAN to help the phones auto-provision. *Ideally you should only need to configure the phone on to the VLAN, wait as it reboots, and in a few minutes start making calls. See the defaults/main/network.yml variables file in this role for configuration options*:

`$ ansible-playbook -i TARGET, -t vlan playbook.yml`

---

#### Notices

*Various trademarks not owned by Penguin PBX Solutions are property of their respective owners and are descriptively used for commentary, identification purposes and trademark parody; and Penguin PBX Solutions claims no rights in these trademarks. No sponsorship from, endorsement by, approval of, or affiliation with any third parties is to be implied by the links and/or mentions on this site, as these links/mentions are simply fair use points of reference.*

Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries. Penguin PBX Solutions is not affiliated with Linus Torvalds.

ASTERISK® and FreePBX® are registered trademarks of Sangoma. Penguin PBX Solutions is not affiliated with Sangoma.

