#!/bin/sh

echo "Content-type: text/html"
echo # newline

genhtml()
{
	format=\
		"alias: %s
		time: %s
		content: %s"

	for line in $(cat "../../srv/comments"); do
		echo "$line"
	done
}

COMMENTS="$(genhtml)" envsubst < "../../html/index.html"

