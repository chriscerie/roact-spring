local function MergeTable(...)
	local new = {}

	for dictionaryIndex = 1, select("#", ...) do
		local dictionary = select(dictionaryIndex, ...)

		if dictionary ~= nil then
			for key, value in pairs(dictionary) do
				if value == None then
					new[key] = nil
				else
					new[key] = value
				end
			end
		end
	end

	return new
end

return MergeTable
