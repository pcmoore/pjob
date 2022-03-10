#!/bin/bash

#
# PJOB tmpfs setup for pjob.global
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

# NOTE: The underscore in the name is intentional.  This file can be copied
#       to any system, but on systems where you want to "enable" the tmpfs
#       capability you can remove the underscore, for example:
#
#         % mv pjob.global/_tmpfs.sh pjob.global/tmpfs.sh
#
#       ... this allows you to write jobs that can optionally use a tmpfs
#       mount depending on what the host allows (enable it for hosts with
#       lots of memory, leave is disabled for smaller systems).

# args:
#  0: size
#  1: directory

[[ $1 == "" || $2 == "" ]] && exit 1
[[ ! -d $2 ]] && exit 1

mount -t tmpfs -o size=$1 tmpfs $2
rc=$?
[[ $rc -eq 0 ]] && echo "notice: $1 tmpfs on $2"
exit $rc
