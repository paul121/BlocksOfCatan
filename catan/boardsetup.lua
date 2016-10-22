local catan_local = ...
local xsize = catan_local.xsize;
local ysize = catan_local.ysize;
local zsize = catan_local.zsize;



catan_local.boardsettings.preview = false

-- local functions
local generate_board = function()
  local seed = os.time()
  math.randomseed(seed)

  local board = {}
  board.tiles = {}
  board.numbers = {}
  board.harbors = {}

  --generate tiles
  local tile_count = 1
  local tile_types = {{name="desert", max=1, count=0}, {name="wheat", max=4, count=0}, {name="wool", max=4, count=0}, {name="wood", max=4, count=0}, {name="ore", max=3, count=0}, {name="brick", max=3, count=0}}

  while tile_count < 20 do
    local int = math.random(6)
    if tile_types[int].count < tile_types[int].max then
      board.tiles[tile_count] = {}
      board.tiles[tile_count].type = tile_types[int].name
      tile_types[int].count = tile_types[int].count + 1
      tile_count = tile_count + 1
    end
  end

  -- generate numbers
  tile_count = 1
  local number_types = {{value=2, max=1, count=0}, {value=3, max=2, count=0}, {value=4, max=2, count=0}, {value=5, max=2, count=0}, {value=6, max=2, count=0}, {value=8, max=2, count=0}, {value=9, max=2, count=0}, {value=10, max=2, count=0}, {value=11, max=2, count=0}, {value=12, max=1, count=0}}
  while tile_count < 20 do
    local int = math.random(10)
    if board.tiles[tile_count].type ~= "desert" then
      if number_types[int].count < number_types[int].max then
        board.tiles[tile_count].number = number_types[int].value
        number_types[int].count = number_types[int].count + 1
        tile_count = tile_count + 1
      end
    else
      minetest.chat_send_all("found a desert")
      tile_count = tile_count + 1
    end
  end


  for i in pairs(board.tiles) do
    minetest.chat_send_all(catan_local.modchatprepend.."Tile: "..i.." is of type "..board.tiles[i].type.." with dice number "..tostring(board.tiles[i].number).."!")
  end

  return board
end

