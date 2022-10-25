#!/bin/sh

echo "Content-type: text/html"
echo # newline

genhtml()
{
	format="time: %s
		alias: %s
		content: %s"

	while read line; do
		c_time=$(date -d "@$(echo "$line" | cut -d':' -f1)" "+%I:%M, %y/%m/%d")
		c_alias=$(echo "$line" | cut -d':' -f2 | sed 's/@COLON@/:/')
		c_comment=$(echo "$line" | cut -d':' -f3 | sed 's/@NEWLINE@/<br>/g')
		printf "$format<br>" "$c_time" "$c_alias" "$c_comment"
	done < "../../srv/comments"
}

COMMENTS="$(genhtml)" envsubst < "../../html/index.html"

