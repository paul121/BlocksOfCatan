local catan_local = ...
local boardSetup = catan_local.api.boardSetup

minetest.register_privilege("catan_admin", {
	description = "Admin commands for Catan plugin.",
	give_to_singleplayer = true
})

ChatCmdBuilder.new("board", function(cmd)
	cmd:sub("init", function(name, type)
		catan_local.functions.start(name)
	end)

	cmd:sub("preview", function(name)
		local error = boardSetup.previewBoardArea()
		local player = minetest.get_player_by_name(name)
		if not error then
			return true, "Previewed the board area."
		else
			return false, error
		end
	end)

	cmd:sub("unpreview", function(name)
		local error = boardSetup.unPreviewBoardArea()
		if not error then
			return true, "Unpreviewed the board area."
		else
			return false, error
		end
	end)

	cmd:sub("set pos", function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player.getpos(player)
		local error = boardSetup.setBoardPos(pos)
		if not error then
			return true, "Set board center to current player "..name.." location at "
		else
			return false, error
		end
	end)

	cmd:sub("set pos :pos:pos", function(name, pos)
		local error = boardSetup.setBoardPos(pos)
		if not error then
			return true, "Board pos set to "
		else
			return false, error
		end
	end)

	cmd:sub("remove pos", function(name)
		local error = boardSetup.setBoardPos(pos)
		if not error then
			return true, "Board pos removed."
		else
			return false, error
		end
	end)

	cmd:sub("set layout :layout:word", function(name, layout)
		local error = boardSetup.setBoardLayout(layout)
		if not error then
			return true, "Board layout set to "..layout
		else
			return false, error
		end
	end)

	cmd:sub("set style :style:word", function(name, style)
		local error = boardSetup.setBoardStyle(style)
		if not error then
			return true, "Board style set to "..style
		else
			return false, error
		end
	end)

	cmd:sub("set number layout :layout:word", function(name, layout)
		local error = boardSetup.setBoardNumberLayout(layout)
		if not error then
			return true, "Board number layout set to "..layout
		else
			return false, error
		end
	end)

	cmd:sub("set game type :type:word", function(name, type)
		local error = boardSetup.setBoardGametype(type)
		if not error then
			return true, "Board gametype set to "..type
		else
			return false, error
		end
	end)

	cmd:sub("create", function(name)
		local error = boardSetup.makeBoard()
		if not error then
			return true, "Board created. /catan start to begin."
		else
			return false, error
		end
	end)

end, {
	description = "Catan board admin tools",
	privs = {
		catan_admin = true
	}
})

ChatCmdBuilder.new("catandev", function(cmd)

	cmd:sub("capture :filename", function(name, filename)
		local error = boardSetup.captureBlockZone(filename)
		if error then
			return false, error
		else
			return true, "Block zone saved to file "..filename..".txt"
		end
	end)

end, {
	description = "Catan board admin tools",
	privs = {
		catan_admin = true
	}
})


catan_local.functions.start = function(name)
  minetest.debug(name .. " started the Catan mod.")
  minetest.chat_send_all(catan_local.modchatprepend..name .. " started the Catan mod.")

  local inv = minetest.get_inventory({type="player", name=name})
  local stack = ItemStack("catan:board_center 2")
  local list = { ItemStack("catan:board_center 2"), ItemStack("catan:road_builder 20"), ItemStack("catan:capture_pos1 1"), ItemStack("catan:capture_pos2 1"), ItemStack("catan:road_default 1") }

  inv:set_list("main", list)
  minetest.get_player_by_name(name)
end
