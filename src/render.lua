local render = classic:extend()

local cameraHeight = 0.5
local backgroundColor = {0.7, 0.8, 0.9}

local phi = 0
local startPoint = {x = 0, y = 0}
local rotationSpeed = 0.5
local moveSpeed = 15
local GAME_WIDTH = 480
local GAME_HEIGHT = 320
local SCALE_X = 2
local SCALE_Y = 2
local lg = love.graphics
local lk = love.keyboard

function render:new(terrain)
    lg.setBackgroundColor(backgroundColor)
    self.render = lg.newShader('shaders/render.glsl')
    self.render:send('heightMap', terrain.heightMap)
    self.render:send('colorMap', terrain.colorMap)
    self.canvas = lg.newCanvas(GAME_WIDTH, GAME_HEIGHT)
end


function render:draw()
    lg.setCanvas(self.canvas)
    lg.clear()
    lg.setShader(self.render)
    lg.setColor(1, 1, 1)
    lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())
    lg.setShader()
    lg.setCanvas()
    lg.setColor(1, 1, 1, 1)
    lg.setBlendMode('alpha', 'premultiplied')
    lg.draw(self.canvas, 0, 0, 0, SCALE_X, SCALE_Y)
    lg.setBlendMode('alpha')
    lg.setColor(1, 1, 1)
    lg.print(love.timer.getFPS() .. ' FPS')
end


function render:update(dt)
    if lk.isDown('a') then
        phi = phi + dt * rotationSpeed
      elseif lk.isDown('d') then
        phi = phi - dt * rotationSpeed
      end
    
      if lk.isDown('w') then
        startPoint = {
          x = startPoint.x + (math.sin(phi + math.pi * 3 / 4) + math.cos(phi + math.pi * 3 / 4)) * dt * moveSpeed,
          y = startPoint.y + (math.cos(phi + math.pi * 3 / 4) - math.sin(phi + math.pi * 3 / 4)) * dt * moveSpeed
        }
      elseif lk.isDown('s') then
        startPoint = {
          x = startPoint.x - (math.sin(phi + math.pi * 3 / 4) + math.cos(phi + math.pi * 3 / 4)) * dt * moveSpeed,
          y = startPoint.y - (math.cos(phi + math.pi * 3 / 4) - math.sin(phi + math.pi * 3 / 4)) * dt * moveSpeed
        }
      end
    
      if lk.isDown('q') then
        cameraHeight = cameraHeight - dt * rotationSpeed
      elseif lk.isDown('e') then
        cameraHeight = cameraHeight + dt * rotationSpeed
      end
    
      self.render:send('phi', phi)
      self.render:send('player', {math.floor(startPoint.x +0.5), math.floor(startPoint.y+0.5), cameraHeight})
end


return render