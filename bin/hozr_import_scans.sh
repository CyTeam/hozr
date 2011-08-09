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
source /usr/local/bin/lib_hozr.sh

# Options
# =======
# Command line options
function run_help() {
        echo "Usage: $0 [--noop|--host|--database] [help]" >&2
}

# Option defaults
OPT_NOOP=0
OPT_VERBOSE=0

while [ ${#@} -gt "0" ] ; do
	arg=$1
	case $arg in
	--noop)
		OPT_NOOP=1
		;;

	--host|-h)
		DATABASE_HOST=$2
		shift
		;;

	--database|--db|-d)
		DATABASE=$2
		shift
		;;

	--verbose)
		OPT_VERBOSE=1
		;;

	--help)
		run_help
		exit 0
		;;
	*)
		run_help
		exit 1
		;;
	esac
	
	shift
done

# Read config file
CONFIG_FILE=${CONFIG_FILE:-/etc/hozr/hozr.conf}
if [ -e $CONFIG_FILE ] ; then
	source $CONFIG_FILE
fi

# Globals
ENVIRONMENT=${ENVIRONMENT:-production}

LOCK_FILE=/var/lock/hozr_import_scans

# Main 
# ====
if [ -e $LOCK_FILE ] ; then
	echo "Giving up, as lockfile exists!"
	echo "Remove $LOCK_FILE if needed."

	exit 2
fi

trap "{ rm -f $LOCK_FILE ; exit 255; }" SIGINT SIGTERM
touch $LOCK_FILE

order_forms=$ORDER_FORM_DIR/*.jpg

mv $order_forms $ORDER_FORM_DIR/current

rails_run "OrderForm.import_order_forms('$ORDER_FORM_DIR/current')"

mv $ORDER_FORM_DIR/current/* $ORDER_FORM_DIR/done

rm $LOCK_FILE
