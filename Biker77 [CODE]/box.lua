box
 = Class{}

local BOX_IMAGE = love.graphics.newImage('box.png')
local EXPLODED_BOX_IMAGE = love.graphics.newImage('explodedbox.png')
BOX_HEIGHT=30
BOX_WIDTH=30
local BOX_SCROLL = -90

function box:init()
    self.x = VIRTUAL_WIDTH

    self.y = VIRTUAL_HEIGHT - 93

    self.width = BOX_IMAGE:getWidth()
end

function box:update(dt, v)
    self.x = self.x - 90* v * dt
end
local i = 0
function box:render(exploded)

	if exploded == 'true' then
		love.graphics.draw(BOX_IMAGE, self.x, self.y)
	else
		love.graphics.draw(EXPLODED_BOX_IMAGE, self.x, self.y - 9)
	end

end
