local catan_local = ...

minetest.register_node("catan:board_center", {
	description = "Block for previewing catan board",
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) catan_local.functions.setboardpos(pos) end,
	on_rightclick = function(pos, node, player, pointed_thing)
		if catan_local.boardsettings.preview then
			catan_local.functions.unpreviewboardarea()
		else
			catan_local.functions.previewboardarea()
		end
	end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger) catan_local.functions.removeboardpos() end
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
