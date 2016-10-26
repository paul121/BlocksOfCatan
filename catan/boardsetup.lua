local catan_local = ...
local xsize = catan_local.xsize;
local ysize = catan_local.ysize;
local zsize = catan_local.zsize;
catan_local.boardsettings = {}
catan_local.boardsettings.game_type = "default"
catan_local.boardsettings.layout = "random"
catan_local.boardsettings.style = "flat"
catan_local.boardsettings.number_layout = "random"
catan_local.boardsettings.status = "bare"

getBoardPos = function()
  local pos = catan_local.boardsettings.pos
  if pos then
    return pos
  else return nil end
end

setBoardPos = function(pos)
  local status = getBoardStatus()
  if status == "bare" then
    catan_local.boardsettings.pos = pos
  elseif status == "preview" then
    return "Board is currently in preview state. '/catan unpreivew' to set new pos."
  else
    return "Board is not in state to set pos."
  end

end

getBoardStatus = function()
  local status = catan_local.boardsettings.status
  if status then
    return status
  else return nil end
end

setBoardStatus = function(status)
  catan_local.boardsettings.status = status
end

setBoardLayout = function(layout)
  local status = getBoardStatus()
  if status ~= "created" then
    catan_local.boardsettings.layout = layout
  else
    return "Cannot set board layout, board is already created."
  end
end

setBoardStyle = function(style)
  local status = getBoardStatus()
  if status ~= "created" then
    catan_local.boardsettings.style = style
  else
    return "Cannot set board style, board is already created."
  end
end

setBoardNumberLayout = function(layout)
  local status = getBoardStatus()
  if status ~= "created" then
    catan_local.boardsettings.number_layout = layout
  else
    return "Cannot set board number layout, board is already created."
  end
end

setBoardGametype = function(type)
  local status = getBoardStatus()
  if status ~= "created" then
      catan_local.boardsettings.game_type = type
  else
    return "Cannot set board gametype, board is already created."
  end
end

catan_local.boardsettings.preview = false
catan_local.boardsettings.created = false

-- local functions
local isBoardCreated = function()
  return catan_local.boardsettings.created
end

local isBoardPreview = function()
  return catan_local.boardsettings.preview
end

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

local display_tile = function(tile, pos)
  local colors = {wheat="yellow", wool="green", wood="brown", ore="blue", brick="red", desert="white"}
  local color = colors[tile.type]

  worldedit.set(posOffset(-6, 0, -3, pos), posOffset(-6, 0, 3, pos), "wool:"..color)
  worldedit.set(posOffset(-5, 0, -4, pos), posOffset(-4, 0, 4, pos), "wool:"..color)
  worldedit.set(posOffset(-3, 0, -5, pos), posOffset(-3, 0, 5, pos), "wool:"..color)
  worldedit.set(posOffset(-2, 0, -6, pos), posOffset(-1, 0, 6, pos), "wool:"..color)
  ----------------------
  worldedit.set(posOffset(0, 0, -7, pos), posOffset(0, 0, 7, pos), "wool:"..color)
  ----------------------
  worldedit.set(posOffset(1, 0, -6, pos), posOffset(2, 0, 6, pos), "wool:"..color)
  worldedit.set(posOffset(3, 0, -5, pos), posOffset(3, 0, 5, pos), "wool:"..color)
  worldedit.set(posOffset(4, 0, -4, pos), posOffset(5, 0, 4, pos), "wool:"..color)
  worldedit.set(posOffset(6, 0, -3, pos), posOffset(6, 0, 3, pos), "wool:"..color)

end

