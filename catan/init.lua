local catan_local = {}
catan_local.modchatprepend = "CatanMod: "

catan_local.xsize = 86
catan_local.ysize = 20
catan_local.zsize = 80

catan_local.functions = {}

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

dofile(modpath.."/chatcmdbuilder/chatcmdbuilder.lua")

assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/nodes.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/commands.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/boardsetup.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/roads.lua"))(catan_local)
