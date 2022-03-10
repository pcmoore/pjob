#!/bin/bash

#
# PJOB IPMI functions for pjob.global
# Paul Moore <paul@paul-moore.com>
#
# (c) Copyright Paul Moore, 2022
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# config
#

# N/A

# functions
#

function ipmi_cmd() {
	local ipmi=$1
	local user=$2
	local passwd=$3
	shift 3

	ipmitool -I lanplus -H $ipmi -U $user -P $passwd $*
}

# TODO: documentation
# TODO: parameter/input sanity checks

function ipmi_lookup() {
	local host
	local ipmi
	local user
	local passwd

	# go through everything in the configuration
	for i in $PJOB_HOSTS_IPMI; do
		host=$(echo "$i" | cut -d',' -f 1)
		ipmi=$(echo "$i" | cut -d',' -f 2)
		user=$(echo "$i" | cut -d',' -f 3)
		passwd=$(echo "$i" | cut -d',' -f 4)

		if [[ $1 == $host || $1 == $ipmi ]]; then
			echo "$i"
			return 0
		fi
	done

	# nothing matched
	return 1
}

function ipmi_lookup_field() {
	local rc
	local val

	# sanity check
	[[ $1 == "" || $2 == "" ]] && return 1

	val=$(ipmi_lookup "$1")
	rc=$?
	[[ $rc -eq 0 ]] && (echo "$val" | cut -d',' -f $2)
	return $rc
}

function ipmi_lookup_host() {
	ipmi_lookup_field "$1" 1
	return $?
}

function ipmi_lookup_ipmi() {
	ipmi_lookup_field "$1" 2
	return $?
}

function ipmi_lookup_user() {
	ipmi_lookup_field "$1" 3
	return $?
}

function ipmi_lookup_passwd() {
	ipmi_lookup_field "$1" 4
	return $?
}

function ipmi_host_exist() {
	ipmi_lookup "$1" > /dev/null
	return $?
}

function ipmi_power_set() {
	local rc
	local ipmi
	local user
	local passwd

	# get the ipmi info
	ipmi=$(ipmi_lookup_ipmi "$1")
	rc=$?
	[[ $rc -ne 0 ]] && return $rc
	user=$(ipmi_lookup_user "$1")
	rc=$?
	[[ $rc -ne 0 ]] && return $rc
	passwd=$(ipmi_lookup_passwd "$1")
	rc=$?
	[[ $rc -ne 0 ]] && return $rc

	case $2 in
	on)
		# issue the power-on and sleep for a few seconds
		ipmi_cmd $ipmi $user $passwd power on &> /dev/null
		rc=$?
		[[ $rc -eq 0 ]] && sleep 5
		;;
	off)
		# attempt a soft shutdown before forcing off after a delay
		ipmi_cmd $ipmi $user $passwd power soft &> /dev/null
		local count=0
		while [[ $count -lt 120 ]]; do
			sleep 10
			ipmi_cmd $ipmi $user $passwd power status | \
				grep -q "off"
			if [[ $? -ne 0 ]]; then
				count=$(( $count + 10 ))
			else
				count=120
			fi
		done
		ipmi_cmd $ipmi $user $passwd power off &> /dev/null
		rc=$?
		;;
	*)
		# default
		rc=1
	esac

	return $rc
}

function ipmi_power_get() {
	local rc
	local ipmi
	local user
	local passwd

	# get the ipmi info
	ipmi=$(ipmi_lookup_ipmi "$1")
	rc=$?
	[[ $rc -ne 0 ]] && return $rc
	user=$(ipmi_lookup_user "$1")
	rc=$?
	[[ $rc -ne 0 ]] && return $rc
	passwd=$(ipmi_lookup_passwd "$1")
	rc=$?
	[[ $rc -ne 0 ]] && return $rc

	# issue the power-on and sleep for a few seconds
	case $(ipmi_cmd $ipmi $user $passwd power status) in
	*on*)
		echo "on"
		rc=0
		;;
	*off*)
		echo "off"
		rc=0
		;;
	*)
		echo "unknown"
		rc=1
	esac

	return $rc
}

# library main
#

# N/A

# kate: syntax bash;
