local catan_local = ...
local xsize = catan_local.xsize;
local ysize = catan_local.ysize;
local zsize = catan_local.zsize;
catan_local.boardsettings = {}
catan_local.boardsettings.game_type = "default"
catan_local.boardsettings.layout = "random"
catan_local.boardsettings.style = "default"
catan_local.boardsettings.number_layout = "random"
catan_local.boardsettings.status = "bare"

local capturePos = {}
--utilities
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

--file i/o
local zoneTypes = {board_layout = "/board_layouts", board_style = "/board_styles", game_type = "/game_types", number_layout = "/number_layouts", exports = "/exports"}

saveBlockZone = function(data, filename, type, name)
  local zoneType = zoneTypes[type]
  if zoneType ~= nil then
    if name then name = "/"..name else name = "" end
    if filename then filename = "/"..filename..".txt" else name = "" end
    local file = io.open(minetest.get_modpath("catan")..zoneType..name..filename, "w")
    if file then
      file:write(data)
      file:close()
      return true
    else
      return false, "could not open file path to write to"
    end
  else
    return false, "invalid block zone type"
  end
end

loadBlockZone = function(filename, type, name)
  local zoneType = zoneTypes[type]
  if zoneType ~= nil then
    if name then name = "/"..name end
    if filename then filename = "/"..filename..".txt" end
    local file = io.open(minetest.get_modpath("catan")..zoneType..name..filename, "r")
    if file then
      local data = file:read("*all")
      return data
    else
      return false, "could not open file"
    end
  end
end

--for development, capturing block areas and saving blocks in range to file
setCapturePos = function(pos, posNum)
  capturePos[posNum] = pos
end

captureBlockZone = function(filename)
  if capturePos[1] and capturePos[2] then
    local pos1 = posOffset(0, -1, 0, capturePos[1])
    local pos2 = posOffset(0, -1, 0, capturePos[2])
    local data = worldedit.serialize(pos1, pos2)
    local saved, error = saveBlockZone( data, filename, "exports")
    if not saved then
      return error
    end
  else
    return "ERROR: Cannot capture the block zone. Set the 2 zone positions first."
  end
end



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

getBoardLayout = function()
  return catan_local.boardsettings.layout
end

setBoardStyle = function(style)
  local status = getBoardStatus()
  if status ~= "created" then
    catan_local.boardsettings.style = style
  else
    return "Cannot set board style, board is already created."
  end
 end

getBoardStyle = function()
  return catan_local.boardsettings.style
end

setBoardNumberLayout = function(layout)
  local status = getBoardStatus()
  if status ~= "created" then
    catan_local.boardsettings.number_layout = layout
  else
    return "Cannot set board number layout, board is already created."
  end
end

getBoardNumberLayout = function()
  return catan_local.boardsettings.number_layout
end

setBoardGametype = function(type)
  local status = getBoardStatus()
  if status ~= "created" then
      catan_local.boardsettings.game_type = type
  else
    return "Cannot set board gametype, board is already created."
  end
end

