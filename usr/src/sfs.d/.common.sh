#!/bin/sh

: ${lbu:=/opt/LiveBootUtils}
. "$lbu/scripts/common.func"

test -n "${SILENT_EXIT+set}" || SILENT_EXIT=1

: ${nginx_dl_url:=https://nginx.org/en/download.html}
: ${nodejs_dist:=https://nodejs.org/dist}
: ${nodejs_dist_json:=$nodejs_dist/index.json}
: ${nodejs_arch:=linux-x64}

latest_nodejs_ver() {
  curl -s "$nodejs_dist_json" | jq -r 'map(select(.lts!=false and contains({files:["'$nodejs_arch'"]})))[0].version'
}

installed_nodejs_ver() {
  "$DESTDIR/opt/bin/node" --version
}

latest_nodejs_url() {
  : ${nodejs_ver:=$(latest_nodejs_ver)}
  echo "$nodejs_dist/$nodejs_ver/node-${nodejs_ver}-$nodejs_arch.tar.xz"
}

latest_nginx() {
  curl -s "$nginx_dl_url" | grep -Eo 'nginx-[0-9][targz.0-9]+' | head -1
}

latest_nginx_ver() {
  latest_nginx | sed -e 's/^nginx-//' -e 's/[targz.]\+$//'
}

installed_nginx_ver() {
  "$DESTDIR/srv/nginx/sbin/nginx" -v 2>&1 | sed -e 's^.*/^^'
}

confirm_latest() {
  local name="$1" installed="$2" latest="$3"
  test "x$installed" = "x$latest" || {
    echo "Update for $name available: '$installed' -> '$latest'" >&2
    return 1
  }
}
