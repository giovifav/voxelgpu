local terrain = classic:extend()

function terrain:new(size)
    self.map = love.graphics.newImage(love.image.newImageData(size, size))
    self.lights = love.graphics.newShader("shaders/lights.glsl")
    self.generator = love.graphics.newShader("shaders/generator.glsl")
    local biome = love.graphics.newImage("assets/biome.png")
    self.generator:send("biome", biome)
    self.canvas = love.graphics.newCanvas(size,size)
    local density = size / 600
    love.math.setRandomSeed(os.time())
    for i = 1, love.math.random(100), 1 do
        love.math.random()
    end
    local x, y = love.math.random(5000),love.math.random(5000)
    self.heightMap = love.image.newImageData(size, size)
    self.colorMap  = self:generateTerrain(x,y,density)
    local function generateImages(x, y, r, g, b, a)
        self.heightMap:setPixel(x,y,a,a,a,1)
        a = 1
        return r,g,b,a
    end
    self.colorMap:mapPixel(generateImages)
    self.colorMap = love.graphics.newImage(self.colorMap)
    self.colorMap:setWrap('repeat', 'repeat')
    self.colorMap:setFilter('nearest', 'nearest')
    self.heightMap = love.graphics.newImage(self.heightMap)
    self.heightMap:setWrap('repeat', 'repeat')
    self.heightMap:setFilter('nearest', 'nearest')
end

local function shaderRender(img, shader)
    local w,h = img:getDimensions()
    local canvas = love.graphics.newCanvas(w,h)
	canvas:renderTo(function()
		love.graphics.clear(1,0,0,1)
		love.graphics.setShader(shader)
			love.graphics.setBlendMode("replace", "premultiplied")
			love.graphics.draw(img,0,0)
		love.graphics.setShader()
	end)
	love.graphics.setBlendMode("alpha")
	return canvas:newImageData()
end

function terrain:generateTerrain(x,y,dens)
	self.generator:send("dens", dens or 1)
	self.generator:send("off", {x,y})
	local data = shaderRender(self.canvas, self.generator)
	self.lights:send("sun", {0.5, 0.0, 0.5})
	self.lights:send("preci", 0.01)
	local data = shaderRender(love.graphics.newImage(data), self.lights)
	return data
end

function terrain:draw()
    love.graphics.draw(self.colorMap)
end

return terrain