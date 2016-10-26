local catan_local = {}
catan_local.modchatprepend = "CatanMod: "

catan_local.xsize = 86
catan_local.ysize = 20
catan_local.zsize = 80

catan_local.functions = {}
catan_local.boardsettings = {}
catan_local.game_settings = {}
catan_local.game_settings.game_type = "default"
catan_local.game_settings.board_layout = "random"
catan_local.game_settings.board_style = "flat"
catan_local.game_settings.number_layout = "random"




local modpath = minetest.get_modpath(minetest.get_current_modname())


minetest.log("info", "Catan for minetest is starting up.")
minetest.debug("Catan for Minetest is starting up.")

local worldeditpath = modpath.."/worldedit/"

local loadmodule = function(path)
	local file = io.open(path)
	if not file then
		return
	end
	file:close()
	return dofile(path)
end

loadmodule(worldeditpath .. "/manipulations.lua")
loadmodule(worldeditpath .. "/primitives.lua")
loadmodule(worldeditpath .. "/visualization.lua")
loadmodule(worldeditpath .. "/serialization.lua")
loadmodule(worldeditpath .. "/code.lua")
loadmodule(worldeditpath .. "/compatibility.lua")

assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/nodes.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/commands.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/boardsetup.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/roads.lua"))(catan_local)


posOffset = function(x, y, z, pos)
  if x == nil then
    x = 0
  end
  if y == nil then
    y = 0
  end
  if z == nil then
    z = 0
  end
  return {x = pos.x + x, y = pos.y + y, z = pos.z + z}
end