local display_tile = function(pos, offset, color)
  local x = pos.x + offset.x
  local y = pos.y
  local z = pos.z + offset.y
  --worldedit.set({x = pos.x + offset.x, y= pos.y, z = pos.z + offset.y}, {x = pos.x + offset.x, y= pos.y, z = pos.z + offset.y}, "wool:"..color)

  for i = 1, 7 do
    local row_offset = {x = offset.x - 6, y = offset.y - 4 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 9 do
    local row_offset = {x = offset.x - 5, y = offset.y - 5 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 9 do
    local row_offset = {x = offset.x - 4, y = offset.y - 5 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 11 do
    local row_offset = {x = offset.x - 3, y = offset.y - 6 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 13 do
    local row_offset = {x = offset.x - 2, y = offset.y - 7 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 13 do
    local row_offset = {x = offset.x - 1, y = offset.y - 7 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end
---------------------------
  for i = 1, 15 do
    local row_offset = {x = offset.x, y = offset.y - 8 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end
---------------------------
  for i = 1, 13 do
    local row_offset = {x = offset.x + 1, y = offset.y - 7 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 13 do
    local row_offset = {x = offset.x + 2, y = offset.y - 7 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 11 do
    local row_offset = {x = offset.x + 3, y = offset.y - 6 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 9 do
    local row_offset = {x = offset.x + 4, y = offset.y - 5 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 9 do
    local row_offset = {x = offset.x + 5, y = offset.y - 5 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end

  for i = 1, 7 do
    local row_offset = {x = offset.x + 6, y = offset.y - 4 + i }
    worldedit.set({x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, {x = pos.x + row_offset.x, y= pos.y, z = pos.z + row_offset.y}, "wool:"..color)
  end
  --minetest.chat_send_all(x..""..y..""..z)
end

local display_board = function(board)
  local offsets = {{x=-28, y=0}, {x=-21, y=12}, {x=-14, y=24}, {x=0, y=24}, {x=14, y=24}, {x=21, y=12}, {x=28, y=0}, {x=21, y=-12}, {x=14, y=-24}, {x=0, y=-24}, {x=-14, y=-24}, {x=-21, y=-12}, {x=-14, y=0}, {x=-7, y=12}, {x=7, y=12}, {x=14, y=0}, {x=7, y=-12}, {x=-7, y=-12}, {x=0, y=0}}
  local pos = catan_local.boardsettings.pos
  for i = 19, 1, -1 do
    local colors = {wheat="yellow", wool="green", wood="brown", ore="blue", brick="red", desert="white"}
    local type = board.tiles[i].type
    local color = colors[type]
    local offset = offsets[i]


    display_tile(pos, offset, color)

  end

end


catan_local.functions.setboardpos = function(pos)
  if catan_local.boardsettings.preview then
    catan_local.functions.unpreviewboardarea()
  end
  minetest.chat_send_all(catan_local.modchatprepend.."Center of board set to: "..minetest.pos_to_string(pos))
  catan_local.boardsettings.pos = pos

end

catan_local.functions.removeboardpos = function()
  minetest.chat_send_all(catan_local.modchatprepend.."Removing the board center position.")
  catan_local.boardsettings.pos = nil
end

catan_local.functions.previewboardarea = function()
  if catan_local.boardsettings.pos then
    local pos = catan_local.boardsettings.pos
    minetest.chat_send_all(catan_local.modchatprepend.."Previewing the board area.")
    minetest.chat_send_all(catan_local.modchatprepend.."You may not be able to move. Use command '/c:board-unpreview' to unpreview the area.")
    minetest.chat_send_all(catan_local.modchatprepend.."If you like the area, use command '/c:board'")
    worldedit.hide({x=pos.x - xsize/2, y=pos.y + 1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2})
    catan_local.boardsettings.preview = true
  else
    minetest.chat_send_all(catan_local.modchatprepend.."ERROR: Cannot prieview the board area -- no pos is set. Set the position by placing the special block or command '/c:board-setpos' to set to current position.")
  end

end

catan_local.functions.unpreviewboardarea = function()
  if catan_local.boardsettings.pos and catan_local.boardsettings.preview then
    local pos = catan_local.boardsettings.pos
    minetest.chat_send_all(catan_local.modchatprepend.."Unpreviewing the board area.")
    worldedit.restore({x=pos.x - xsize/2 , y=pos.y + 1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2})
    catan_local.boardsettings.preview = false
  else
    minetest.chat_send_all(catan_local.modchatprepend.."ERROR: Cannot unprieview the board area -- no pos is set or there is no board in preview.")
  end
end

catan_local.functions.makeboard = function()
  if catan_local.boardsettings.pos then
    local pos = catan_local.boardsettings.pos
    minetest.debug("Creating bord, clearing objects")
    minetest.chat_send_all(catan_local.modchatprepend.."Making board...please wait.")
    worldedit.restore({x=pos.x - xsize/2 , y=pos.y + 1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2})
    worldedit.set({x=pos.x - xsize/2 , y=pos.y, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2}, "air")

    worldedit.set({x=pos.x - xsize/2 , y=pos.y-1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y, z=pos.z+zsize/2}, "default:stone")
    --worldedit.set({x=pos.x, y=pos.y, z=pos.z}, {x=pos.x, y=pos.y + 5, z=pos.z}, "wool:blue")
    local board = generate_board()
    display_board(board)
  else
    minetest.chat_send_all(catan_local.modchatprepend.."ERROR: Cannot make board. Please set and a preview a board position by placing the special block or by using command '/c:board-setpos'")
  end
end
