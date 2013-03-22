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

function rails_run() {
local command="$1"

        pushd $RAILS_DIR >/dev/null
                echo "$command" | RAILS_ENV=$ENVIRONMENT bundle exec rails console
        popd >/dev/null
}
