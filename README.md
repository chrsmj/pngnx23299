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

```
**************************************************************************
*                                                                        *
* Welcome to pngnx23299!  Copyright 2023 GPLv3+ by Penguin PBX Solutions *
*                                                                        *
* This Ansible Role helps install software written/copyright by others,  *
* mainly Asterisk 20 and FreePBX 17 (BETA / GIT) on Debian 12, so mostly *
* open source, but can be told to install some non-free codecs/firmware. *
*                                                                        *
*            BEFORE YOU BEGIN, PLEASE ASK YOURSELF IF YOU:               *
*                                                                        *
* 1. Want to test the most recent FreePBX 17, BETA or direct from GIT?   *
* 2. Got 5GB of disk space free on your brand new Debian 12 testing box? *
* 3. Can SSH into the box and su to root? (Check your ~/.ssh/config)     *
* 4. Okay with blowing away everything on the target?  REALLY??? Backup? *
* 5. Accept full liability/responsibility for everything that happens?   *
*                                                                        *
*       DO NOT PROCEED UNTIL YOU CAN ANSWER YES TO ALL THE ABOVE.        *
*                                                                        *
*  System may reboot automatically if kernel was updated in first steps. *
*  Role will continue to run if target comes back online in 10 minutes.  *
*  But, you may need to manually restart the target eg. Virtual Machine. *
*                                                                        *
* WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING * 
*   You are installing bleeding-edge BETA/GIT pulled development code!   *
*    Running Online Module Updates will not work very easily at all.     *
*       Some modules may not work without some serious hammering.        *
*       Please do not use outside of your test bench environment.        *
* WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING * 
*                                                                        *
**************************************************************************
```

---

## New to Asterisk ?

