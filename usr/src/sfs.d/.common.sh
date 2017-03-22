#!/bin/sh

: ${lbu:=/opt/LiveBootUtils}
. "$lbu/scripts/common.func"

test -n "${SILENT_EXIT+set}" || SILENT_EXIT=1

latest_nodejs() {
  curl -s https://nodejs.org/dist/latest/ | grep -o "node-v[^-]*-linux-x64.tar.xz" | head -1
}
