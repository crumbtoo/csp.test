#!/usr/bin/env luvit

local json = require("json")

print('Content-type:application/json\n')

function entry_ts(s)
	local l = 0
	local i = 1
	local c = s:sub(i, i)

	while tonumber(c) ~= nil do
		l = l * 10
		l = l + tonumber(c)

		i = i + 1
		c = s:sub(i, i)
	end

	return l
end

function string.split(s, sep)
	local t = {}
	local w = 1
	local p = 1

	for i = 1, #s do
		local c = s:sub(i, i)

		if c == sep then
			if t[w] then w = w + 1 end
			p = 1
		else
			if not t[w] then t[w] = "" end
			t[w] = t[w] .. c
			p = p + 1
		end
	end
	
	return t
end

local msg = io.stdin:read("*all")
local t = json.parse(msg)
local res

if not t or not t["timestamp"] then
	print("missing field")
	os.exit(1)
end

res = {
	timestamp = tonumber(os.date("%s")),
	newcomments = {}
}

local f_comments = io.open("../../srv/comments", "r")
-- local comments = f_comments:read("*all")
local timestamp = t["timestamp"]

for l in f_comments:lines() do
	if entry_ts(l) > timestamp then
		local comm = l:split(':')
		table.insert(res.newcomments, {
			timestamp = os.date("%y/%m/%d, %I:%M", comm[1]),
			alias = comm[2],
			comment = comm[3]
		})
	end
end


print(json.stringify(res))