[Asterisk](https://www.asterisk.org) as an open source telecommunications toolkit for VoiP and more, written mostly in C.

## New to FreePBX ?

[FreePBX](https://www.freepbx.org) is a Web GUI for Asterisk, written mostly in PHP and SQL.

With this role, you can install either the BETA EDGE tarball or the GIT ZIP files. These are downloaded by the role from the latest version 17 branches.

By default, the GIT ZIPs will be installed. You can change this by setting an Ansible variable
in various locations eg. global, per host, on the command line, etc. (See Variables section below.)

Also by default, this role will only install FLOSS components eg. no non-free or commercial licenses. This may mean that some things you are used to seeing on FreePBX distros and other installers are missing. (See Tags section below to change this.)

## New to Debian ?

To proceed with this role, you Must have [Debian GNU/Linux 12 "bookworm"](https://www.debian.org) running on your TARGET with the following tasks selected during installation:

* SSH server
* standard system utilities

Probably it is a good idea to also select:

* web server

Installing Debian is outside the scope of this document.

## New to Ansible ?

You run [Ansible](https://www.ansible.com) playbooks (scripts) on your LOCAL machine. Then things happen (over SSH) on your TARGET machine(s).

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

**PRO-TIP:** Add an entry for TARGET in the ~/.ssh/config file on your LOCAL machine. Ansible uses SSH Host names. The following basic ssh command should work with only your password needed on most new Debian 12 installs:

```
$ ssh TARGET
```

*If you can SSH to the TARGET, then Ansible can do the rest.*

## Sample Ansible Playbook

Download this role and unzip it:

```
$ mkdir -p ~/ansible-sample/roles
$ cd ~/ansible-sample
$ wget https://github.com/chrsmj/pngnx23299/archive/refs/heads/main.zip
$ unzip main.zip
$ mv pngnx23299-main roles/pngnx23299
```

Next, make a new file **playbook.yml** in the top directory so it is along-side the roles directory:

```
$ cd ~/ansible-sample
$ cat <<EOF>playbook.yml
---
# file: playbook.yml
- hosts: all
  roles:
    - roles/pngnx23299
EOF
```

Look at the contents of the directory:

```
$ cd ~/ansible-sample
$ ls
main.zip  playbook.yml  roles
```

Look inside of roles/ directory:

```
$ cd ~/ansible-sample
$ ls roles
pngnx23299
```

Look inside of roles/pngnx23299/ directory:

```
$ cd ~/ansible-sample
$ ls roles/pngnx23299
defaults  files  LICENSE  meta  README.md  tasks  TODO.md
```

*The README.md is this file!* :cowboy:

---

## Sample Invocations

Different tags in this role allow finer-grained control of the operations.

### Basic Installation

Run this on your LOCAL machine:

`$ ansible-playbook --become-method=su -k -K -i TARGET, playbook.yml`

You will be prompted for your SSH password. Type it in and press Enter. Then you will be prompted for the root password. Type it in and press Enter.

One confirmation prompt question will pop-up at the start of the install. Answer that, wait a minute, possibly restart the TARGET if prompted (or if it does not reboot cleanly automatically eg. some virtual machines), then the rest should take care of itself, providing you a link to access the web GUI when finished (in about 15 minutes on modern hardware.)

### Variable: freepbx_upstream=edge

Installs system but uses BETA EDGE tarball instead of ZIP files pulled from FreePBX GIT:

`$ ansible-playbook --become-method=su -k -K -i TARGET, -e freepbx_upstream=edge playbook.yml`

*Currently (2 November 2023) the edge tarball is installing properly, but some modules are buggy.*

### Tag: extra

Installs only the extra FreePBX modules, beyond basic ones from the default basic installation:

`ansible-playbook -k -K -i TARGET, -t extra playbook.yml`

*See detailed list of modules in the default/main/freepbx_modules.yml file.*

### Tag: firewall

Resets only the firewall portions:

`ansible-playbook -k -K -i TARGET, -t firewall playbook.yml`

*Firewalling via UFW with limited SSH from anywhere and only LAN access to SIP and HTTP/S.*

### Tag: gui

Installs only the FreePBX parts.

`ansible-playbook -k -K -i TARGET, -t gui playbook.yml`

*You need to set the web interface admin user/pass using the web GUI immediately after this role is played out.*

### Tag: nonfree

Installs nonfree Asterisk codecs and DAHDI firmware:

`ansible-playbook -k -K -i TARGET, -t nonfree playbook.yml`

*This role attempts to install only FLOSS software. You will need to explicitly pass command-line tag "nonfree" to install non-free software.*

### Tag: plus

Installs only the rest of the main-line FreePBX modules, beyond basic gui and extra:

`ansible-playbook -k -K -i TARGET, -t plus playbook.yml`

*See detailed list of modules in the default/main/freepbx_modules.yml file.*

### Tag: splat

Removes most of the Asterisk parts -- must be in combination with uninstall:

`ansible-playbook -k -K -i TARGET, -t uninstall,splat playbook.yml`

### Tag: star

Installs only the Asterisk parts:

`ansible-playbook -k -K -i TARGET, -t star playbook.yml`

### Tag: uninstall

Removes most of the FreePBX parts:

`ansible-playbook -k -K -i TARGET, -t uninstall playbook.yml`

### Skip Tags: extra,plus

Installs but with limited FreePBX modules -- just enough to send and receive calls:

`ansible-playbook -k -K -i TARGET, --skip-tags extra,plus playbook.yml`

*See detailed list of modules in the default/main/freepbx_modules.yml file.*

---

#### Notices

*Various trademarks not owned by Penguin PBX Solutions are property of their respective owners and are descriptively used for commentary, identification purposes and trademark parody; and Penguin PBX Solutions claims no rights in these trademarks. No sponsorship from, endorsement by, approval of, or affiliation with any third parties is to be implied by the links and/or mentions on this site, as these links/mentions are simply fair use points of reference.*

Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries. Penguin PBX Solutions is not affiliated with Linus Torvalds.

ASTERISK® and FreePBX® are registered trademarks of Sangoma. Penguin PBX Solutions is not affiliated with Sangoma.

