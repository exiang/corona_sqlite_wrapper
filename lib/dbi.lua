module('Dbi', package.seeall)

local sqlite3 = require "sqlite3"

local Dbi = { funcs = {} }
Dbi.__index = Dbi
function Dbi.__call(_, value)
	return Dbi:new()
end
function Dbi:new(value, chained)
	return setmetatable({ _val = value, chained = chained or false }, self)
end


function _prepareValue(v)
	if(type(v) == "string") then
		return "'"..v.."'"
	elseif(type(v) == "number") then
		return v
	elseif(type(v) == "boolean") then
		return v and 1 or 0
	end
end

function _prepareKeyValue(table)
	local collections = {}
	local i=1
	for k, v in pairs(table) do
		collections[i] = "'"..k.."'=".._prepareValue(v)
		i = i+1
	end
	return _.join(collections, ',')
end

function _prepareKeyValue2(table)
	local collections = {}
	local i=1
	for k, v in pairs(table) do
		collections[i] = ""..k.."=".._prepareValue(v)
		i = i+1
	end
	return _.join(collections, ',')
end

function _bindSql(sql, bindings)
	local i=1
	for k, v in pairs(bindings) do
		sql = string.gsub(sql, k, _prepareValue(v))
	end
	return sql
end

function Dbi:init(dbName, directory)
	if(directory == nil) then directory = system.DocumentsDirectory end
	local path = system.pathForFile(dbName, directory)
	local dbo = sqlite3.open( path )   
	return dbo
end

function Dbi:exec(dbo, sql)
	dbo:exec( sql )
end

function Dbi:insert(dbo, tableName, t)
	local sql = [[INSERT INTO ]]..tableName..[[ (]] .. _.join(_.keys(t), ',') .. [[) VALUES (]] .. _.join(_.map(_.values(t), _prepareValue), ',') .. [[); ]]
	--print(sql)
	Dbi:exec(dbo, sql)
end

function Dbi:insertReplace(dbo, tableName, t)
	local sql = [[INSERT OR REPLACE INTO ]]..tableName..[[ (]] .. _.join(_.keys(t), ',') .. [[) VALUES (]] .. _.join(_.map(_.values(t), _prepareValue), ',') .. [[); ]]
	--print(sql)
	Dbi:exec(dbo, sql)
end

function Dbi:update(dbo, tableName, sqlCondition, t)
	local sql = [[UPDATE ]]..tableName..[[ SET ]] .. _prepareKeyValue(t) .. [[ WHERE ]] .. sqlCondition .. [[; ]]
	--print(sql)
	Dbi:exec(dbo, sql)
end

function Dbi:exists(dbo, tableName, t)
	local sql = [[select exists (select 1 from ]]..tableName..[[ where ]].._prepareKeyValue2(t)..[[) as result;]]
	--print(sql)
	for row in dbo:nrows(sql) do
		--print(inspect(row))
		if (row.result ~= nil and row.result == 1) then return true end
		return false
	end
end

function Dbi:getRow(dbo, sqlSelect, bindings)
	local sql = _bindSql(sqlSelect, bindings)
	-- print(sql)
	for row in dbo:nrows(sql) do
		return row
	end
end

function Dbi:getAll(dbo, sqlSelect, bindings)
	if(bindings ~= nil) then
		sql = _bindSql(sqlSelect, bindings)
	else
		sql = sqlSelect
	end
	--print(sql)
	
	local result = {}
	local i=1
	for row in dbo:nrows(sql) do
		result[i] = row
		i = i+1
	end
	
	--print(inspect(result))
	return result
end

function Dbi:close(db)
	db:close()
end

function Dbi:bind(sql, bindings)
	return _bindSql(sql, bindings)
end


return Dbi:new()