#!/bin/bash

#  Copyright 2007-2011 Simon Hürlimann <simon.huerlimann@cyt.ch>
#  Copyright 2007-2011 ZytoLabor <info@zyto-labor.com>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

# Libraries
source $(dirname $0)/lib_hozr.sh

# Read config file
CONFIG_FILE=${CONFIG_FILE:-/etc/hozr/hozr.conf}
if [ -e $CONFIG_FILE ] ; then
	source $CONFIG_FILE
fi

# Locking
LOCK_FILE=/var/lock/hozr_export_patients
if [ -e $LOCK_FILE ] ; then
	echo "Giving up, as lockfile exists!"
	echo "Remove $LOCK_FILE if needed."

	exit 2
fi

trap "{ rm -f $LOCK_FILE ; exit 255; }" SIGINT SIGTERM
touch $LOCK_FILE

# Main code
rails_run "Praxistar::PatientenPersonalien.export"

rm $LOCK_FILE
