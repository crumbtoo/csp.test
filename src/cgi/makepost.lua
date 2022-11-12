#!/usr/bin/env luvit

local json = require("json")


print('Content-type:text/plain\n');
print('hi')

local msg = io.stdin:read("*all")
local t = json.parse(msg)

if not t["alias"] or not t["timestamp"] or not t["comment"] then
	print("missing field")
	os.exit(1)
end

local f = io.open("../../srv/comments", "a")

local alias = t["alias"]:gsub(":", "@COLON@")
local comment = t["comment"]:gsub("\n", "@NEWLINE@"):gsub(":", "@COLON@")

local s = string.format("%s:%s:%s\n",
	t["timestamp"], alias, comment)

f:write(s)

print(s)

