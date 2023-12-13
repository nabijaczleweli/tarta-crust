#!/bin/sh
# SPDX-License-Identifier: 0BSD

# If in the first argument (after stripping the first -), there is both [xtd] and a, and it's not --*, then also add -I bsdcat
# This means you can do curl .../whatever.tar.gz | tar -tva or | tar -xva and it'll work
tar() {
	[ $# -gt 0 ] || { command tar; return; }
	__tar_first="$1"; shift

	__tar_parsed="${__tar_first#-}"
	if [ "${__tar_parsed#-}" = "$__tar_parsed" ] &&
	   [ "${__tar_parsed#*[xtd]}" != "$__tar_parsed" ] &&
	   [ "${__tar_parsed#*a}" != "$__tar_parsed" ] &&
	   __tar_tmpf="$(mktemp)"; then
		printf '%s\n' '#!/bin/sh' 'exec bsdcat' > "$__tar_tmpf"
		chmod +x "$__tar_tmpf"
		command tar -I "$__tar_tmpf" "$__tar_first" "$@"; __tar_ret=$?
		rm -f "$__tar_tmpf"
	else
		command tar "$__tar_first" "$@"; __tar_ret=$?
	fi
	unset __tar_first __tar_parsed __tar_tmpf
	return $__tar_ret
}
