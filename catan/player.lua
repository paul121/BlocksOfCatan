local catan_local = ...

catan_local.api.playerControl = {}
local playerControl = catan_local.api.playerControl




local onJoinPlayer = function(player)
  local name = player:get_player_name()
  if catan_local.singleplayer then
    minetest.chat_send_all("This is a single player world. Giving player development items.")

    local loaded = catan_local.api.util.loadBoard()
  	if loaded then
  		catan_local.api.boardSetup.loadBoard(loaded)
  	else
  		catan_local.api.boardSetup.loadBoard()
  	end

    local inv = minetest.get_inventory({type="player", name=name})
    local stack = ItemStack("catan:board_center 2")
    local list = { ItemStack("catan:board_center 2"), ItemStack("catan:road_builder 20"), ItemStack("catan:capture_pos1 1"), ItemStack("catan:capture_pos2 1"), ItemStack("catan:road_default 1") }

    inv:set_list("main", list)
    minetest.get_player_by_name(name)
  end
end


minetest.register_on_joinplayer(
  function(player)
    onJoinPlayer(player)
  end
)
