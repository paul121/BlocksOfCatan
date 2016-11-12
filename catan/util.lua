local catan_local = ...

catan_local.api.util = {}
local util = catan_local.api.util

local worldpath = minetest.get_worldpath()

util.posOffset = function(x, y, z, pos)
  if x == nil then
    x = 0
  end
  if y == nil then
    y = 0
  end
  if z == nil then
    z = 0
  end
  return {x = pos.x + x, y = pos.y + y, z = pos.z + z}
end

--BOARD SETTINGS
util.saveBoard = function()
  local data = catan_local.board
  local file, error = io.open(worldpath.."/catanboard.txt", "w")
  if not error then
    file:write(minetest.serialize(data))
    file:close()
  else
    return "ERROR: Could not save to file catanbaord.txt: "..error
  end
end

util.loadBoard = function()
  local file, error = io.open(worldpath.."/catanboard.txt", "r")
  if not error then
    local data = file:read("*all")
    return minetest.deserialize(data)
  else
    minetest.log("ERROR: Could not open file to read catanboard.txt: "..error)
  end
end


--BLOCK ZONE SAVE / LOAD
local zoneTypes = {board_layout = "/board_layouts", board_style = "/board_styles", game_type = "/game_types", number_layout = "/number_layouts", exports = "/exports"}

util.saveBlockZone = function(data, filename, type, name)
  local zoneType = zoneTypes[type]
  if zoneType ~= nil then
    if name then name = "/"..name else name = "" end
    if filename then filename = "/"..filename..".txt" else name = "" end
    local file = io.open(minetest.get_modpath("catan")..zoneType..name..filename, "w")
    if file then
      file:write(data)
      file:close()
      return true
    else
      return false, "could not open file path to write to"
    end
  else
    return false, "invalid block zone type"
  end
end

util.loadBlockZone = function(filename, type, name)
  local zoneType = zoneTypes[type]
  if zoneType ~= nil then
    if name then name = "/"..name end
    if filename then filename = "/"..filename..".txt" end
    local file = io.open(minetest.get_modpath("catan")..zoneType..name..filename, "r")
    if file then
      local data = file:read("*all")
      return data
    else
      return false, "could not open file"
    end
  end
end
