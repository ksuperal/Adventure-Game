muids = require("muids")
maps = require("maps")
things = require("things")

function newObject()
    object = {}
    return object
 end
 
 function newObject(imageName)
    object = {}
    object.x = 1
    object.y = 1
    object.rotation = 0
    object.xScale = 0.15
    object.yScale = 0.15
    object.image = love.graphics.newImage(imageName)
    object.width = object.image:getWidth()
    object.height = object.image:getHeight()
    object.xOrigin = object.width / 2
    object.yOrigin =  object.height / 2
    object.red = 1
    object.green = 1
    object.blue = 1
    object.alpha = 1
    object.health = 1
 
    return object
 end

function love.load()
map = muids.newMap("Map1.png", 32)
dialog = muids.newDialog("Yellow Candy.otf", 32)
animationDict ={}
animationDict.down =muids.newAnimation("HeroD",".png",4)
animationDict.left =muids.newAnimation("HeroL",".png",4)
animationDict.right =muids.newAnimation("HeroR",".png",4)
animationDict.up =muids.newAnimation("HeroU",".png",4)

hero = muids.newCharacter(animationDict)
hero.x = 400
hero.y = 365
hero.hp = 3
hero.damageDelay = 0

animationDict ={}
animationDict.down =muids.newAnimation("SwordD",".png",3)
animationDict.left =muids.newAnimation("SwordL",".png",3)
animationDict.right =muids.newAnimation("SwordR",".png",3)
animationDict.up =muids.newAnimation("SwordU",".png",3)

sword = muids.newCharacter(animationDict)
sword.direction ="down"
sword.alpha = 0
sword.delay = 0
chestFound = false
gg = false
end

function love.update(dt)
    muids.editGrid()
    things.replace(map.mapName)
    chestFound = true
    if gg == true then
        return
    end
    if hero.damageDelay > 0 then
        hero.damageDelay = hero.damageDelay -1 
    else
        hero.alpha =1
    end
    if love.keyboard.isDown("space") == true and sword.delay <=0 then
        sword.delay = 30
        sword.alpha = 1
        sword.currentFrame = 1
        sword.x = hero.x
        sword.y = hero.y
        sword.direction = hero.direction
    else
        sword.delay = sword.delay-1
    end
    if sword.alpha > 0 then
        muids.animateCharacter(sword, 15)
        muids.animateCharacter(hero, 15)
        if sword.currentFrame == 1 then
            sword.alpha = 0
        end
    end

    if love.keyboard.isDown("m") == true then
        muids.saveGrid(map.gridName)
    end
    muids.autoLoadMap(maps.world, hero, map)
    if muids.frameCap(dt, 60) == true then
        return
    end
    if dialog.alpha > 0 then

        muids.updateDialog(dialog, "return")
        return
    end
    for index = #things.warpList, 1, -1 do
        warp = things.warpList[index]

        if muids.checkCollision(hero, warp) == true then
            map = muids.newMap(warp.teleportMap, 32)
            hero.x = warp.teleportX
            hero.y = warp.teleportY
        end
    end
 if muids.mapCollision(hero)==false then
    hero.oldX = hero.x
    hero.oldY = hero.y
    if sword.alpha == 0 then
    if love.keyboard.isDown("w") ==true then
        hero.direction="up"
        hero.y = hero.y-2
        muids.animateCharacter(hero, 30)
    elseif love.keyboard.isDown("s") ==true then
        hero.direction="down"
        hero.y = hero.y+2
        muids.animateCharacter(hero, 30)

    elseif love.keyboard.isDown("a") ==true then
        hero.direction="left"
        hero.x = hero.x-2
        muids.animateCharacter(hero, 30)

    elseif love.keyboard.isDown("d") ==true then
        hero.direction="right"
        hero.x = hero.x+2
        muids.animateCharacter(hero, 30)
    end
     end
    else
        hero.x = hero.oldX
        hero.y = hero.oldY
end
    for index = #things.npcList, 1, -1 do
        npc = things.npcList[index]
        muids.animateCharacter(npc, 60)

        if muids.checkCollision(hero, npc)== true then
            if hero.direction =="up" then
                hero.y = hero.y +2
            elseif hero.direction =="down" then
                hero.y = hero.y -2
            elseif hero.direction =="left" then
                hero.x = hero.x +2
            elseif hero.direction =="right" then
                hero.x = hero.x -2               
            end
        
            muids.startDialog(dialog, npc.script)
            if npc.name == "Amor Chest" then
                table.remove(things.npcList, index)
            end
        end
end
   
    
    for index = #things.enemyList, 1, -1 do
         enemy = things.enemyList[index]
        if muids.checkCollision(hero, enemy) == true and hero.damageDelay <=0 then
            hero.hp = hero.hp -1
            hero.damageDelay = 120
            hero.alpha = 0.5
            if hero.hp <= 0 then
                gg = true

            end
        end
        if sword.alpha > 0 and muids.checkCollision(sword, enemy)== true then
           if hero.direction == "left" and enemy.x < hero.x then
            table.remove(things.enemyList, index)
           end
           if hero.direction == "right" and enemy.x > hero.x then
            table.remove(things.enemyList, index)
           end
           if hero.direction == "down" and enemy.y > hero.y then
            table.remove(things.enemyList, index)
           end
           if hero.direction == "up" and enemy.y < hero.y then
            table.remove(things.enemyList, index)
           end
            
        end
         
         muids.animateCharacter(enemy, 60)

         if enemy.currentFrame == 1 then
             enemy.direction = muids.faceObject(enemy, hero)
         end
    
            if enemy.direction =="up" then
                enemy.y = enemy.y -1
            elseif enemy.direction =="down" then
                enemy.y = enemy.y +1
            elseif enemy.direction =="left" then
                enemy.x = enemy.x -1
            elseif enemy.direction =="right" then
                enemy.x = enemy.x +1             
            end
        if muids.mapCollision(enemy) == true then
            if enemy.direction =="up" then
                enemy.y = enemy.y +1
            elseif enemy.direction =="down" then
                enemy.y = enemy.y -1
            elseif enemy.direction =="left" then
                enemy.x = enemy.x +1
            elseif enemy.direction =="right" then
                enemy.x = enemy.x -1             
            end
        end
    end
end

function drawObject(object)
    love.graphics.setColor(object.red, object.green, object.blue, object.alpha)
    love.graphics.draw(object.image, object.x, object.y, object.rotation, object.xScale, object.yScale, object.xOrigin, object.yOrigin)
  end

function love.draw()
    muids.drawObject(map)
    --[[muids.drawGrid()]]--
    muids.drawCharacter(hero)
    muids.drawCharacter(sword)
    muids.drawCharacterList(things.npcList)
    muids.drawCharacterList(things.enemyList)
    muids.drawDialog(dialog)
    if gg == true then
        gameover = newObject("Game Over.png")
        gameover.x = 400
        gameover.y = 300
        gameover.xScale = 1.25
        gameover.yScale = 1.25
        drawObject(gameover)
    end
end