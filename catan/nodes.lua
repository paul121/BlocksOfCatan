local catan_local = ...

local boardSetup = catan_local.api.boardSetup
local roadControl = catan_local.api.roadControl
local settlementControl = catan_local.api.settlementControl

minetest.register_node("catan:board_center", {
	description = "Block for previewing catan board",
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) boardSetup.setBoardPos(pos) end,
	on_rightclick = function(pos, node, player, pointed_thing)
		boardSetup.previewBoardArea()
	end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger) boardSetup.setBoardPos() end
})

minetest.register_node("catan:board_placeholder", {
	description = "Block used as a place holder. Replaced after board generation.",
	tiles = {"wool_red.png"},
	is_ground_content = true,
	groups = {crumbly=3}

})

minetest.register_node("catan:capture_pos1", {
	description = "Block for setting worldedit capture position.",
	tiles = {"default_diamond_block.png"},
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) boardSetup.setCapturePos(pos, 1) end
})

minetest.register_node("catan:capture_pos2", {
	description = "Block for setting worldedit capture position.",
	tiles = {"default_gold_block.png"},
	is_ground_content = true,
	groups = {crumbly=3},
  after_place_node = function(pos, placer, itemstack, pointed_thing) boardSetup.setCapturePos(pos, 2) end
})

minetest.register_node("catan:settlement_location", {
	description = "Default settlement block",
	tiles = {"wool_black.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})

minetest.register_node("catan:settlement_builder", {
	description = "Settlement builder block",
	tiles = {"default_copper_block.png"},
	is_ground_content = true,
	groups = {crumbly=3},
	after_place_node = function(pos, player, itemstack, pointed_thing) settlementControl.onSettlementBuilderPlace(player, pos) end
})
minetest.register_node("catan:settlement_red", {
	description = "Red settlement",
	tiles = {"wool_red.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})
minetest.register_node("catan:settlement_green", {
	description = "Green settlement",
	tiles = {"wool_green.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})
minetest.register_node("catan:settlement_blue", {
	description = "Blue settlement",
	tiles = {"wool_blue.png"},
	is_ground_content = true,
	groups = {crumbly=3}
})
minetest.register_node("catan:settlement_yellow", {
	description = "Yellow settlement",
	tiles = {"wool_yellow.png"},
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
	after_place_node = function(pos, player, itemstack, pointed_thing) roadControl.onRoadBuilderPlace(player, pos) end
})

minetest.register_node("catan:wheat_resource", {
	description = "Catan wheat resource",
	tiles = {"farming_wheat.png"},
	is_ground_content = false,
	groups = {crumbly=3}
})
minetest.register_node("catan:wool_resource", {
	description = "Catan wool resource",
	tiles = {"wool_white.png"},
	is_ground_content = false,
	groups = {crumbly=3}
})
minetest.register_node("catan:wood_resource", {
	description = "Catan wood resource",
	tiles = {"default_wood_top.png"},
	is_ground_content = false,
	groups = {crumbly=3}
})
minetest.register_node("catan:ore_resource", {
	description = "Catan ore resource",
	tiles = {"default_coal_block.png"},
	is_ground_content = false,
	groups = {crumbly=3}
})
minetest.register_node("catan:brick_resource", {
	description = "Catan brick resource",
	tiles = {"default_clay_brick.png"},
	is_ground_content = false,
	groups = {crumbly=3}
})
