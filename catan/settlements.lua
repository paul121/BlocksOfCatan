local catan_local = ...

local boardSetup = catan_local.api.boardSetup
local util = catan_local.api.util

catan_local.api.settlementControl = {}
local settlementControl = catan_local.api.settlementControl


local buildSettlement = function(player, pos)
  local name = player:get_player_name()
  local board = boardSetup.getBoard()
  local catan_player = board.playerMap[name].player

  for tileNum = 1, #board.tiles do
    for settleNum = 1, #board.tiles[tileNum].settlements do
      local settlement = board.tiles[tileNum].settlements[settleNum].pos
      if pos == settlement.pos then
        settlement.owner = catan_player
        minetest.chat_send_all("Found a settlment")
      end
    end
  end

  worldedit.set(pos, util.posOffset(0, 1, 0, pos), "catan:settlement_"..catan_player.color)
  boardSetup.saveBoard(board)
end

local isSettlementLocation = function (pos)
  local nodeBelow = util.getNodeType(util.posOffset(0, -1, 0, pos))
  if nodeBelow == "catan:settlement_location" then
    return true
  else
    return false
  end
end

local onSettlementBuilderPlace = function(player, pos)
  if isSettlementLocation(pos) then
    buildSettlement(player, pos)
  end
end

settlementControl.onSettlementBuilderPlace = function(player, pos)
  return onSettlementBuilderPlace(player, pos)
end
