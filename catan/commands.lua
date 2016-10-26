local catan_local = ...

minetest.register_privilege("catan_admin", {
	description = "Admin commands for Catan plugin.",
	give_to_singleplayer = true
})

minetest.register_chatcommand("c:start", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		catan_local.functions.start(name)
	end
})

minetest.register_chatcommand("c:board-preview", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if catan_local.boardsettings.pos then
			catan_local.functions.previewboardarea(catan_local.boardsettings.pos)
		else
			catan_local.functions.previewboardarea(player:getpos(player))
		end
	end
})

minetest.register_chatcommand("c:board-unpreview", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		catan_local.functions.unpreviewboardarea()
	end
})

minetest.register_chatcommand("c:board-setpos", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.setboardpos(player:getpos(player))
	end
})

minetest.register_chatcommand("c:board-rempos", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.removeboardpos()
	end
})

minetest.register_chatcommand("create board", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.makeboard()
	end
})

minetest.register_chatcommand("game type", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.makeboard()
	end
})

minetest.register_chatcommand("board layout", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.makeboard()
	end
})

minetest.register_chatcommand("number layout", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.makeboard()
	end
})

minetest.register_chatcommand("board style", {
	privs = {
		catan_admin = true
	},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		catan_local.functions.makeboard()
	end
})


catan_local.functions.start = function(name)
  minetest.debug(name .. " started the Catan mod.")
  minetest.chat_send_all(catan_local.modchatprepend..name .. " started the Catan mod.")

  local inv = minetest.get_inventory({type="player", name=name})
  local stack = ItemStack("catan:board_center 2")
  local list = { stack, ItemStack("catan:road_builder 20") }

  inv:set_list("main", list)
  minetest.get_player_by_name(name)
end
