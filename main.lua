classic = require("libs.classic")
terrain = require("src.terrain")(4096)
render = require("src.render")(terrain)
function love.load()
   love.graphics.setDefaultFilter('nearest', 'nearest')
end


function love.draw()
    render:draw()
end

function love.update(dt)
    render:update(dt)
end

