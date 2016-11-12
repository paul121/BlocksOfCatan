--
local catan_local = ...
local util = catan_local.api.util
local board = catan_local.board

--create boardSetup
catan_local.api.boardSetup = {}
local boardSetup = catan_local.api.boardSetup

local loadBoard = function(savedBoard)
  if savedBoard then
    return savedBoard
  else
    local defaultBoard = {}
    defaultBoard.settings = {}
    defaultBoard.settings.gameType = "default"
    defaultBoard.settings.layout = "random"
    defaultBoard.settings.style = "default"
    defaultBoard.settings.numberLayout = "random"
    defaultBoard.players = {}
    defaultBoard.playerMap = {}
    defaultBoard.generated = false
    defaultBoard.status = "bare"
    defaultBoard.created = false
    defaultBoard.pos = nil

    defaultBoard.xSize = 86
    defaultBoard.ySize = 20
    defaultBoard.zSize = 80
    return defaultBoard
  end
end

----------------------------------------------------
--LOCAL FUNCTIONS
----------------------------------------------------

--for development, capturing block areas and saving blocks in range to file
----------------------------------------------------
local capturePos = {}

local setCapturePos = function(pos, posNum)
  capturePos[posNum] = pos
end

local captureBlockZone = function(filename)
  if capturePos[1] and capturePos[2] then
    local pos1 = util.posOffset(0, -1, 0, capturePos[1])
    local pos2 = util.posOffset(0, -1, 0, capturePos[2])
    local data = worldedit.serialize(pos1, pos2)
    local saved, error = util.saveBlockZone( data, filename, "exports")
    if not saved then
      return error
    end
  else
    return "ERROR: Cannot capture the block zone. Set the 2 zone positions first."
  end
end


--Handle attributes of the board such as positon and status
----------------------------------------------------
local getBoardStatus = function()
  local status = board.status
  if status then
    return status
  else return nil end
end

local setBoardStatus = function(status)
  board.status = status
end

local getBoardPos = function()
  local pos = board.pos
  if pos then
    return pos
  else return nil end
end

local setBoardPos = function(pos)
  local status = getBoardStatus()
  if status == "bare" then
    board.pos = pos
  elseif status == "preview" then
    return "Board is currently in preview state. '/catan unpreivew' to set new pos."
  else
    return "Board is not in state to set pos."
  end

end


--Handle retrieval and setting of board settings (layout, style, etc)
----------------------------------------------------
local setBoardLayout = function(layout)
  local status = getBoardStatus()
  if status ~= "created" then
    board.settings.layout = layout
  else
    return "Cannot set board layout, board is already created."
  end
end

local getBoardLayout = function()
  return board.settings.layout
end

local setBoardStyle = function(style)
  local status = getBoardStatus()
  if status ~= "created" then
    board.settings.style = style
  else
    return "Cannot set board style, board is already created."
  end
 end

local getBoardStyle = function()
  return board.settings.style
end

local setBoardNumberLayout = function(layout)
  local status = getBoardStatus()
  if status ~= "created" then
    board.settings.numberLayout = layout
  else
    return "Cannot set board number layout, board is already created."
  end
end

local getBoardNumberLayout = function()
  return board.settings.numberLayout
end

local setBoardGameType = function(type)
  local status = getBoardStatus()
  if status ~= "created" then
      board.settings.gameType = type
  else
    return "Cannot set board gametype, board is already created."
  end
end

local getBoardGameType = function()
  return board.settings.gameType
end

--Generate Board
----------------------------------------------------

local generate_board = function()
  local seed = os.time()
  math.randomseed(seed)

  board.tiles = {}
  board.harbors = {}

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

  board.created = true
  return board
end


