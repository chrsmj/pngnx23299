#!/bin/bash
#
# SPDX-FileCopyrightText: 2024 Penguin PBX Solutions <chris at penguin p b x dot com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Bootstrap of Ansible to auto-install PNGNX23299.
#
# You can run this directly on your TARGET machine.
# But it is mostly used for testing Docker CI in github.

LOG_FOLDER="/var/log/pbx"
LOG_FILE="${LOG_FOLDER}/freepbx17-install-pngnx23299-$(date '+%Y.%m.%d-%H.%M.%S').log"

# Check if we are bash shell
if [ "${EUID}" = "" ]; then
  echo "This script must be run in bash"
  exit 1
fi

# Check if we are root privileged
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Initialize logging
mkdir -p "${LOG_FOLDER}"
echo "" > $LOG_FILE

# The rest will tee to the log
{

echo -n "START: " && date

# Include executed commands in the log
set -x

cd /root || exit

# Bootstrap minimal Ansible install, plus git, python3, and lsb-release
# apt-get -qq install ansible git python3 lsb-release

# Assume we only downloaded this shell script, so get the repo
git clone https://github.com/chrsmj/pngnx23299.git

# Get to the right branch in the repo
cd pngnx23299/ || exit
git checkout main

# Run the Ansible playbook locally (normally over SSH from CONTROL to TARGET)
# Only doing enough to build Asterisk in this Docker CI pipeline
ansible-playbook \
  --inventory localhost, \
  --become-method=su \
  --connection=local \
  --extra-vars "pngnx_update_kernel=false" \
  --tags packages,star \
  playbook.yml

# Clean up the Ansible bits (mostly python libs)
# apt-get -qq remove ansible
# apt-get -qq autoremove

# Finish the command logging
set +x

echo -n "STOP: " && date

} 2>&1 | tee -a $LOG_FILE
