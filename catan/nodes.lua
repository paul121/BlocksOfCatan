local catan_local = ...

minetest.register_node("catan:board_center", {
	description = "Block for previewing catan board",
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) setBoardPos(pos) end,
	on_rightclick = function(pos, node, player, pointed_thing)
		if catan_local.boardsettings.preview then
			catan_local.functions.unpreviewboardarea()
		else
			catan_local.functions.previewboardarea()
		end
	end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger) setBoardPos() end
})

minetest.register_node("catan:capture_pos1", {
	description = "Block for setting worldedit capture position.",
	tiles = {"default_diamond_block.png"},
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) setCapturePos(pos, 1) end,
	on_rightclick = function(pos, node, player, pointed_thing)
		captureBlockZone()
	end
})

minetest.register_node("catan:capture_pos2", {
	description = "Block for setting worldedit capture position.",
	tiles = {"default_gold_block.png"},
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) setCapturePos(pos, 2) end,
	on_rightclick = function(pos, node, player, pointed_thing)
		captureBlockZone()
	end
})

minetest.register_node("catan:settlement_location", {
	description = "Default settlement block",
	tiles = {"wool_black.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})

minetest.register_node("catan:road_default", {
	description = "Default road block",
	tiles = {"wool_white.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})

minetest.register_node("catan:road_red", {
	description = "Red road block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})

minetest.register_node("catan:road_builder", {
	description = "Road builder block",
	tiles = {"wool_orange.png"},
	groups = {crumbly=3},
	after_place_node = function(pos, player, itemstack, pointed_thing) catan_local.functions.roadBuilderPlace(player, pos) end
})
