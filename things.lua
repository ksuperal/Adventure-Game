local things = {}

things.currentMap = nil
things.enemyList = {}
things.warpList = {}
things.npcList = {}

function things.replace(mapName)
    if things.currentMap == mapName then
        return
    end
    things.currentMap = mapName
    things.replace(map.mapName)
    for index= #things.enemyList,1,-1 do
        table.remove(things.enemyList, index)
    end
    for index= #things.warpList,1,-1 do
        table.remove(things.warpList, index)
    end
    for index= #things.npcList,1,-1 do
        table.remove(things.npcList, index)
    end
    if things.currentMap == "Map1.png"then
        local dict = {}
        dict.up = muids.newAnimation("NpcU",".png",4)
        dict.down = muids.newAnimation("NpcD",".png",4)
        dict.left = muids.newAnimation("NpcL",".png",4)
        dict.right = muids.newAnimation("NpcR",".png",4)

        local npc = muids.newCharacter(dict)
        npc.x = 300
        npc.y = 480
        npc.direction= "left"
        npc.script = {} 
        npc.script[1] = "Oh, Sir please help us.\n There are monster all around the city!"
        npc.script[2] = "Please save all the kids\nand kill those creature."


        things.npcList[#things.npcList +1] = npc
    end
    if things.currentMap == "Map1.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 500
        enemy.y = 200
        enemy.direction= "right"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map1.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 100
        enemy.y = 200
        enemy.direction= "right"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map1.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 200
        enemy.y = 480
        enemy.direction= "right"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map2.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 300
        enemy.y = 250
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map2.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 300
        enemy.y = 130
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map2.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 400
        enemy.y = 330
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map3.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 500
        enemy.y = 250
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map3.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 100
        enemy.y = 250
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map3.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 300
        enemy.y = 330
        enemy.direction= "down"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map4.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 60
        enemy.y = 60
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map4.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 150
        enemy.y = 480
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map4.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 750
        enemy.y = 550
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map5.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 750
        enemy.y = 550
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map5.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 550
        enemy.y = 400
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map5.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 70
        enemy.y = 400
        enemy.direction= "up"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map6.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 300
        enemy.y = 480
        enemy.direction= "right"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map6.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 330
        enemy.y = 280
        enemy.direction= "right"
        things.enemyList[#things.enemyList +1] = enemy

    end
    if things.currentMap == "Map6.png"then
        local dict = {}
        dict.up = muids.newAnimation("EnemyU",".png",4)
        dict.down = muids.newAnimation("EnemyD",".png",4)
        dict.left = muids.newAnimation("EnemyL",".png",4)
        dict.right = muids.newAnimation("EnemyR",".png",4)

        local enemy = muids.newCharacter(dict)
        enemy.x = 500
        enemy.y = 440
        enemy.direction= "down"
        things.enemyList[#things.enemyList +1] = enemy

    end
    
    if things.currentMap == "Map1.png"then
    if chestFound == false then
    local dict = {}
    dict.up = muids.newAnimation("Chest", ".png", 1)
    dict.down = muids.newAnimation("Chest", ".png", 1)
    dict.left = muids.newAnimation("Chest", ".png", 1)
    dict.right = muids.newAnimation("Chest", ".png", 1)

    local npc = muids.newCharacter(dict)
    npc.x = 560
    npc.y = 260
    npc.direction = "down"
    npc.script = {}
    npc.script[1] = "You Amor +20"
    npc.name = "Amor Chest"

    things.npcList[#things.npcList + 1] = npc
    end

end
  if things.currentMap == "Map1.png"then
        local warp = muids.newBox(32,32)
        warp.x = 400
        warp.y = 220
        warp.teleportMap = "Map4.png"
        warp.teleportX = 250
        warp.teleportY = 480

        things.warpList[#things.warpList + 1] = warp
  end
    if things.currentMap == "Map4.png"then
        local warp = muids.newBox(32,32)
        warp.x = 220
        warp.y = 600
        warp.teleportMap = "Map1.png"
        warp.teleportX = 400
        warp.teleportY = 260

        things.warpList[#things.warpList + 1] = warp
    end
end
return things
