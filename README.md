# pngnx23299
**An Ansible Role for installing FreePBX 17 pre-release on Asterisk 20 on Debian 12**

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
* mainly Asterisk 20 and FreePBX pre-release 17 on Debian 12, so mostly  *
* open source, but can be told to install some non-free codecs/firmware. *
*                                                                        *
*            BEFORE YOU BEGIN, PLEASE ASK YOURSELF IF YOU:               *
*                                                                        *
* 1. Want to test pre-release of most of FreePBX 17, direct from GIT?    *
* 2. Got 5GB of disk space free on your brand new Debian 12 testing box? *
* 3. Can SSH into the box and su to root? (Check your ~/.ssh/config)     *
* 4. Okay with blowing away everything on the target?  REALLY??? Backup? *
* 5. Accept full liability/responsibility for everything that happens?   *
*                                                                        *
*       DO NOT PROCEED UNTIL YOU CAN ANSWER YES TO ALL THE ABOVE.        *
*                                                                        *
* System may reboot automatically if any new/updated packages installed. *
*  Role will continue to run if target comes back online in 10 minutes.  *
*  But, you may need to manually restart the target eg. Virtual Machine. *
*                                                                        *
* WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING * 
*     You are installing bleeding-edge GIT pulled development code!      *
*    Running Online Module Updates will not work very easily at all.     *
*       Some modules may not work without some serious hammering.        *
*       Please do not use outside of your test bench environment.        *
* WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING * 
*                                                                        *
**************************************************************************
```

---

## New to Asterisk ?

Asterisk as an open source telecommunications toolkit for VoiP and more.

## New to FreePBX ?

FreePBX is a Web GUI for Asterisk.

## New to Debian ?

To proceed with this role, you must have Debian GNU/Linux 12 running on your TARGET with the following tasks selected during installation:

* web server
* SSH server
* standard system utilities

Installing Debian is outside the scope of this document.

## New to Ansible ?

You run Ansible playbooks (scripts) on your LOCAL machine.
Then things happen (over SSH) on your TARGET machine.

So on your LOCAL machine...

```
$ sudo apt-get install ansible
```

...should be good enough.

You can check the version number with:

```
$ ansible --version
```

This role was tested on ansible version 2.10.8 on Debian 11.

**PRO-TIP:** Add an entry for TARGET in the ~/.ssh/config file on your LOCAL machine. Ansible uses SSH Host names. This basic ssh command should work with only your password needed on most new Debian 12 installs:

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

A couple of questions will pop-up at the start of the install. Answer those, wait a minute, possibly restart the TARGET when prompted (if it is a virtual machine), then the rest should take care of itself, providing you a link to access the web GUI when finished.

### Tag: uninstall

Removes most of the FreePBX parts:

`ansible-playbook -k -K -i TARGET, -t uninstall playbook.yml`

### Tag: splat

Removes most of the Asterisk parts -- must be in combination with uninstall:

`ansible-playbook -k -K -i TARGET, -t uninstall,splat playbook.yml`

### Tag: gui

Installs the FreePBX parts only:

`ansible-playbook -k -K -i TARGET, -t gui playbook.yml`

### Tag: star

Installs the Asterisk parts only:

`ansible-playbook -k -K -i TARGET, -t star playbook.yml`

### Tag: firewall

Resets the firewall portions only:

`ansible-playbook -k -K -i TARGET, -t firewall playbook.yml`

---

#### Notices

*Various trademarks not owned by Penguin PBX Solutions are property of their respective owners and are descriptively used for commentary, identification purposes and trademark parody; and Penguin PBX Solutions claims no rights in these trademarks. No sponsorship from, endorsement by, approval of, or affiliation with any third parties is to be implied by the links and/or mentions on this site, as these links/mentions are simply fair use points of reference.*

Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries. Penguin PBX Solutions is not affiliated with Linus Torvalds.

ASTERISK® and FreePBX® are registered trademarks of Sangoma. Penguin PBX Solutions is not affiliated with Sangoma.

