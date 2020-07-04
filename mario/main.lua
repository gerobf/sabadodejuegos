push = require 'push'

virtualWidth = 432
virtualHeight = 243

windowWidth, windowHeight = love.graphics.getDimensions()
 


function love.load()
    player1 = {
      x = 0,
      y = 0,
      direccion = 1,
      sprites = {},
      img = nil,
      i= 4
    }
  
    loadMario()  
    --imgL = love.graphics.newImage("assets/luigi.png")
    --luigiIMG = love.graphics.newQuad(208, 50,28,38, imgL:getDimensions())
    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
      fullscreen = false,
      resizable = true
    })
  end

function love.draw()      
      push:apply('start')
      love.graphics.draw(player1.img,
        player1.sprites[player1.i],
        player1.x,
        player1.y,
        0,
        player1.direccion,
        1)    
      push:apply('end')
end


function loadMario()
  local step=239
  player1.img = love.graphics.newImage("assets/mario.png")
  player1.img:setFilter('nearest', 'nearest')
  
  for i=1,3 do 
    player1.sprites[i]=love.graphics.newQuad(step, 52, 16, 32, player1.img:getDimensions())
    step = step + 30
  end
  player1.sprites[4]=love.graphics.newQuad(209, 52, 16, 32, player1.img:getDimensions())  
end

function movimiento()
  player1.i= math.fmod(player1.i,4) + 1
end


function love.update(dt)
 (require "lurker").update(dt)
 
 if(love.keyboard.isDown('right'))then
   player1.x=player1.x+100 * dt
   player1.direccion = 1
   movimiento()
 end
 if love.keyboard.isDown('left') then
   player1.x=player1.x-100 * dt
   player1.direccion = -1
   movimiento()
 end
 if love.keyboard.isDown('up')then
        player1.y= player1.y-10
 end
 gravedad()
end
function love.keyreleased(key)
  if key=='right' or key == 'left'then
    player1.i=4
  end
end
function love.keypressed(key)
 if(key == 'r')then
     love.load()
 end

end



function gravedad()
    player1.y= math.min(player1.y+2,virtualHeight/2)
end

