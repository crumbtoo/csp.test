local fs = require('fs')

local comment =
[[<div class="comment">timestamp: %s
alias: %s
content: %s</div>]]

fs.readdir("../../srv/comments", function(err, files)
	if err then print("err") return end
	
	for i, name in ipairs(files) do
		local f = io.open("../../srv/comments/" .. name)
		local timestamp = f:read("*l")
		local alias = f:read("*l")
		local content = f:read("*a")

		-- print("timestamp: "..timestamp)
		-- print("alias    : "..alias)
		-- print("content  : "..content)
		print(comment:format(timestamp, alias, content))
		f:close()
	end
end)
