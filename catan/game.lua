local catan_local = ...

local boardSetup = catan_local.api.boardSetup
local util = catan_local.api.util
local playerControl = catan_local.api.playerControl

catan_local.api.gameControl = {}
local gameControl = catan_local.api.gameControl

local role = function()
  local seed = os.time()
  math.randomseed(seed)

  local dice1 = math.random(6)
  local dice2 = math.random(6)
  local roleTotal = dice1 + dice2
  minetest.chat_send_all("ROLLING: a "..roleTotal)
  return roleTotal
end

local getTiles = function(roleTotal)
  local board = boardSetup.getBoard()
  local returnTiles = {}
  for tileNum = 1, #board.tiles do
    if board.tiles[tileNum].number == roleTotal then
      returnTiles[#returnTiles + 1] = board.tiles[tileNum]
      minetest.chat_send_all("Tile "..tileNum.." is a hit with "..roleTotal)
    end
  end
  return returnTiles
end

local giveResources = function(tiles)
  for tileNum = 1, #tiles do
    local tile = tiles[tileNum]
    local resource = "catan:"..tile.type.."_resource"
    for settleNum = 1, #tile.settlements do
      local settlement = tile.settlements[settleNum]
      if settlement.owner then
        minetest.get_player_by_name(settlement.owner.name):get_inventory():add_item("main", "catan:"..tile.type.."_resource")
      end
    end
  end
end

local start = function()
  local roleTotal = role()
  local tiles = getTiles(roleTotal)
  giveResources(tiles)
end


gameControl.start = function(name)
  return start()
end
