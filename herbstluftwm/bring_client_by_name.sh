#!/bin/bash
# written by Shotaro Fujimoto (https://github.com/ssh0)
# first edited: 2017-02-15

hexid="$($HOME/.config/herbstluftwm/pick_clients_hexid_by_window_name.sh)"
if [ -n "${hexid}" ]; then
  herbstclient bring "${hexid}"
fi
