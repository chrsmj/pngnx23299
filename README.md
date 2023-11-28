# pngnx23299
**An Ansible Role for installing FreePBX 17 on Asterisk 20 on Debian 12**

---

> Copyright 2023 Penguin PBX Solutions <chris at penguin p b x dot com>
>
> This file is part of pngnx23299.
>
> pngnx23299 is free software: you can redistribute it and/or modify it under
> the terms of the GNU General Public License as published by the Free Software
> Foundation, either version 3 of the License, or (at your option) any later
> version.
>
> pngnx23299 is distributed in the hope that it will be useful, but WITHOUT ANY
> WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
> A PARTICULAR PURPOSE. See the GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License along with
> pngnx23299. If not, see <https://www.gnu.org/licenses/>. 

---

## New to Asterisk ?

[Asterisk](https://www.asterisk.org) is an open source telecommunications toolkit for VoiP and more, written mostly in C.

## New to FreePBX ?

[FreePBX](https://www.freepbx.org) is a Web GUI for Asterisk, written mostly in PHP and SQL.

With this role, you can install either the FreePBX BETA EDGE tarball or the FreePBX GitHub GIT ZIP files.
These are downloaded by the role from the latest version 17 branches.

By default, the FreePBX GIT ZIPs from GitHub will be installed.
You can change this by setting an Ansible variable in various locations eg. global, per host, on the command line, etc.
(See Variables section below.)

Also by default, this role will only install FLOSS components eg. no non-free or commercial licenses.
This may mean that some things you are used to seeing on FreePBX distros and other installers are missing.
(See Tags section below to change this.)

## New to Debian ?

To proceed with this role, you Must have [Debian GNU/Linux 12 "bookworm"](https://www.debian.org) running on your TARGET
with at least the following tasks selected during installation:

* SSH server
* standard system utilities

There is no need to install any of the Desktop GUI parts on your PBX.
However, installing the web server is a good idea, so please do select:

* web server

Installing Debian is outside the scope of this document.

## New to Ansible ?

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

## Basic First Installation Sample Ansible Playbook <-- TL;DR ? #HELPME #START #HERE

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

## Intermediate Installation Methods

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

## Advanced Invocations

Idempotence is not perfectly supported, but it is fairly well-respected by this role, and so with certain tags you can re-run portions of the role at different times.
The rest of these examples assume that you have passwordless sudo working on TARGET and are connecting to TARGET using currently in-memory SSH keys.

### Tag: extra

Installs the extra FreePBX modules, beyond basic ones from the default basic installation (useful if you skipped this tag previously because you only wanted the basic FreePBX modules -- see above in the Intermediate Installation Methods section):

`$ ansible-playbook -i TARGET, -t extra playbook.yml`

*See detailed list of modules in the default/main/freepbx_modules.yml file.*

### Tag: firewall

Resets only the firewall portions:

`$ ansible-playbook -i TARGET, -t firewall playbook.yml`

*Firewalling via UFW with limited SSH from anywhere and only LAN access to SIP and HTTP/S.*

### Tag: gui

Installs only the FreePBX parts -- potentially useful if you already installed Asterisk, MySQL/MariaDB, Apache, and all other FreePBX package dependencies:

`$ ansible-playbook -i TARGET, -t gui playbook.yml`

*You need to set the web interface admin user/pass using the web GUI immediately after this role is played out.*

### Tag: nonfree

Installs nonfree Asterisk codecs and DAHDI firmware:

`$ ansible-playbook -i TARGET, -t nonfree playbook.yml`

*This role attempts to install only FLOSS software. You will need to explicitly pass command-line tag "nonfree" to install non-free software.*

### Tag: plus

Installs only the rest of the main-line FreePBX modules, beyond basic gui and extra:

`$ ansible-playbook -i TARGET, -t plus playbook.yml`

*See detailed list of modules in the default/main/freepbx_modules.yml file.*

### Tag: splat

Removes most of the Asterisk parts -- must be in combination with uninstall:

`$ ansible-playbook -i TARGET, -t uninstall,splat playbook.yml`

### Tag: star

Installs only the Asterisk parts:

`$ ansible-playbook -i TARGET, -t star playbook.yml`

### Tag: uninstall

Removes most of the FreePBX parts:

`$ ansible-playbook -i TARGET, -t uninstall playbook.yml`

---

#### Notices

*Various trademarks not owned by Penguin PBX Solutions are property of their respective owners and are descriptively used for commentary, identification purposes and trademark parody; and Penguin PBX Solutions claims no rights in these trademarks. No sponsorship from, endorsement by, approval of, or affiliation with any third parties is to be implied by the links and/or mentions on this site, as these links/mentions are simply fair use points of reference.*

Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries. Penguin PBX Solutions is not affiliated with Linus Torvalds.

ASTERISK® and FreePBX® are registered trademarks of Sangoma. Penguin PBX Solutions is not affiliated with Sangoma.