local display_number = function (tile, pos)
  local number, color1, color2
  if tile.number ~= nil then
    if tile.number < 7 then
      color1 = "wool:white"
      color2 = "wool:black"
    else
      color1 = "wool:black"
      color2 = "wool:white"
    end

    worldedit.cylinder({x = pos.x, y = pos.y + 15, z = pos.z}, "y", 1, 4, color1, false)
    number = tonumber(tile.number)
    number = number % 6

    if number == 2 then
      worldedit.set({x = pos.x -1, y = pos.y + 15, z = pos.z -1}, {x = pos.x -1, y = pos.y + 15, z = pos.z -1}, color2)
      worldedit.set({x = pos.x +1, y = pos.y + 15, z = pos.z +1}, {x = pos.x +1, y = pos.y + 15, z = pos.z +1}, color2)
    elseif number == 3 then
      worldedit.set({x = pos.x -2, y = pos.y + 15, z = pos.z -2}, {x = pos.x -2, y = pos.y + 15, z = pos.z -2}, color2)
      worldedit.set({x = pos.x +2, y = pos.y + 15, z = pos.z +2}, {x = pos.x +2, y = pos.y + 15, z = pos.z +2}, color2)
      worldedit.set({x = pos.x , y = pos.y + 15, z = pos.z }, {x = pos.x , y = pos.y + 15, z = pos.z }, color2)
    elseif number == 4 then
      worldedit.set({x = pos.x -1, y = pos.y + 15, z = pos.z -1}, {x = pos.x -1, y = pos.y + 15, z = pos.z -1}, color2)
      worldedit.set({x = pos.x -1, y = pos.y + 15, z = pos.z +1}, {x = pos.x -1, y = pos.y + 15, z = pos.z +1}, color2)
      worldedit.set({x = pos.x +1, y = pos.y + 15, z = pos.z -1}, {x = pos.x +1, y = pos.y + 15, z = pos.z -1}, color2)
      worldedit.set({x = pos.x +1, y = pos.y + 15, z = pos.z +1}, {x = pos.x +1, y = pos.y + 15, z = pos.z +1}, color2)
    elseif number == 5 then
      worldedit.set({x = pos.x -2, y = pos.y + 15, z = pos.z -2}, {x = pos.x -2, y = pos.y + 15, z = pos.z -2}, color2)
      worldedit.set({x = pos.x +2, y = pos.y + 15, z = pos.z -2}, {x = pos.x +2, y = pos.y + 15, z = pos.z -2}, color2)
      worldedit.set({x = pos.x -2, y = pos.y + 15, z = pos.z +2}, {x = pos.x -2, y = pos.y + 15, z = pos.z +2}, color2)
      worldedit.set({x = pos.x +2, y = pos.y + 15, z = pos.z +2}, {x = pos.x +2, y = pos.y + 15, z = pos.z +2}, color2)
      worldedit.set({x = pos.x , y = pos.y + 15, z = pos.z }, {x = pos.x , y = pos.y + 15, z = pos.z }, color2)
    elseif number == 0 then
      worldedit.set({x = pos.x -2, y = pos.y + 15, z = pos.z -2}, {x = pos.x -2, y = pos.y + 15, z = pos.z -2}, color2)
      worldedit.set({x = pos.x +2, y = pos.y + 15, z = pos.z -2}, {x = pos.x +2, y = pos.y + 15, z = pos.z -2}, color2)
      worldedit.set({x = pos.x -2, y = pos.y + 15, z = pos.z +2}, {x = pos.x -2, y = pos.y + 15, z = pos.z +2}, color2)
      worldedit.set({x = pos.x +2, y = pos.y + 15, z = pos.z +2}, {x = pos.x +2, y = pos.y + 15, z = pos.z +2}, color2)
      worldedit.set({x = pos.x -2, y = pos.y + 15, z = pos.z }, {x = pos.x -2, y = pos.y + 15, z = pos.z }, color2)
      worldedit.set({x = pos.x +2, y = pos.y + 15, z = pos.z }, {x = pos.x +2, y = pos.y + 15, z = pos.z }, color2)
    end

  end
end

local display_settlementLocation = function(tile, pos)
  tile.settlement_locations = {}
  local offsets = {{x = pos.x - 7, y = pos.y, z = pos.z - 4}, {x = pos.x - 7, y = pos.y, z = pos.z + 4}, {x = pos.x, y = pos.y, z = pos.z + 8}, {x = pos.x + 7, y = pos.y, z = pos.z + 4}, {x = pos.x + 7, y = pos.y, z = pos.z - 4}, {x = pos.x, y = pos.y, z = pos.z - 8}}
  for i = 1, 6 do
    local pos = offsets[i]
    local currentNode = minetest.get_node(pos)
    if currentNode.name ~= "catan:settlement_location" then
      worldedit.set(pos, pos, "catan:settlement_location")
    end
    currentNode = minetest.get_node(pos)
    tile.settlement_locations[i] = currentNode
  end
end

