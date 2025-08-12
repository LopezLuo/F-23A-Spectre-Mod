-- This file contains utility functions.
local lastprint = {}

utils = {}



--- Checks if two tables are equal. (This can not be done with the `==` operator because it checks for reference equality.)
--- @param table1 table: The first table to compare.
--- @param table2 table: The second table to compare.
--- @return boolean: Returns true if the tables are equal, false otherwise.
function utils:tablesEqual(table1, table2)
	if #table1 ~= #table2 then return false end
	for i = 1, #table1 do
		if table1[i] ~= table2[i] then return false end
	end
	return true
end

--- Checks if a table contains a specific value.
--- @param table table: The table to check.
--- @param value any: The value to search for.
--- @return boolean: Returns true if the value is found in the table, false otherwise.
function utils:tableContains(table, value)
	for _, el in ipairs(table) do
		if el == value then
			return true
		end
	end
	return false
end


-- By FatSpacePanda, modified by mrbenvolentcanard.
--- Instead of printing the same message multiple times, this function will only print it once per id.
--- @param input string: The message to print.
--- @param id string: The identifier for the message group.
function utils:printButBetter(input, id)
	if input ~= lastprint[id] then
		print_message_to_user(input)
	end

	lastprint[id] = input
end