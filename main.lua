-- to tell lua to search in lib sub folder
--package.path = './lib/?.lua;' .. package.path
util = require( "lib.util" )
_ = require("lib.underscore")
inspect = require("lib.inspect")
dbi = require("lib.dbi")
-- using self define class

print("loaded?" )
print(package.loaded.dbi)

util:helloWorld()
util:helloWorld("yee siang")
-- the following function call will not work bcs that's a local private function
--util:_printHelloWorld("yee siang")

print("sum of 10 and 2 is ".. util:sum(10, 2))

-- using underscore
-- doc available here at - http://mirven.github.io/underscore.lua
--print(_.max({1,2,3,4}) )

-- using underscore function in util
util:max({1,2,3,4})

if(util:testConnection()) then
	print("got internet connection..")
else
	print("no internet connection..")
end

local db = dbi:init("data.db")

-- create table, execute raw sql
dbi:exec(db, [[CREATE TABLE IF NOT EXISTS superhero (id INTEGER PRIMARY KEY, code UNIQUE, name, level INTEGER, isTraining INTEGER);]] )

-- insert data
dbi:insert(db, "superhero", {code="agent", name="Agent Tan", level=182, isTraining=true})
dbi:insert(db, "superhero", {code="captain-america", name="Captain America", level=10, isTraining=false})
dbi:insert(db, "superhero", {code="wolverine", name="Wolverine", level=14, isTraining=nil})
dbi:insert(db, "superhero", {code="iron-man", name="Iron Man", level=11})
dbi:insert(db, "superhero", {code="hawkeye", name="Hawkeye", level=9, isTraining=true})
print()

-- update data
print("--update agent...")
dbi:update(db, "superhero", [[code='agent']], {level=185, isTraining=1})
local code2update = "hawkeye"
dbi:update(db, "superhero", dbi:bind([[code=_code_]], {_code_=code2update}), {level=10})
print()

-- get a row data
print("--get superhero agent")
row = dbi:getRow(db, "SELECT * FROM superhero WHERE code=_code_ limit 1", {_code_='agent'})
local outputText = row.code..": lvl-"..row.level
print(row.code..": lvl-"..row.level)
print()

print("--get superhero hawkeye")
row = dbi:getRow(db, "SELECT * FROM superhero WHERE code=_code_ limit 1", {_code_='hawkeye'})
local outputText = row.code..": lvl-"..row.level
print(row.code..": lvl-"..row.level)
print()

-- get all row data
print("--get all superheroes that is under training:")
rows = dbi:getAll(db, "SELECT * FROM superhero WHERE isTraining=_isTraining_", {_isTraining_=true})
_.each(rows, function(row) print(row.code..": lvl-"..row.level) end)
print()

-- select data traiditional way...
print("--get all superheroes in traditional method:")
for row in db:nrows("SELECT * FROM superhero") do
    local text = row.code..": lvl-"..row.level .. " training-"..util:getString(row.isTraining)
	print(text)
end

print("-- is record exists?")
print("hero with code 'agent': ".. tostring(dbi:exists(db, "superhero", {code="agent"})))
print("hero with code 'hulk': ".. tostring(dbi:exists(db, "superhero", {code="hulk"})))
print()

local myText = display.newText( outputText, display.contentCenterX, display.contentCenterY, native.systemFont, 32 )
myText:setFillColor( 1, 1, 1 )