local display_roads = function(tile, pos)
  local offset_corners = { {{x = pos.x - 7, y = pos.y, z = pos.z - 3}, {x = pos.x - 7, y = pos.y, z = pos.z + 3}}, {{x = pos.x - 6, y = pos.y, z = pos.z + 4}, {x = pos.x - 1, y = pos.y, z = pos.z + 8}}, {{x = pos.x + 1, y = pos.y, z = pos.z + 8}, {x = pos.x + 6, y = pos.y, z = pos.z + 4}}, {{x = pos.x + 7, y = pos.y, z = pos.z - 3}, {x = pos.x + 7, y = pos.y, z = pos.z + 3}}, {{x = pos.x + 1, y = pos.y, z = pos.z - 8}, {x = pos.x + 6, y = pos.y, z = pos.z - 4}}, {{x = pos.x - 1, y = pos.y, z = pos.z - 8}, {x = pos.x - 6, y = pos.y, z = pos.z -4}} }

  for i = 1, 6 do
    local pos1 = offset_corners[i][1]
    local pos2 = offset_corners[i][2]
    worldedit.replace(pos1, pos2, "default:stone", "catan:road_default")
  end

end

local display_board = function(board)
  local offsets = {{x=-28, y=0}, {x=-21, y=12}, {x=-14, y=24}, {x=0, y=24}, {x=14, y=24}, {x=21, y=12}, {x=28, y=0}, {x=21, y=-12}, {x=14, y=-24}, {x=0, y=-24}, {x=-14, y=-24}, {x=-21, y=-12}, {x=-14, y=0}, {x=-7, y=12}, {x=7, y=12}, {x=14, y=0}, {x=7, y=-12}, {x=-7, y=-12}, {x=0, y=0}}
  local pos = catan_local.boardsettings.pos

  for i = 19, 1, -1 do
    local offset = offsets[i]
    local tilecenter = {x = pos.x + offset.x, y = pos.y, z = pos.z + offset.y}
    local tile = board.tiles[i]
    display_tile(tile, tilecenter)
    display_number(tile, tilecenter)
    display_settlementLocation(tile, tilecenter)
    display_roads(tile, tilecenter)
  end
end


catan_local.functions.setboardpos = function(pos)
  setBoardPos(pos)

end

catan_local.functions.removeboardpos = function()
  setBoardPos()
end

catan_local.functions.previewboardarea = function()
  if catan_local.boardsettings.pos then
    local pos = catan_local.boardsettings.pos
    minetest.chat_send_all(catan_local.modchatprepend.."Previewing the board area.")
    minetest.chat_send_all(catan_local.modchatprepend.."You may not be able to move. Use command '/c:board-unpreview' to unpreview the area.")
    minetest.chat_send_all(catan_local.modchatprepend.."If you like the area, use command '/c:board'")
    worldedit.hide({x=pos.x - xsize/2, y=pos.y + 1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2})
    catan_local.boardsettings.preview = true
    setBoardStatus("preview")
  else
    minetest.chat_send_all(catan_local.modchatprepend.."ERROR: Cannot prieview the board area -- no pos is set. Set the position by placing the special block or command '/c:board-setpos' to set to current position.")
  end

end

catan_local.functions.unpreviewboardarea = function()
  if catan_local.boardsettings.pos and isBoardPreview() then
    local pos = catan_local.boardsettings.pos
    minetest.chat_send_all(catan_local.modchatprepend.."Unpreviewing the board area.")
    worldedit.restore({x=pos.x - xsize/2 , y=pos.y + 1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2})
    catan_local.boardsettings.preview = false
    setBoardStatus("bare")
  else
    minetest.chat_send_all(catan_local.modchatprepend.."ERROR: Cannot unprieview the board area -- no pos is set or there is no board in preview.")
  end
end

catan_local.functions.makeboard = function()
  local status = getBoardStatus()
  local pos = getBoardPos()
  if status ~= "created" then
    if pos then
      minetest.debug("Creating bord, clearing objects")
      minetest.chat_send_all(catan_local.modchatprepend.."Making board...please wait.")
      worldedit.restore({x=pos.x - xsize/2 , y=pos.y + 1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2})
      worldedit.set({x=pos.x - xsize/2 , y=pos.y, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y + ysize, z=pos.z+zsize/2}, "air")

      worldedit.set({x=pos.x - xsize/2 , y=pos.y-1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y, z=pos.z+zsize/2}, "default:stone")
      --worldedit.set({x=pos.x, y=pos.y, z=pos.z}, {x=pos.x, y=pos.y + 5, z=pos.z}, "wool:blue")
      local board = generate_board()
      display_board(board)
      setBoardStatus("created")
    else
      return "Cannot create board. Set to current pos with '/board set pos' "
    end
  else
    return "Cannot create board, board is already created."
  end
end
