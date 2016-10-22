local catan_local = {}
catan_local.xsize = 86
catan_local.ysize = 20
catan_local.zsize = 80
catan_local.functions = {}
catan_local.boardsettings = {}
catan_local.teststring = "here is a test"
catan_local.modchatprepend = "CatanMod: "

local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.log("info", "Catan for minetest is starting up.")
minetest.debug("Catan for Minetest is starting up.")

assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/nodes.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/commands.lua"))(catan_local)
assert(loadfile(minetest.get_modpath(minetest.get_current_modname()) .. "/boardsetup.lua"))(catan_local)
