#!/bin/bash

#
# PJOB date/time functions for pjob.global
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

TIME_NOW="Thu, 01 Jan 1970 00:00:00 +0000"

# functions
#

# TODO: documentation
# TODO: parameter/input sanity checks

function time_test_weekday() {
	local day

	day=$(date -d "$TIME_NOW" "+%u")
	[[ $day -ge 1 && $day -le 5 ]] && return 0

	return 1
}

function time_test_weekend() {
	time_test_weekday || return 0

	return 1
}

function time_test_range() {
	local hour
	local minute
	local low_h
	local low_m
	local high_h
	local high_m

	# current time
	hour=$(date -d "$TIME_NOW" "+%H")
	hour=${hour#0}
	minute=$(date -d "$TIME_NOW" "+%M")
	minute=${minute#0}

	# parse the low/high range
	low_h=$(echo "$1" | cut -d':' -f 1)
	low_h=${low_h#0}
	low_m=$(echo "$1" | cut -d':' -f 2)
	low_m=${low_m#0}
	high_h=$(echo "$2" | cut -d':' -f 1)
	high_h=${high_h#0}
	high_m=$(echo "$2" | cut -d':' -f 2)
	high_m=${high_m#0}

	# do the test
	if [[ $hour -ge $low_h && $hour -le $high_h ]]; then
		if [[ $hour -eq $low_h && $hour -eq $high_h ]]; then
			[[ $minute -ge $low_m && $minute -le $high_m ]] && \
				return 0
			return 1
		fi
		if [[ $hour -eq $low_h ]]; then
			[[ $minute -ge $low_m ]] && return 0
			return 1
		fi
		if [[ $hour -eq $high_h ]]; then
			[[ $minute -le $high_m ]] && return 0
			return 1
		fi
		return 0
	fi

	return 1
}

# library main
#

TIME_NOW=$(TZ=UTC date -R)

# kate: syntax bash;
