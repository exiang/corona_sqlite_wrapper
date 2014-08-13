corona_sqlite_wrapper
=====================

Sqlite Wrapper for Coronalab.

It aims to help making database call in coronalab easier thru functions.
For examples:

**Require**

Insert the following required header at the top of your main.lua:

```
_ = require("lib.underscore")
inspect = require("lib.inspect")
dbi = require("lib.dbi")
```

**Init DB**
```
dbi:exec(db, [[CREATE TABLE IF NOT EXISTS superhero (id INTEGER PRIMARY KEY, code UNIQUE, name, level INTEGER, isTraining INTEGER);]] )
```

** Insert **
```
dbi:insert(db, "superhero", {code="agent", name="Agent Tan", level=182, isTraining=true})
```

** Update **
```
dbi:update(db, "superhero", [[code='agent']], {level=185, isTraining=1})
```

** Get a Row **
```
row = dbi:getRow(db, "SELECT * FROM superhero WHERE code=_code_ limit 1", {_code_='agent'})
print(row.code..": lvl-"..row.level)
```


** Get All **
```
rows = dbi:getAll(db, "SELECT * FROM superhero WHERE isTraining=_isTraining_", {_isTraining_=true})
_.each(rows, function(row) print(row.code..": lvl-"..row.level) end)
```


** Or tradionally **
```
for row in db:nrows("SELECT * FROM superhero") do
    local text = row.code..": lvl-"..row.level .. " training-"..tostring(row.isTraining)
	print(text)
end
```

** Is Exists? **
```
dbi:exists(db, "superhero", {code="agent"})
```




**Dependancies**
- underscore: http://mirven.github.io/underscore.lua/
- inspect(optional): http://github.com/kikito/inspect.lua