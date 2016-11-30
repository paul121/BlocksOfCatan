local catan_local = ...

local boardSetup = catan_local.api.boardSetup
local util = catan_local.api.util

catan_local.api.settlementControl = {}
local settlementControl = catan_local.api.settlementControl


local buildSettlement = function(player, pos)
  local name = player:get_player_name()
  local board = boardSetup.getBoard()
  local catan_player = board.playerMap[name].player
  if catan_player then
    if catan_player.color then
      for tileNum = 1, #board.tiles do
        for settleNum = 1, #board.tiles[tileNum].settlements do
          local settlement = board.tiles[tileNum].settlements[settleNum]
          if minetest.pos_to_string(util.posOffset(0, -1, 0, pos)) == minetest.pos_to_string(settlement.pos) then
            settlement.owner = catan_player
            minetest.chat_send_all("Found a settlment")
          end
        end
      end
      worldedit.set(pos, util.posOffset(0, 1, 0, pos), "catan:settlement_"..catan_player.color)
      boardSetup.saveBoard(board)
    else
      return "ERROR: Player has not set a color."
    end
  else
    return "ERROR: Player is not in the board."
  end


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
    local error = buildSettlement(player, pos)
    if error then
      minetest.chat_send_all(error)
    end
  end
end

settlementControl.onSettlementBuilderPlace = function(player, pos)
  return onSettlementBuilderPlace(player, pos)
end
