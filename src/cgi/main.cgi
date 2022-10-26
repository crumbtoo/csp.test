#!/bin/sh

echo "Content-type: text/html"
echo # newline

genhtml()
{
	format='<div class="comment-comment">
				<div class="comment-comment-alias">
					%s
				</div>
				<div class="comment-comment-comment">
					%s
				</div>
				<div class="comment-comment-date">
					%s
				</div>
			</div>'

	while read line; do
		c_time=$(date -d "@$(echo "$line" | cut -d':' -f1)" "+%y/%m/%d, %I:%M")
		c_alias=$(echo "$line" | cut -d':' -f2 | sed 's/@COLON@/:/')
		c_comment=$(echo "$line" | cut -d':' -f3 | sed 's/@NEWLINE@/<br>/g')

		printf "$format<br>" "$c_alias" "$c_comment" "$c_time"

	done < "../../srv/comments"
}

COMMENTS="$(genhtml)" envsubst < "../../html/index.html"

