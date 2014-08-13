module('Util', package.seeall)
-- must include underscore in parent class
local socket = require( "socket" )

local Util = { funcs = {} }
Util.__index = Util
function Util.__call(_, value)
	return Util:new()
end
function Util:new(value, chained)
	return setmetatable({ _val = value, chained = chained or false }, self)
end

-- this is a private function
local function _printHelloWorld(name)
	if name == nil then
		print("Hello World")
	else
		print("Hello World "..name)
	end	
end

function Util:helloWorld(name)
	_printHelloWorld(name)
end

function Util:sum(num1, num2)
	return num1+num2
end

function Util:max()
	print(_.max({1,2,3,4}))
end

function Util:isEmpty(s)
	return s == nil or s == ''
end

function Util:getString(s)
	if(Util:isEmpty(s)) then
		return ""
	else
		return s
	end
end

function Util:testConnection()
	local netConn = socket.connect('www.google.com', 80)
	if netConn == nil then
		 return false
	end
	netConn:close()
	return true
end

return Util:new()