#/bin/bash

#  Copyright 2010-2011 Simon Hürlimann (ZytoLabor) <simon.huerlimann@cyt.ch>
#  Copyright 2010-2011 ZytoLabor <info@zyto-labor.com>
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

set -e

# Libraries
source $(dirname $0)/lib_hozr.sh

if [ -f $RAILS_DIR/tmp/mailing_create_all.lock ] ; then
	find $RAILS_DIR/tmp/mailing_create_all.lock -mmin 15 -exec rm {} \;
fi
