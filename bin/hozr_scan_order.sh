#!/bin/bash

#  Copyright 2006-2010 Simon Hürlimann (ZytoLabor) <simon.huerlimann@cyt.ch>
#  Copyright 2006-2010 ZytoLabor <info@zyto-labor.com>
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

ENVIRONMENT=${2:-$ENVIRONMENT}

# Configuration
source /etc/hozr/hozr.conf

HISTO_LOG_FILE="/var/log/hozr/hozr.log"
HISTO_ERROR_LOG_FILE="/var/log/hozr/error.log"

# Loop over all the images specified on the command line
for PAP_IMG in $@ ; do
	TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S-%N)"
	ORDER_NAME="$ORDER_FORM_DIR/order-$TIMESTAMP.jpg"

	nice convert -crop 1172x1606+246+0 "$PAP_IMG" "$ORDER_NAME"

	echo "[$(date)]   filed order form" >>"$HISTO_LOG_FILE"
done
