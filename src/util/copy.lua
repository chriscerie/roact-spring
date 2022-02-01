local function copy(table)
	local new = {}

	for key, value in pairs(table) do
		new[key] = value
	end

	return new
end

return copy