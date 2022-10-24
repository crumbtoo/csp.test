#!/bin/sh

echo "Content-type: text/html"
echo # newline

COMMENTS="$(luvit gencomments.lua)" envsubst < "../../html/index.html"
