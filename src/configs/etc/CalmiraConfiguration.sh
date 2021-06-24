#!/bin/bash
# Core Functions for BASH interpreter
#
# (C) 2021 Michail Linuxoid85 Krasnov <linuxoid85@gmail.com>
# For Calmira GNU/Linux
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

#=============================================================
#
# FUNCTIONS
#

# Function for print Calmira GNU/Linux version
GetCalmiraVersion() {
	if [ -f "/etc/lsb-release" ]; then
		source /etc/lsb-release
		echo "$DISTRIB_RELEASE"
		
	elif [ -f "/etc/CalmiraVersion" ]; then
		source /etc/CalmiraVersion
		echo $CALMIRA_VERSION
		
	elif [ -f "/etc/os-release" ]; then
		cat /etc/os-release |grep 'VERSION'
		
	fi
}

#=============================================================
#
# ALIASES
#
alias GetDate=$(date)
