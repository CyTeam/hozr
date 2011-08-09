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

umask 0027

# Libraries
source /usr/local/bin/lib_hozr.sh

ENVIRONMENT=${2:-$ENVIRONMENT}

# Configuration
source /etc/hozr/hozr.conf

# Commanline handling
TYPE=$1

HISTO_LOG_FILE="/var/log/hozr/hozr.log"
HISTO_ERROR_LOG_FILE="/var/log/hozr/error.log"

RUN_DIR=$(dirname "$0")
PAP_TMP="$(tempfile --prefix hozr)"
rm -rf "$PAP_TMP"
mkdir -p "$PAP_TMP"

munpack -f -C "$PAP_TMP"

echo "[$(date)] Called for type '$TYPE'." >> $HISTO_LOG_FILE

echo "[$(date)]   extracted images:" >> $HISTO_LOG_FILE
for i in $(ls $PAP_TMP/*.jpg $PAP_TMP/*.tif) ; do
	echo "[$(date)]   $i" >> $HISTO_LOG_FILE 2>>$HISTO_ERROR_LOG_FILE
	$RUN_DIR/hozr_$TYPE.sh "$i" >> $HISTO_LOG_FILE 2>>$HISTO_ERROR_LOG_FILE
done;

rm -rf "$PAP_TMP"
