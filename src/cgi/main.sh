#!/bin/dash

echo "Content-type: text/html"
echo # newline

# LMAOOOOOOOO
if [ "$(uname)" = "Darwin" ]; then
	epochdate() { date -jr "$1" "+%y/%m/%d, %I:%M"; }
elif [ "$(uname)" = "Linux" ]; then
	epochdate() { date -d "@$1" "+%y/%m/%d, %I:%M"; }
fi

genhtml()
{
	format='<div class="comment-comment"><div class="comment-comment-alias">%s</div><div class="comment-comment-comment">%s</div><div class="comment-comment-date">%s</div></div>'
	censor='../../dep/censor.py'

	# iterate lines in reverse
	sort -r "../../srv/comments" | while read line; do
		c_time=$(epochdate "$(echo "$line" | cut -d':' -f1)")
		c_alias=$(echo "$line" | cut -d':' -f2 | sed 's/@COLON@/:/' | $censor)
		c_comment=$(echo "$line" | cut -d':' -f3 | sed 's/@NEWLINE@/<br>/g' | $censor)

		printf "$format" "$c_alias" "$c_comment" "$c_time"

	done
}

# COMMENTS="$(genhtml)" envsubst < "../../html/index.html"
cat '../../html/index.html'

