#!/bin/bash


function generate_graph {
	fname="$1"
	start="$2"
	shift 2

	rrdtool graph --daemon "unix:/var/run/rrdcached.sock" --imgformat "PNG" --width 1400 --height 420 --font "TITLE:12:." \
		"$image_dir/$fname.png" --start "$start" --lower-limit 0                                                            \
		"$@"                                                                                                                \
		"COMMENT:$last_update" > /dev/null
}

function get_config {
	awk "/^[[:space:]]*$2/ {print gensub(\"\\\"$\", \"\", 1, gensub(\"^\\\"\", \"\", 1, \$2))}" "/etc/collectd/collectd.conf.d/$1.conf"
}

function each_period {
	cmd="$1"
	shift

	# periods=((hour  '-1h' ' - by hour')
	#          (day   '-1d' ' - by day')
	#          (week  '-1w' ' - by week')
	#          (month '-1m' ' - by month')
	#          (year  '-1y' ' - by year'))
	for period in "hour" "day" "week" "month" "year"; do
		"$cmd" "$period" "-1${period:0:1}" "$@"
	done

	"$cmd" "workday" "-8h" "$@"
}


cur_time="$(date)"

data_dir="/var/lib/rrdcached/db/$(hostname)"
image_dir="/var/www/html/status/rrd"
last_update="Last update\: ${cur_time//:/\\:}\\r"