getBoardGametype = function()
  return catan_local.boardsettings.game_type
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
  board.harbors = {}
  board.settings = {}

  --board settings
  board.settings.layout = getBoardLayout()
  board.settings.style = getBoardStyle()
  board.settings.numberLayout = getBoardNumberLayout()
  board.settings.gametype = getBoardGametype()



  --generate tiles
  if board.settings.layout == "random" then
    local tile_count = 1
    local tile_types = {{name="desert", max=1, count=0}, {name="wheat", max=4, count=0}, {name="wool", max=4, count=0}, {name="wood", max=4, count=0}, {name="ore", max=3, count=0}, {name="brick", max=3, count=0}}

    while tile_count < 20 do
      local int = math.random(#tile_types)
      if tile_types[int].count < tile_types[int].max then
        board.tiles[tile_count] = {}
        board.tiles[tile_count].type = tile_types[int].name
        board.tiles[tile_count].settlements = {{}, {}, {}, {}, {}, {}}
        tile_types[int].count = tile_types[int].count + 1
        tile_count = tile_count + 1
      end
    end
  else
    --load layout from file
  end

  -- generate numbers
  if board.settings.numberLayout == "random" then
    tile_count = 1
    local number_types = {{value=2, max=1, count=0}, {value=3, max=2, count=0}, {value=4, max=2, count=0}, {value=5, max=2, count=0}, {value=6, max=2, count=0}, {value=8, max=2, count=0}, {value=9, max=2, count=0}, {value=10, max=2, count=0}, {value=11, max=2, count=0}, {value=12, max=1, count=0}}
    while tile_count < 20 do
      local int = math.random(#number_types)
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
  else
    --load numberlayout
  end

  --generare harbors
  tile_count = 1
  local harbor = {type = "generic", tradeIn = "", tradeInQty = 0}
  local harbor_types = {{harbor={type = "generic", tradeIn = "any", tradeInQty = 3}, max=4, count=0}, {harbor={type = "unique", tradeIn = "ore", tradeInQty = 2}, max=1, count=0}, {harbor={type = "unique", tradeIn = "wool", tradeInQty = 2}, max=1, count=0}, {harbor={type = "unique", tradeIn = "wood", tradeInQty = 2}, max=1, count=0}, {harbor={type = "unqiue", tradeIn = "wheat", tradeInQty = 2}, max=1, count=0}, {harbor={type = "unique", tradeIn = "brick", tradeInQty = 2}, max=1, count=0}}
  while tile_count < 9 do
    local int = math.random(#harbor_types)
    if harbor_types[int].count < harbor_types[int].max then
      board.harbors = harbor_types[int].harbor
      harbor_types[int].count = harbor_types[int].count + 1
      tile_count = tile_count + 1
    end
  end
  local harborList = {
    {blockZone = "harborTop", xOffset = -13, zOffset = -4, tiles = { {tile = 1, settlement = {2}}, {tile = 2, settlement = {1, 6}} } },
    {blockZone = "harborTopRight", xOffset = -7, zOffset = 5, tiles = { {tile = 3, settlement = {1, 2}} }},
    {blockZone = "harborBottomRight", xOffset = 0, zOffset = 5, tiles = { {tile = 5, settlement = {1}}, {tile = 4, settlement = {2,3}} }},
    {blockZone = "harborBottomRight", xOffset = 0, zOffset = 5, tiles = { {tile = 5, settlement = {4}}, {tile = 6, settlement = {2,3}} }},

    {blockZone = "harborBottom", xOffset = 8, zOffset = -4, tiles = { {tile = 7, settlement = {3,4}} }},

    {blockZone = "harborBottomLeft", tile = 8, xOffset = 0, zOffset = -11, tiles = { {tile = 9, settlement = {3}}, {tile = 8, settlement = {4,5}} }},
    {blockZone = "harborBottomLeft", xOffset = 0, zOffset = -11, tiles = { {tile = 9, settlement = {6}}, {tile = 10, settlement = {4,5}} }},
    {blockZone = "harborTopLeft", xOffset = -7, zOffset = -11, tiles = { {tile = 11, settlement = {5, 6}} }},
    {blockZone = "harborTop", xOffset = -13, zOffset = -4, tiles = { {tile = 1, settlement = {5}}, {tile = 12, settlement = {1, 6}} }}
  }
    --local harborInfoText = "This settlement is harbor number "..harbor.."!"
    --local meta = minetest.get_meta(board.tiles[tile].settlements[settlement].pos)
    --meta:set_string("infotext", harborInfoText)
  for harbor = 1, #harborList do
    local harborGen = harborList[harbor]
    for tile = 1, #harborGen.tiles do
      local tileNum = harborGen.tiles[tile].tile
      for settlement = 1, #harborGen.tiles[tile].settlement do
        board.tiles[tileNum].settlements[settlement].harbor = board.harbors[harbor]
        if settlement == 2 then
          board.tiles[tileNum].settlements[settlement].harborGen = harborGen
        end
      end
    end
  end

  for i in pairs(board.tiles) do
    minetest.chat_send_all(catan_local.modchatprepend.."Tile: "..i.." is of type "..board.tiles[i].type.." with dice number "..tostring(board.tiles[i].number).."!")
  end

  return board
end

local display_tile = function(tile, style)
  local pos = tile.tilecenter
  local colors = {wheat="yellow", wool="green", wood="brown", ore="blue", brick="red", desert="white"}
  local color = colors[tile.type]

  if style then
    local data = loadBlockZone(tile.type, "board_style", style)
    worldedit.deserialize(posOffset(-6, 0, -7, pos), data)
  else
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

end

local display_number = function (tile, style)
  local pos = tile.tilecenter
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

local display_settlementLocation = function(tile)
  local pos = tile.tilecenter
  local offsets = {{x = pos.x - 7, y = pos.y, z = pos.z + 4}, {x = pos.x, y = pos.y, z = pos.z + 8}, {x = pos.x + 7, y = pos.y, z = pos.z + 4}, {x = pos.x + 7, y = pos.y, z = pos.z - 4}, {x = pos.x, y = pos.y, z = pos.z - 8}, {x = pos.x - 7, y = pos.y, z = pos.z - 4}}
  for i = 1, 6 do
    local pos = offsets[i]
    local currentNode = minetest.get_node(pos)
    if currentNode.name ~= "catan:settlement_location" then
      worldedit.set(pos, pos, "catan:settlement_location")
    end
    currentNode = minetest.get_node(pos)
    tile.settlements[i].node = currentNode
    tile.settlements[i].pos = pos

  end
end

local display_roads = function(tile, style)
  local pos = tile.tilecenter
  if style then
    local data = loadBlockZone("road", "board_style", style)
    worldedit.deserialize(posOffset(-7, 0, -8, pos), data)
  else
    local offset_corners = { {{x = pos.x - 7, y = pos.y, z = pos.z - 3}, {x = pos.x - 7, y = pos.y, z = pos.z + 3}}, {{x = pos.x - 6, y = pos.y, z = pos.z + 4}, {x = pos.x - 1, y = pos.y, z = pos.z + 8}}, {{x = pos.x + 1, y = pos.y, z = pos.z + 8}, {x = pos.x + 6, y = pos.y, z = pos.z + 4}}, {{x = pos.x + 7, y = pos.y, z = pos.z - 3}, {x = pos.x + 7, y = pos.y, z = pos.z + 3}}, {{x = pos.x + 1, y = pos.y, z = pos.z - 8}, {x = pos.x + 6, y = pos.y, z = pos.z - 4}}, {{x = pos.x - 1, y = pos.y, z = pos.z - 8}, {x = pos.x - 6, y = pos.y, z = pos.z -4}} }
    for i = 1, 6 do
      local pos1 = offset_corners[i][1]
      local pos2 = offset_corners[i][2]
      worldedit.replace(pos1, pos2, "default:stone", "catan:road_default")
    end
  end
end

local setNodeInfoText = function(pos, text)

end

local display_harbors = function(tile, style)
  local pos = tile.tilecenter
  for i = 1, #tile.settlements do
    if tile.settlements[i].harborGen then
      local harborGen = tile.settlements[i].harborGen
      local data = loadBlockZone(harborGen.blockZone, "board_style", style)
      worldedit.deserialize(posOffset(harborGen.xOffset, 0, harborGen.zOffset, pos), data)
    end
  end
end

local display_board = function(board)
  local boardStyle = board.settings.style
  local offsets = {{x=-28, y=0}, {x=-21, y=12}, {x=-14, y=24}, {x=0, y=24}, {x=14, y=24}, {x=21, y=12}, {x=28, y=0}, {x=21, y=-12}, {x=14, y=-24}, {x=0, y=-24}, {x=-14, y=-24}, {x=-21, y=-12}, {x=-14, y=0}, {x=-7, y=12}, {x=7, y=12}, {x=14, y=0}, {x=7, y=-12}, {x=-7, y=-12}, {x=0, y=0}}
  local pos = catan_local.boardsettings.pos

  for i = 19, 1, -1 do
    local offset = offsets[i]
    local tile = board.tiles[i]
    tile.tilecenter = {x = pos.x + offset.x, y = pos.y, z = pos.z + offset.y}
    display_tile(tile, boardStyle)
    display_number(tile, boardStyle)
    display_settlementLocation(tile)
    display_harbors(tile, boardStyle)
    display_roads(tile, boardStyle)
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

      worldedit.set({x=pos.x - xsize/2 , y=pos.y-1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y, z=pos.z+zsize/2}, "catan:board_placeholder")
      --worldedit.set({x=pos.x, y=pos.y, z=pos.z}, {x=pos.x, y=pos.y + 5, z=pos.z}, "wool:blue")
      local board = generate_board()
      display_board(board)
      setBoardStatus("created")
      worldedit.replace({x=pos.x - xsize/2 , y=pos.y-1, z=pos.z - zsize/2}, {x=pos.x + xsize/2, y=pos.y, z=pos.z+zsize/2}, "catan:board_placeholder", "default:water_source")
    else
      return "Cannot create board. Set to current pos with '/board set pos' "
    end
  else
    return "Cannot create board, board is already created."
  end
end
