-- muids.lua
-- ADVENTURE GAME LIBRARY
-- Version 1.4.2
-- Written by Dawit Thepchatree in 2022 for Game Development at Mahidol
--     University International Demonstration School (MUIDS).
-- This work is licensed under a Creative Commons Attribution 4.0 International
--     License. CC-BY
-- Requires: json.lua (by rxi)

-------------------------------------------------------------------------------
-- LIBRARY SETUP
-------------------------------------------------------------------------------

json = require("json")

-- Library Setup
local muids = {}
muids.debugList = {}

-------------------------------------------------------------------------------
-- DEBUGGING SYSTEM
-------------------------------------------------------------------------------

-- Example: muids.addLog("Test 1")
-- Example: muids.addLog("Score: " .. score)
-- If error, try: muids.addLog(tostring(score))
function muids.addLog(text)
    muids.debugList[#muids.debugList + 1] = text
    if #muids.debugList > 20 then
      table.remove(muids.debugList, 1)
    end
end

-- Same as addLog(), but only if new text is different from previous text
-- Example: muids.updateLog("Test 1")
function muids.updateLog(text)
    local lastText = muids.debugList[#muids.debugList]
    if lastText ~= text then
        muids.addLog(text)
    end
end

function muids.drawLog()
    love.graphics.setColor(1, 1, 1, 1)
    for index = 1, #muids.debugList do
        local debugText = muids.debugList[index]
        love.graphics.print(debugText, 0, 0 + (index-1)*20)
    end
end

-------------------------------------------------------------------------------
-- SAVE LOAD SYSTEM
-------------------------------------------------------------------------------

-- Example: muids.saveData("saveFile.txt", dataObject)
function muids.saveData(filename, dataObject)
    local dataString = json.encode(dataObject)
    love.filesystem.write(filename, dataString)
end

-- Example: dataObject = muids.loadData("saveFile.txt")
function muids.loadData(filename)
    if filename == nil then
        return nil
    elseif love.filesystem.getInfo(filename) == nil then
        return nil
    else
        local dataString = love.filesystem.read(filename)
        local dataObject = json.decode(dataString)
        return dataObject
    end
end

-- Use in: love.load()
-- Example: muids.showData(dataObject)
function muids.showData(dataObject)
    muids.addLog("showing data")
    for key, value in pairs(dataObject) do
        muids.addLog(key .. " " .. value)
    end
end

-- Example: muids.deleteData("saveFile.txt")
function muids.deleteData(filename)
    love.filesystem.remove(filename)
end

-------------------------------------------------------------------------------
-- BASIC OBJECT TEMPLATES
-------------------------------------------------------------------------------

-- Template for Text Object
-- To use, font files (.ttf) must be added to project folder
-- Example: text = muids.newTextObject("Game Over", "impact.ttf", 48)
function muids.newTextObject(text, fontName, fontSize)
    local object = {}
    object.text = text
    object.font = love.graphics.newFont(fontName, fontSize)
    object.x = 0
    object.y = 0
    object.rotation = 0
    object.xScale = 1
    object.yScale = 1
    object.width = object.font:getWidth(text)
    object.height = object.font:getHeight()
    object.xOrigin = object.width / 2
    object.yOrigin = object.height / 2
    object.red = 1
    object.green = 1
    object.blue = 1
    object.alpha = 1
    return object
end

-- Template for New Object
-- Example: object = muids.newObject("cat.png")
function muids.newObject(name)
    local object = {}
    if name then
        object.image = love.graphics.newImage(name)
        object.width = object.image:getWidth()
        object.height = object.image:getHeight()
        object.xOrigin = object.width/2
        object.yOrigin = object.height/2
    end
    object.x = 0
    object.y = 0
    object.rotation = 0
    object.xScale = 1
    object.yScale = 1
    object.alpha = 1
    object.red = 1
    object.green = 1
    object.blue = 1

    return object
end

-- Template for New Object with Animation
-- Example: object = muids.newAnimation("cat", ".png", 12)
-- To change image, use: object.currentFrame
function muids.newAnimation(baseName, extension, frames)
    -- load object with first image
    local name = baseName .. 1 .. extension
    local object = muids.newObject(name)

    -- add all images into list
    object.imageList = {}
    for index = 1, frames do
        name = baseName .. index .. extension
        object.imageList[index] = love.graphics.newImage(name)
    end

    -- add properties to keep track of frames
    object.currentFrame = 1
    object.totalFrames = frames

    return object
end

-- Clear Objects from List
function muids.clearList(list)
    for index = #list, 1, -1 do
        table.remove(list, index)
    end
end

function muids.drawObject(obj)
    love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
    love.graphics.draw(obj.image, obj.x, obj.y, obj.rotation, obj.xScale, obj.yScale, obj.xOrigin, obj.yOrigin)
end

function muids.drawAnimation(obj)
    love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
    love.graphics.draw(obj.imageList[obj.currentFrame], obj.x, obj.y, obj.rotation, obj.xScale, obj.yScale, obj.xOrigin, obj.yOrigin)
end

function muids.drawTextObject(obj)
    love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
    love.graphics.print(obj.text, obj.font, obj.x, obj.y, obj.rotation, obj.xScale, obj.yScale, obj.xOrigin, obj.yOrigin)
end

function muids.drawObjectList(list)
    for index = 1, #list do
        local object = list[index]
        muids.drawObject(object)
    end
end

function muids.drawAnimationList(list)
    for index = 1, #list do
        local object = list[index]
        muids.drawAnimation(object)
    end
end

function muids.drawTextList(list)
    for index = 1, #list do
        local object = list[index]
        muids.drawTextObject(object)
    end
end

-------------------------------------------------------------------------------
-- ADVENTURE OBJECT TEMPLATES
-------------------------------------------------------------------------------

-- Template for Grouping Animations Into One Object
-- Example: animationDict = {}
--          animationDict.down = muids.newAnimation("HeroD", ".png", 4)
--          animationDict.left = muids.newAnimation("HeroL", ".png", 4)
--          animationDict.right = muids.newAnimation("HeroR", ".png", 4)
--          animationDict.up = muids.newAnimation("HeroU", ".png", 4)
--          hero = muids.newCharacter(animationDict)
-- To change direction: hero.direction = "right"
function muids.newCharacter(animationDict)
    -- get direction names
    local directionNames = {}
    for key, value in pairs(animationDict) do
        directionNames[#directionNames + 1] = key
    end

    -- get first image from image list of an animation object
    local firstDirection = directionNames[1]
    local firstAnimation = animationDict[firstDirection]
    local firstImage = firstAnimation.imageList[1]

    -- create new object using first image
    local object = muids.newObject()
    object.width = firstImage:getWidth()
    object.height = firstImage:getHeight()
    object.xOrigin = object.width/2
    object.yOrigin = object.height/2

    -- set default direction and attach animation dictionary
    object.direction = directionNames[1]
    object.animationDict = animationDict
    object.currentFrame = 1
    object.totalFrames = firstAnimation.totalFrames

    return object
end

function muids.drawCharacter(obj)
    -- get animation for current direction
    local animation = obj.animationDict[obj.direction]
    local currentFrame = math.floor(obj.currentFrame)

    -- draw image
    love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
    love.graphics.draw(animation.imageList[currentFrame], obj.x, obj.y, obj.rotation, obj.xScale, obj.yScale, obj.xOrigin, obj.yOrigin)
end

function muids.drawCharacterList(list)
    for index = 1, #list do
        local object = list[index]
        muids.drawCharacter(object)
    end
end

-- Calculate & Update Current Frame for Character Animation
-- Duration is how many screen frames it takes to complete 1 animation cycle
-- Example: muids.animateCharacter(hero, 30)
function muids.animateCharacter(obj, duration)
    -- calculate frame progression
    local animation = obj.animationDict[obj.direction]
    local increment = animation.totalFrames / duration

    -- progress frames (math.floor() is applied when drawing)
    if obj.currentFrame < (animation.totalFrames + 1) - increment then
        obj.currentFrame = obj.currentFrame + increment
    else
        obj.currentFrame = 1
    end
end

-- Character Direction
-- Example: direction = muids.faceObject(enemy, hero)
function muids.faceObject(character, object)
    local xDistance = object.x - character.x
    local yDistance = object.y - character.y
    if math.abs(xDistance) > math.abs(yDistance) then
        if xDistance > 0 then
            return "right"
        else
            return "left"
        end
    else
        if yDistance > 0 then
            return "down"
        else
            return "up"
        end
    end
end

-- Example: object = muids.newBox(32, 32)
function muids.newBox(width, height)
    local box = muids.newObject()
    box.width = width
    box.height = height
    box.xOrigin = 0
    box.yOrigin = 0
    return box
end

function muids.drawBox(obj)
    love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
    love.graphics.rectangle("fill", obj.x - obj.width*obj.xScale/2, obj.y - obj.height*obj.yScale/2, obj.width*obj.xScale, obj.height*obj.yScale)
end

-- Example: dialog = muids.newDialog("avenir.otf", 24)
function muids.newDialog(fontName, fontSize)
    -- get window dimensions
    local width, height, flags = love.window.getMode()

    -- create dialog object
    local object = muids.newTextObject("", fontName, fontSize)
    object.delay = 0 -- this is for stopping repeated key press
    object.alpha = 0
    object.script = {}
    object.page = 1
    object.x = width/2
    object.y = height - fontSize*4
    object.textDelay = 1 -- adjust this to change text speed
    object.textCountdown = 0
    object.textLimit = 1

    -- create text box background
    local box = muids.newBox(width, fontSize*5 + fontSize/2)
    box.red = 0
    box.green = 0
    box.blue = 0
    box.alpha = 0
    object.box = box

    return object
end

-- Example: if dialog.alpha > 0 then
--              muids.updateDialog(dialog, "space")
--              return
--          end
function muids.updateDialog(object, keyButton)
    -- skip everything, if dialog object is hidden
    if object.alpha > 0 then
        -- reposition text box
        object.box.x = object.x
        object.box.y = object.y + object.height
        object.box.alpha = 0.75

        -- scrolling text
        if object.textLimit < string.len(object.text) then
            if object.textCountdown <= 0 then
                object.textLimit = object.textLimit + 1
                object.textCountdown = object.textDelay
            else
                object.textCountdown = object.textCountdown - 1
            end
        end

        -- check for key press
        if love.keyboard.isDown(keyButton) == true
        and object.delay <= 0 then
            -- delay is for preventing: repeating key press
            object.delay = 15

            -- reset scrolling text
            object.textLimit = 1
            object.textCountdown = 0

            -- go to next page (if exists)
            object.page = object.page + 1
            if object.page <= #object.script then
                -- set text to next page
                object.text = object.script[object.page]

                -- center-align text
                object.width = object.font:getWidth(object.text)
                object.xOrigin = object.width/2
            else
                -- no next page, hide dialog
                object.alpha = 0
                object.box.alpha = 0
            end
        elseif object.delay > 0 then
            object.delay = object.delay - 1
        end
    end
end

-- Example: muids.startDialog(dialog, npc.script)
function muids.startDialog(object, script)
    -- change dialog list
    object.script = script

    -- set starting text
    object.page = 1
    object.text = object.script[1]
    object.textLimit = 1

    -- center-align text
    object.width = object.font:getWidth(object.text)
    object.xOrigin = object.width/2

    -- show dialog
    object.alpha = 1
end

function muids.drawDialog(obj)
    -- draw black background
    muids.drawBox(obj.box)

    -- draw white border
    if obj.box.alpha > 0 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", obj.box.x - obj.box.width*obj.box.xScale/2 + 1, obj.box.y - obj.box.height*obj.box.yScale/2 + 1, obj.box.width*obj.box.xScale - 2, obj.box.height*obj.box.yScale - 2)
    end

    -- draw text
    local text = string.sub(obj.text, 1, obj.textLimit) -- get substring for scrolling text
    love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
    love.graphics.print(text, obj.font, obj.x, obj.y, obj.rotation, obj.xScale, obj.yScale, obj.xOrigin, obj.yOrigin)
end

-------------------------------------------------------------------------------
-- COLLISION SYSTEM
-------------------------------------------------------------------------------

-- Collision Function
-- Example: if muids.checkCollision(cat, dog) == true then
function muids.checkCollision(object1, object2)
    -- find distance between object1 & object2
    local xDistance = object1.x - object2.x
    local yDistance = object1.y - object2.y
    local distance = math.sqrt(xDistance^2 + yDistance^2)

    -- calculate radius1 as average of object1's width & height
    local width1 = object1.width * object1.xScale / 2
    local height1 = object1.height * object1.yScale / 2
    local radius1 = (width1 + height1) / 2

    -- calculate radius2 as average of object2's width & height
    local width2 = object2.width * object2.xScale / 2
    local height2 = object2.height * object2.yScale / 2
    local radius2 = (width2 + height2) / 2

    -- check collision
    if distance < radius1 + radius2 then
        return true
    else
        return false
    end
end

-- Advanced: List Collision Function with Handler
-- Example: function handler(index, index2)
--              table.remove(catList, index)
--              table.remove(dogList, index2)
--          end
--          muids.listCollision(catList, dogList, handler)
-- Example: function handler(index, index2)
--              cat = catList[index]
--              dog = dogList[index2]
--          end
--          muids.listCollision(catList, dogList, handler)
function muids.listCollision(list1, list2, handler)
    for index = #list1, 1, -1 do
        local object1 = list1[index]

        for index2 = #list2, 1, -1 do
            local object2 = list2[index2]

            if muids.checkCollision(object1, object2) == true then
                handler(index, index2)
                break
            end
        end
    end
end

-------------------------------------------------------------------------------
-- OTHER STUFF
-------------------------------------------------------------------------------

muids.frameTime = 0

-- Set Frame Cap
-- Example: if muids.frameCap(dt, 60) == true then
--              return
--          end
function muids.frameCap(dt, frameRate)
    muids.frameTime = muids.frameTime + dt
    if muids.frameTime < 1/frameRate then
        return true
    else
        muids.frameTime = dt
        return false
    end
end

-- Play Sound From List
function muids.playSound(name, list)
    -- play old sound if available
    for index = 1, #list do
        local sound = list[index]
        if sound:isPlaying() == false then
            love.audio.play(sound)
            return
        end
    end

    -- if none available, add new sound to list & play it
    local newSound = love.audio.newSource(name, "static")
    love.audio.play(newSound)
    list[#list + 1] = newSound
end

-------------------------------------------------------------------------------
-- TILE MAPPING TOOLS
-------------------------------------------------------------------------------
-- Simple Method:
-- 1. Map & character images -> project folder
-- 2. Matrix file
-- 3. newObject() -> map
-- 4. loadMatrix()
-- 5. newCharacter() -> hero
-- 6. Hero controls with mapCollision()
-- 7. drawCharacter() & drawObject()
-- 8. Run & test with drawGrid()

-- Scalable Method:
-- 1. Map & character images -> project folder
-- 2. Matrix file for world map
-- 3. newMap() -> map
-- 4. newCharacter() -> hero
-- 5. Hero controls with mapCollision()
-- 6. autoLoadMap()
-- 7. drawCharacter() & drawObject()
-- 8. Run & test
-- 9. editGrid() & drawGrid()
-- 10. Save button -> muids.saveGrid(muids.gridName)
-- 11. Mouse -> Paint collision blocks & save
-- 12. Repeat for every map screen
-- 13. Save directory -> Move (not copy) grid files to project folder
-- 14. Run game to test collisions
-- 15. Remove editGrid() & drawGrid()

muids.tileSize = 16
muids.collisionBlocks = {}
muids.hoverTile = nil
muids.worldTile = nil
muids.worldMatrix = nil
muids.gridDict = {}

-- Template for New Map
-- Example: map = muids.newMap("Map 1.png", 32)
function muids.newMap(mapName, tileSize)
    local gridName = muids._constructGridName(mapName)
    local map = muids._loadMap(mapName, gridName, tileSize)
    muids._findMap(map, nil)
    return map
end

-- Optional: Manually Pair Map File with Grid File
-- By default, a grid file is saved/loaded using a similar filename.
--      This overrides that functionality.
-- Example: muids.setGrid("Map 1.png", "Grid 1.txt")
function muids.setGrid(mapName, gridName)
    muids.gridDict[mapName] = gridName
end

function muids._loadMap(mapName, gridName, tileSize)
    -- load collision blocks (if exists)
    muids.loadGrid(gridName, tileSize)

    -- get window dimensions
    local width, height, flags = love.window.getMode()

    -- create new map object
    local map = muids.newObject(mapName)
    map.x = width/2
    map.y = height/2
    map.gridName = gridName
    map.mapName = mapName

    -- pair up map and grid
    muids.setGrid(mapName, gridName)

    return map
end

function muids._constructGridName(mapName)
    local gridName = mapName

    -- remove image type extension
    gridName = string.gsub(gridName, ".jpg", "")
    gridName = string.gsub(gridName, ".jpeg", "")
    gridName = string.gsub(gridName, ".png", "")
    gridName = string.gsub(gridName, ".bmp", "")

    -- append text file extension
    gridName = gridName .. ".txt"

    return gridName
end

function muids._findMap(mapObject, matrix)
    -- this function requires worldTile from muids.autoLoadMap()
    if muids.worldTile == nil then
        return
    end

    if matrix then -- use matrix as world matrix
        muids.worldMatrix = matrix
    elseif muids.worldMatrix then -- use world matrix
        matrix = muids.worldMatrix
    else -- no matrix found, skip this function
        return
    end

    -- find map in matrix
    local mapFound = false
    local startMapName = mapObject.mapName
    for i = 1, #matrix do
        local row = matrix[i]
        for j = 1, #row do
            local name = matrix[i][j]
            if startMapName == name then
                -- map found: setting world XY to here
                mapFound = true
                muids.worldTile.x = j
                muids.worldTile.y = i
                break
            end
        end
    end

    -- no map found in matrix, using defaults (top-left)
    if mapFound == false then
        muids.worldTile.x = 1
        muids.worldTile.y = 1
    end
end

-- Automatically Teleport Character to New Map
-- 1. Load new map according to world map matrix (by replacing image in mapObject)
-- 2. Teleport character to different side of the screen
-- Example: muids.autoLoadMap(maps.world, hero, map)
function muids.autoLoadMap(matrix, character, mapObject)
    -- create default world tile (if needed)
    if muids.worldTile == nil then
        muids.worldTile = {}
        muids._findMap(mapObject, matrix)
    end

    -- preserve previous location
    local oldWorldTile = {}
    oldWorldTile.x = muids.worldTile.x
    oldWorldTile.y = muids.worldTile.y

    -- get window dimensions
    local windowWidth, windowHeight, flags = love.window.getMode()

    -- check window border collision & attempt to teleport to new worldTile location
    local teleportDirection = "none"
    if character.x - character.width*character.xScale/2 <= 0 then
        teleportDirection = "left"
        muids.worldTile.x = muids.worldTile.x - 1
    elseif character.x + character.width*character.xScale/2 >= windowWidth then
        teleportDirection = "right"
        muids.worldTile.x = muids.worldTile.x + 1
    elseif character.y - character.height*character.yScale/2 <= 0 then
        teleportDirection = "top"
        muids.worldTile.y = muids.worldTile.y - 1
    elseif character.y + character.height*character.yScale/2 >= windowHeight then
        teleportDirection = "bottom"
        muids.worldTile.y = muids.worldTile.y + 1
    else
        -- skip the rest if no border collision found
        return
    end

    -- prevent worldTile location from going outside matrix bounds
    if muids.worldTile.x < 1 then
        muids.worldTile.x = 1
        teleportDirection = "none"
    end
    if muids.worldTile.x > #matrix[1] then
        muids.worldTile.x = #matrix[1]
        teleportDirection = "none"
    end
    if muids.worldTile.y < 1 then
        muids.worldTile.y = 1
        teleportDirection = "none"
    end
    if muids.worldTile.y > #matrix then
        muids.worldTile.y = #matrix
        teleportDirection = "none"
    end

    -- find map name from matrix
    local mapName = matrix[muids.worldTile.y][muids.worldTile.x]

    if mapName == 0 then
        -- revert worldTile change if no new map is found
        muids.updateLog("Autoload Map: Out of bounds")
        muids.worldTile = oldWorldTile
    else
        -- success: change to new map
        mapObject.image = love.graphics.newImage(mapName)
        mapObject.mapName = mapName

        -- load collision blocks (if possible)
        local gridName = muids.gridDict[mapName]
        if gridName then
            mapObject.gridName = gridName -- from muids.setGrid()
        else
            -- try similar filename as map, if gridName is nil
            gridName = muids._constructGridName(mapName)
            mapObject.gridName = gridName
        end
        muids.loadGrid(mapObject.gridName, muids.tileSize)

        -- teleport character if a new map is loaded
        if teleportDirection == "left" then
            -- teleport from left to right
            character.x = windowWidth - character.width*character.xScale
        elseif teleportDirection == "right" then
            -- teleport from right to left
            character.x = character.width*character.xScale
        elseif teleportDirection == "top" then
            -- teleport from top to bottom
            character.y = windowHeight - character.height*character.yScale
        elseif teleportDirection == "bottom" then
            -- teleport from bottom to top
            character.y = character.height*character.yScale
        end
    end
end

-- Load Old-style Collision Matrix (instead of saving/loading the grid)
-- Example: muids.loadMatrix(maps.forest, 32)
function muids.loadMatrix(matrix, tileSize)
    local size = tileSize
    muids.tileSize = tileSize

    muids.collisionBlocks = {}

    for listIndex = 1, #matrix do
        local list = matrix[listIndex]
        for itemIndex = 1, #list do
            local item = list[itemIndex]
            if item > 0 then
                local newBlock = {}
                newBlock.x = (itemIndex-1)*size
                newBlock.y = (listIndex-1)*size
                newBlock.width = size
                newBlock.height = size
                muids.collisionBlocks[#muids.collisionBlocks + 1] = newBlock
            end
        end
    end
end

-- Manually Load Collision Blocks
-- Example: muids.loadGrid("map1.txt", 32)
function muids.loadGrid(filename, tileSize)
    local dataObject = muids.loadData(filename)
    if dataObject then
        muids.updateLog("Collision map found: " .. tostring(filename))
        muids.collisionBlocks = dataObject.collisionBlocks
    else
        muids.updateLog("Collision map not found: " .. tostring(filename))
        muids.collisionBlocks = {}
    end
    muids.tileSize = tileSize
end

-- Enable Collision Block Creation & Deletion (with Mouse)
-- Use in: love.update()
function muids.editGrid()
    local size = muids.tileSize

    -- get window dimensions
    local width, height, flags = love.window.getMode()

    -- calculate numbers of lines
    local columns = math.floor(width / size)
    local rows = math.floor(height / size)

    -- find mouse location
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    -- use box collision to find mouse-hover tile
    local tileFound = false
    for i = 0, columns do
        for j = 0, rows do
            if mouseX > i*size
            and mouseX < (i+1)*size
            and mouseY > j*size
            and mouseY < (j+1)*size
            and tileFound == false then
                muids.hoverTile = {}
                muids.hoverTile.x = i*size
                muids.hoverTile.y = j*size
                tileFound = true
            end
        end
    end

    -- Add/Remove Collision Block with Left/Right Mouse Click
    if muids.hoverTile then
        local blockFound = false

        -- Show Tile Location
        local shownX = muids.hoverTile.x + size/2
        local shownY = muids.hoverTile.y + size/2
        muids.updateLog("Tile X:" .. shownX .. " Y:" .. shownY)

        -- Right Mouse Click: remove existing block from list
        for index = #muids.collisionBlocks, 1, -1 do
            local block = muids.collisionBlocks[index]

            if block.x == muids.hoverTile.x
            and block.y == muids.hoverTile.y then
                if love.mouse.isDown(2) == true then
                    table.remove(muids.collisionBlocks, index)
                end
                blockFound = true
            end
        end

        -- Left Mouse Click: add new block to list
        if blockFound == false and love.mouse.isDown(1) == true then
            local newBlock = {}
            newBlock.x = muids.hoverTile.x
            newBlock.y = muids.hoverTile.y
            newBlock.width = size
            newBlock.height = size
            muids.collisionBlocks[#muids.collisionBlocks + 1] = newBlock
        end
    end
end

-- Save Collision Blocks as File
-- Example: muids.saveGrid("map1.txt")
-- Important: This saved file must be copied and added to your game folder.
--            Look for it in Love's save folder on your computer.
--            On Windows: C:\Users\user\AppData\Roaming\LOVE
--            On Mac:     Finder -> Go -> /Users/user/Library/Application Support/LOVE/
--            To test, remove files in the save folder.
function muids.saveGrid(filename)
    local dataObject = {}
    dataObject.collisionBlocks = muids.collisionBlocks
    muids.saveData(filename, dataObject)
    muids.updateLog("Collision map saved: " .. filename)
end

function muids.drawGrid()
    local size = muids.tileSize

    -- white color
    love.graphics.setColor(1,1,1,1)

    -- get window dimensions
    local width, height, flags = love.window.getMode()

    -- calculate numbers of lines
    local columns = math.floor(width / size)
    local rows = math.floor(height / size)

    -- draw vertical grid lines
    for i = 1, columns do
        love.graphics.line(i*size, 0, i*size, height)
    end

    -- draw horizontal grid lines
    for i = 1, rows do
        love.graphics.line(0, i*size, width, i*size)
    end

    -- draw mouse-hover tile (white)
    if muids.hoverTile then
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.rectangle("fill", muids.hoverTile.x, muids.hoverTile.y, size, size)
    end

    -- draw collision blocks (red)
    for index = 1, #muids.collisionBlocks do
        local block = muids.collisionBlocks[index]
        love.graphics.setColor(1,0,0,0.5)
        love.graphics.rectangle("fill", block.x, block.y, size, size)
    end
end

-- Check Object With Collision Blocks
-- Example: if muids.mapCollision(hero) == true then
function muids.mapCollision(obj)
    local collisionFound = false

    for index = 1, #muids.collisionBlocks do
        local block = muids.collisionBlocks[index]

        -- collision adjusted to be less than tile size
        if obj.x + obj.width*obj.xScale/4 > block.x
        and obj.x - obj.width*obj.xScale/4 < block.x + block.width
        and obj.y + obj.height*obj.yScale/2 > block.y
        and obj.y < block.y + block.height
        then
            collisionFound = true
            break
        end
    end

    return collisionFound
end

-------------------------------------------------------------------------------
-- LIBRARY RETURN
-------------------------------------------------------------------------------
return muids