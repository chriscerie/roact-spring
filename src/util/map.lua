local function map(dictionary, mapper)
	local new = {}

	for key, value in pairs(dictionary) do
		local newValue, newKey = mapper(value, key)
		new[newKey or key] = newValue
	end

	return new
end

return map
