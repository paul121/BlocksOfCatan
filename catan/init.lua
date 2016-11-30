catan = {}
local catan_local = {}
catan_local.api = {}
catan_local.board = {}

catan_local.modchatprepend = "CatanMod: "

local modpath = minetest.get_modpath(minetest.get_current_modname())
catan_local.singleplayer = minetest.is_singleplayer()

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


assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/util.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/boardsetup.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/roads.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/settlements.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/player.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/game.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/nodes.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/commands.lua"))(catan_local)

local init = function()
	local board = catan_local.board

	assert(loadfile(modpath .. "/util.lua"))(catan_local)
	assert(loadfile(modpath .. "/boardsetup.lua"))(catan_local)
	assert(loadfile(modpath .. "/roads.lua"))(catan_local)
	assert(loadfile(modpath .. "/settlements.lua"))(catan_local)

 end

 local firstInit = function()
 	assert(loadfile(modpath .. "/player.lua"))(catan_local)
	assert(loadfile(modpath .. "/nodes.lua"))(catan_local)
	assert(loadfile(modpath .. "/commands.lua"))(catan_local)
 end

 catan_local.reload = function()
  init()
 end

 init()
 firstInit()
