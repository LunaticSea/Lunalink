local function _region_converter(data)
  local preres = {}
  for part in data:gmatch("([^%.]+)") do
    table.insert(preres, part)
  end

  local res = preres[1]

  return res:gsub("%d", "")
end

p(_region_converter('hongkong8.helper'))