--Functions that display specific aspects of the board
----------------------------------------------------
local display_tile = function(tile, style)
  local pos = tile.tileCenter
  local colors = {wheat="yellow", wool="green", wood="brown", ore="blue", brick="red", desert="white"}
  local color = colors[tile.type]

  if style then
    local data = util.loadBlockZone(tile.type, "board_style", style)
    worldedit.deserialize(util.posOffset(-6, 0, -7, pos), data)
  else
    worldedit.set(util.posOffset(-6, 0, -3, pos), util.posOffset(-6, 0, 3, pos), "wool:"..color)
    worldedit.set(util.posOffset(-5, 0, -4, pos), util.posOffset(-4, 0, 4, pos), "wool:"..color)
    worldedit.set(util.posOffset(-3, 0, -5, pos), util.posOffset(-3, 0, 5, pos), "wool:"..color)
    worldedit.set(util.posOffset(-2, 0, -6, pos), util.posOffset(-1, 0, 6, pos), "wool:"..color)
    ----------------------
    worldedit.set(util.posOffset(0, 0, -7, pos), util.posOffset(0, 0, 7, pos), "wool:"..color)
    ----------------------
    worldedit.set(util.posOffset(1, 0, -6, pos), util.posOffset(2, 0, 6, pos), "wool:"..color)
    worldedit.set(util.posOffset(3, 0, -5, pos), util.posOffset(3, 0, 5, pos), "wool:"..color)
    worldedit.set(util.posOffset(4, 0, -4, pos), util.posOffset(5, 0, 4, pos), "wool:"..color)
    worldedit.set(util.posOffset(6, 0, -3, pos), util.posOffset(6, 0, 3, pos), "wool:"..color)
  end

end

local display_number = function (tile, style)
  local pos = tile.tileCenter
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
  local pos = tile.tileCenter
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
  local pos = tile.tileCenter
  if style then
    local data = util.loadBlockZone("road", "board_style", style)
    worldedit.deserialize(util.posOffset(-7, 0, -8, pos), data)
  else
    local offset_corners = { {{x = pos.x - 7, y = pos.y, z = pos.z - 3}, {x = pos.x - 7, y = pos.y, z = pos.z + 3}}, {{x = pos.x - 6, y = pos.y, z = pos.z + 4}, {x = pos.x - 1, y = pos.y, z = pos.z + 8}}, {{x = pos.x + 1, y = pos.y, z = pos.z + 8}, {x = pos.x + 6, y = pos.y, z = pos.z + 4}}, {{x = pos.x + 7, y = pos.y, z = pos.z - 3}, {x = pos.x + 7, y = pos.y, z = pos.z + 3}}, {{x = pos.x + 1, y = pos.y, z = pos.z - 8}, {x = pos.x + 6, y = pos.y, z = pos.z - 4}}, {{x = pos.x - 1, y = pos.y, z = pos.z - 8}, {x = pos.x - 6, y = pos.y, z = pos.z -4}} }
    for i = 1, 6 do
      local pos1 = offset_corners[i][1]
      local pos2 = offset_corners[i][2]
      worldedit.replace(pos1, pos2, "default:stone", "catan:road_default")
    end
  end
end

local display_harbors = function(tile, style)
  local pos = tile.tileCenter
  for i = 1, #tile.settlements do
    if tile.settlements[i].harborGen then
      local harborGen = tile.settlements[i].harborGen
      local data = util.loadBlockZone(harborGen.blockZone, "board_style", style)
      worldedit.deserialize(util.posOffset(harborGen.xOffset, 0, harborGen.zOffset, pos), data)
    end
  end
end

--Display the board
----------------------------------------------------
local display_board = function(board)
  local boardStyle = board.settings.style
  local offsets = {{x=-28, y=0}, {x=-21, y=12}, {x=-14, y=24}, {x=0, y=24}, {x=14, y=24}, {x=21, y=12}, {x=28, y=0}, {x=21, y=-12}, {x=14, y=-24}, {x=0, y=-24}, {x=-14, y=-24}, {x=-21, y=-12}, {x=-14, y=0}, {x=-7, y=12}, {x=7, y=12}, {x=14, y=0}, {x=7, y=-12}, {x=-7, y=-12}, {x=0, y=0}}
  local pos = getBoardPos()

  for i = 19, 1, -1 do
    local offset = offsets[i]
    local tile = board.tiles[i]
    tile.tileCenter = {x = pos.x + offset.x, y = pos.y, z = pos.z + offset.y}
    display_tile(tile, boardStyle)
    display_number(tile, boardStyle)
    display_settlementLocation(tile)
    display_harbors(tile, boardStyle)
    display_roads(tile, boardStyle)
  end
end

