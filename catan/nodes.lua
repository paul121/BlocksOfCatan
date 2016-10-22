local catan_local = ...

minetest.register_node("catan:board_center", {
	description = "Block for previewing catan board",
	is_ground_content = true,
	groups = {crumbly=3},
  drop = "catan:board_center",
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
