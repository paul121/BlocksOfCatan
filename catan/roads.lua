local catan_local = ...
local util = catan_local.util

catan_local.api.roadControl = {}
local roadControl = catan_local.api.roadControl


----------------------------------------------------
--LOCAL FUNCTIONS
----------------------------------------------------

--
----------------------------------------------------

local convertToRoad = function(pos)
  worldedit.set(pos, pos, "catan:road_red")
end

local getNodeType = function(pos)
  local node = minetest.get_node(pos)
  return node.name
end

local addRoadToSettlement = function(pos)
  minetest.chat_send_all("Adding a road to settlement.")
end

local searchForRoad = nil

local testLocation = function(pos)
  local nodeType = getNodeType(pos)
  if nodeType == "catan:road_default" then
    convertToRoad(pos)
    searchForRoad(pos)
  elseif nodeType == "catan:settlement_location" then
    addRoadToSettlement(pos)
  end
end

searchForRoad = function(pos)
  testLocation(util.posOffset(1, 0, 0, pos))
  testLocation(util.posOffset(-1, 0, 0, pos))
  testLocation(util.posOffset(0, 0, 1, pos))
  testLocation(util.posOffset(0, 0, -1, pos))
end

local buildRoad = function(player, pos)
  convertToRoad(pos)
  searchForRoad(pos)
end

local isRoadLocation = function(pos)
  local centerPos = catan_local.board.pos
  local differenceVector = {x = centerPos.x - pos.x, y = centerPos.y - pos.y, z = centerPos.z - pos.z}
  --minetest.chat_send_all("Checking if pos is a road...")
  if ((differenceVector.z % 8 == 0) and ((differenceVector.x % 14 == 1) or (differenceVector.x % 14 == 13))) or
     ((differenceVector.z % 4 == 0) and ((differenceVector.x % 7 == 1) or (differenceVector.x % 7 == 6))) or
     ((differenceVector.z % 3 == 0) and (differenceVector.x % 7 == 0)) then

    --minetest.chat_send_all("Node placed on correct space!")
    return true
  else
    --minetest.chat_send_all("Not a road...--> "..differenceVector.z % 8)
    return false
  end
end

local onRoadBuilderPlace = function(player, pos)
  if isRoadLocation(pos) then
    buildRoad(player, pos)
  end
end

----------------------------------------------------
--LOCAL API FUNCTIONS
----------------------------------------------------
roadControl.onRoadBuilderPlace = function(player, pos)
  return onRoadBuilderPlace(player, pos)
end
