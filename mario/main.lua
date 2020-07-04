push = require 'push'


virtualWidth = 432
virtualHeight = 243


windowWidth, windowHeight = love.graphics.getDimensions()
 


function love.load()
    
    mov=4
    x=0
    y=0
    lx=3
    ly=0
    marioSentido=1
    movimientoMario=239
    img = love.graphics.newImage("mario.png")
    img:setFilter('nearest', 'nearest')
    mario = {}
    for i=1,3 do 
      mario[i]=love.graphics.newQuad(movimientoMario, 52, 16, 32, img:getDimensions())
      movimientoMario = movimientoMario + 30
    end
    mario[4]=love.graphics.newQuad(209, 52, 16, 32, img:getDimensions())
   --marioIMG =  love.graphics.newQuad(movimientoMario, 52, 28, 36, img:getDimensions())
    
    imgL = love.graphics.newImage("luigi.png")
    luigiIMG = love.graphics.newQuad(208, 50,28,38, imgL:getDimensions())
    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
      fullscreen = false,
      resizable = true
    })
  end
 
 
  




function love.draw()
      
      push:apply('start')

      
      love.graphics.draw(img,mario[mov],x,y,0,marioSentido,1)
    
  
      --love.graphics.draw(imgL,luigiIMG,lx,ly)
  
      
      push:apply('end')
  
  
  
end


function movimiento()
  mov= math.fmod(mov,4) + 1
end


function love.update(dt)
 (require "lurker").update(dt)
 
 if(love.keyboard.isDown('right'))then
   x=x+100 * dt
   marioSentido = 1
   movimiento()
 end
 if love.keyboard.isDown('left') then
   x=x-100 * dt
   marioSentido = -1
   movimiento()
 end
 if love.keyboard.isDown('up')then
        y= y-10
 end
 gravedad()



end
function love.keyreleased(key)
  if key=='right' or key == 'left'then
    mov=4
  end
end
function love.keypressed(key)
 if(key == 'r')then
     love.load()
 end

end



function gravedad()
    y= math.min(y+2,virtualHeight/2)
    ly=math.min(ly+2,virtualHeight/2)

 
end

