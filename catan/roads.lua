local catan_local = ...

local posOffset = function(x, y, z, pos)
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

local convertToRoad = function(pos)
  worldedit.set(pos, pos, "catan:road_red")
end

local nodeIsRoad = function(pos)
  local node = minetest.get_node(pos)
  if node.name == "catan:road_default" then
    minetest.chat_send_all("We have a road!")
    return true
  else
    minetest.chat_send_all("We have "..node.name)
    return false
  end
end

local searchForRoad = nil
searchForRoad = function(pos)
  local testpos = posOffset(1, 0, 0, pos)
  if nodeIsRoad(testpos) then
    convertToRoad(testpos)
    searchForRoad(testpos)
  end
  testpos = posOffset(-1, 0, 0, pos)
  if nodeIsRoad(testpos) then
    convertToRoad(testpos)
    searchForRoad(testpos)
  end
  testpos = posOffset(0, 0, 1, pos)
  if nodeIsRoad(testpos) then
    convertToRoad(testpos)
    searchForRoad(testpos)
  end
  testpos = posOffset(0, 0, -1, pos)
  if nodeIsRoad(testpos) then
    convertToRoad(testpos)
    searchForRoad(testpos)
  end
end

local buildRoad = function(player, pos)
  convertToRoad(pos)
  searchForRoad(pos)
end

local isRoadLocation = function(pos)
  local centerPos = catan_local.boardsettings.pos
  local differenceVector = {x = centerPos.x - pos.x, y = centerPos.y - pos.y, z = centerPos.z - pos.z}
  minetest.chat_send_all("Checking if pos is a road...")
  if (differenceVector.z % 8 == 0) then
    minetest.chat_send_all("Node placed on correct space!")
    return true
  else
    minetest.chat_send_all("Not a road...--> "..differenceVector.z % 8)
    return false
  end
end

catan_local.functions.roadBuilderPlace = function(player, pos)
  if isRoadLocation(pos) then
    buildRoad(player, pos)
  end
end