local makeBoard = function()
  local xSize = board.xSize
  local ySize = board.ySize
  local zSize = board.zSize
  local status = getBoardStatus()
  local pos = getBoardPos()
  if pos and status ~= "created" then
      minetest.debug("Creating bord, clearing objects")
      minetest.chat_send_all(catan_local.modchatprepend.."Making board...please wait.")
      worldedit.restore(util.posOffset( -(xSize/2), 1, -(zSize/2), pos) , util.posOffset(xSize/2, ySize, zSize/2, pos))
      worldedit.set(util.posOffset( -(xSize/2), 1, -(zSize/2), pos) , util.posOffset(xSize/2, ySize, zSize/2, pos), "air")

      worldedit.set(util.posOffset( -(xSize/2), 0, -(zSize/2), pos) , util.posOffset(xSize/2, 0, zSize/2, pos), "catan:board_placeholder")
      --worldedit.set({x=pos.x, y=pos.y, z=pos.z}, {x=pos.x, y=pos.y + 5, z=pos.z}, "wool:blue")
      if not board.created then
        board = generate_board()
      end
      display_board(board)
      worldedit.replace(util.posOffset( -(xSize/2), 0, -(zSize/2), pos) , util.posOffset(xSize/2, 0, zSize/2, pos), "catan:board_placeholder", "default:water_source")
      setBoardStatus("created")
      util.saveBoard()
  elseif pos then
    return "Cannot create board, board is already created."
  else
    return "Cannot create board. Set to current pos with '/board set pos' "
  end
end


--Handle previewing of the board area
----------------------------------------------------
local previewBoardArea = function()
  local xSize = board.xSize
  local ySize = board.ySize
  local zSize = board.zSize
  local pos = getBoardPos()
  local status = getBoardStatus()
  if pos and status ~= "created" then
    minetest.chat_send_all(catan_local.modchatprepend.."Previewing the board area.")
    minetest.chat_send_all(catan_local.modchatprepend.."You may not be able to move. Use command '/board unpreview' to unpreview the area.")
    minetest.chat_send_all(catan_local.modchatprepend.."If you like the area, use command '/board create'")
    worldedit.hide( util.posOffset( -(xSize/2), 0, -(zSize/2), pos), util.posOffset(xSize/2, ySize, zSize/2, pos) )
    setBoardStatus("preview")
  elseif pos then
    return "ERROR: Cannot prieview the board area -- no pos is set. Set the position by placing the special block or command '/board set pos' to set to current position."
  else
    return "ERROR: Board is already created. Cannot preview board area."
  end
end

local unPreviewBoardArea = function()
  local xSize = board.xSize
  local ySize = board.ySize
  local zSize = board.zSize
  local pos = getBoardPos()
  local status = getBoardStatus()
  if pos and status == "preview" then
    minetest.chat_send_all(catan_local.modchatprepend.."Unpreviewing the board area.")
    worldedit.restore(util.posOffset( -(xSize/2), 0, -(zSize/2), pos) , util.posOffset(xSize/2, ySize, zSize/2, pos))
    setBoardStatus("bare")
  elseif pos then
    return "ERROR: Board is not in preview state. Cannot unpreview."
  else
    return "ERROR: Board pos is not set."
  end
end


--local api wrapper functions
boardSetup.getBoardStatus = function()
  return getBoardStatus()
end

boardSetup.setBoardPos = function(pos)
  return setBoardPos(pos)
end

boardSetup.setBoardLayout = function(layout)
  return setBoardLayout(layout)
end

boardSetup.setBoardStyle = function(style)
  return setBoardStyle(style)
end

boardSetup.setBoardNumberLayout = function(layout)
  return setBoardNumberLayout(layout)
end

boardSetup.setBoardGameType = function(type)
  return setBoardGameType(type)
end

boardSetup.previewBoardArea = function()
  return previewBoardArea()
end

boardSetup.unPreviewBoardArea = function()
  return unPreviewBoardArea()
end

boardSetup.makeBoard = function()
  return makeBoard()
end

boardSetup.captureBlockZone = function(filename)
  return captureBlockZone(filename)
end

boardSetup.setCapturePos = function(pos, posNum)
  return setCapturePos(pos, posNum)
end

boardSetup.loadBoard = function(data)
  local savedBoard = nil
  if data then
    minetest.chat_send_all("Found existing game board.")
    savedBoard = data
  else
    minetest.chat_send_all("Board init as default")
    savedBoard = loadBoard()
  end
  catan_local.board = savedBoard
  board = catan_local.board
end

boardSetup.getBoard = function()
  return board
end
