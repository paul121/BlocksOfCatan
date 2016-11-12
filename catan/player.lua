local catan_local = ...

local boardSetup = catan_local.api.boardSetup

catan_local.api.playerControl = {}
local playerControl = catan_local.api.playerControl


local addPlayer = function(player)
  local adminPlayer = minetest.setting_get("name")
  local name = player:get_player_name()
  local board = boardSetup.getBoard()
  local player = {}
  player.name = name
  player.score = 0
  player.color = nil


  table.insert(board.players, player)

  local privs = minetest.get_player_privs(name)
  minetest.chat_send_all("Adding player "..name.." to game.")
  local status = boardSetup.getBoardStatus()
  if status == "ingame" then
    privs.catan_viewer = true
  else
    privs.catan_viewer = true
    privs.catan_player = true
  end

  if name == adminPlayer then
    privs.catan_admin = true
    local inv = minetest.get_inventory({type="player", name=name})
    local stack = ItemStack("catan:board_center 2")
    local list = { ItemStack("catan:board_center 2"), ItemStack("catan:road_builder 20"), ItemStack("catan:capture_pos1 1"), ItemStack("catan:capture_pos2 1"), ItemStack("catan:road_default 1") }
    inv:set_list("main", list)
  end

  minetest.set_player_privs(name, privs)
end

local onJoinPlayer = function(player)
  local name = player:get_player_name()
  local loaded = catan_local.api.util.loadBoard()
  if loaded then
    catan_local.api.boardSetup.loadBoard(loaded)
  else
    catan_local.api.boardSetup.loadBoard()
  end
  if catan_local.singleplayer then
    minetest.chat_send_all("This is a single player world. Giving player development items.")

    local inv = minetest.get_inventory({type="player", name=name})
    local stack = ItemStack("catan:board_center 2")
    local list = { ItemStack("catan:board_center 2"), ItemStack("catan:road_builder 20"), ItemStack("catan:capture_pos1 1"), ItemStack("catan:capture_pos2 1"), ItemStack("catan:road_default 1") }

    inv:set_list("main", list)
  else
    addPlayer(player)
  end
end


minetest.register_on_joinplayer(
  function(player)
    onJoinPlayer(player)
  end
)
