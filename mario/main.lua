push = require 'push'

virtualWidth = 432
virtualHeight = 243

windowWidth, windowHeight = love.graphics.getDimensions()
 


function love.load()
    player1 = {
      x = 0,
      y = 0,
      direccion = 1,
      estados = {
        standing = {},
        jumping = {},
        walking = {},
        ducking = {}
      },
      i = 1,
      estado = 'standing', 
      img = nil,
      speed = 100
    }
    loadMario()  

    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
      fullscreen = false,
      resizable = true
    })
  end

function love.draw()      
      push:apply('start')      
      love.graphics.draw(player1.img,
        player1.estados[player1.estado][player1.i],
        player1.x,
        player1.y,
        0,
        player1.direccion,
        1, 
        0, 
        0)    

      push:apply('end')
end


function loadMario()
  local step=239
  player1.img = love.graphics.newImage("assets/mario.png")
  player1.img:setFilter('nearest', 'nearest')
  
  for i=1,3 do 
    player1.estados.walking[i]=love.graphics.newQuad(step, 52, 16, 32, player1.img:getDimensions())
    step = step + 30
  end
  player1.estados.standing[1] = love.graphics.newQuad(209, 52, 16, 32, player1.img:getDimensions())  

  player1.estados.ducking[1] = love.graphics.newQuad(389, 52, 16, 32, player1.img:getDimensions()) 
end

function movimiento()
  player1.i = math.fmod(player1.i, #player1.estados[player1.estado]) + 1  
end


function love.update(dt)
 (require "lurker").update(dt)
 
 if  player1.estado ~= 'ducking' then
   if(love.keyboard.isDown('right'))then
     player1.x=player1.x+player1.speed * dt
     player1.direccion = 1
     player1.estado = 'walking'
     movimiento()
   end
   if love.keyboard.isDown('left') then
     player1.x=player1.x-player1.speed * dt
     player1.direccion = -1
     player1.estado = 'walking'
     movimiento()
   end
 end

 if love.keyboard.isDown('up')then
        player1.y= player1.y-10
 end
 gravedad()
 if love.keyboard.isDown('down') then
  player1.estado = 'ducking'
  player1.y = player1.y + 4 
 end
  
end

function love.keyreleased(key)
  if key=='right' or key == 'left'then
    player1.estado = "standing"
    player1.i = 1
  end
  if key =='down' then
    player1.y = player1.y - 4
    player1.estado = 'standing'
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

