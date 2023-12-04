local kanok= {}

function kanok.newObject(imageName)
    local object = {}
  
    object.x = 1
    object.y = 1
    object.rotation = 0
    object.xScale = 1
    object.yScale = 1
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

 function kanok.drawObject(object)
    love.graphics.setColor(object.red, object.green, object.blue, object.alpha)
    love.graphics.draw(object.image, object.x, object.y, object.rotation, object.xScale, object.yScale, object.xOrigin, object.yOrigin)
  end
  
return kanok