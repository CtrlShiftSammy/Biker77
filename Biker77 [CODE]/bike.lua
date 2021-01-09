bike = Class{}

local g = 10

function bike:init()

    self.image = love.graphics.newImage('bike.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2) + 30

	self.dy=0
end

function bike:collides(box)
   if (self.x + 2) + (self.width - 4) >= box.x and self.x + 2 <= box.x + BOX_WIDTH then
        if (self.y + 2) + (self.height - 4) >= box.y and self.y + 2 <= box.y + BOX_HEIGHT then
            return true
        end
    end

    return false
end

function bike:update(dt)
	if self.y < VIRTUAL_HEIGHT / 2 - (self.height / 2) + 30 then
		self.dy = self.dy + g * dt
	elseif self.y == VIRTUAL_HEIGHT / 2 - (self.height / 2) + 30 then
		self.dy=0
		CurrentJump = 0
	else
		self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2) + 30
	end

	if (CurrentJump <= 1) and (self.y <= VIRTUAL_HEIGHT / 2 - (self.height / 2) + 30) and (love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w')) then
        self.dy = -6
		love.audio.newSource('Jump.wav', 'static'):play()
		CurrentJump = CurrentJump + 1
    end
	self.dy = self.dy + g * dt
	if (self.y >= VIRTUAL_HEIGHT / 2 - (self.height / 2) + 30) then
		if self.dy < 0 then
			self.y = self.y + self.dy
		end

	else
		self.y = self.y + self.dy
	end
end

function bike:render()
    love.graphics.draw(self.image, self.x, self.y)
end
