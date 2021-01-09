push = require 'push'
Class= require 'class'
require 'bike'
require 'box'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 225



love.graphics.setColor(255/255, 255/255, 255/255, 255/255)



local background = love.graphics.newImage('Background.png')
local backgroundScroll = 0
local grass = love.graphics.newImage('Grass.png')
local grassScroll = 0
allowRegen = 'true'
local v=1
local BACKGROUND_SCROLL_SPEED = 30*v
local GRASS_SCROLL_SPEED = 90*v
local BACKGROUND_LOOPING_POINT = 814
local GRASS_LOOPING_POINT = 814
local bike = bike()
local boxes = {}
local explodedboxes = {}
local timer = 0
local regen_cool = 0
local count = 0
local score = 0
local actualScore = 0

	function love.load()

		love.graphics.setDefaultFilter('nearest', 'nearest')
		Font = love.graphics.newFont('font.ttf', 24)
		love.graphics.setFont(Font)
		love.window.setTitle('Biker77')
		local music01 = love.audio.newSource('music1.wav', 'static')
		music01:setLooping(true)
		music01:play()


		push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
			vsync = true,
			fullscreen = false,
			resizable = true
		})
			love.keyboard.keysPressed = {}
	end

	function love.resize(w, h)
		push:resize(w, h)
	end

	health = 10


	function love.keypressed(key)

		love.keyboard.keysPressed[key] = true
		if key == 'escape' then
			love.event.quit()
		elseif key == 'a' or key == 'left' then
			if v > 1.5 then
				v=v/2
			elseif v > -1 then
				v= v - 0.2
			else
				v=-1
			end
		elseif key == 'd' or key == 'right' then
			if v<=0 then
			v= v+0.1
			else
			v= v*1.4
			end
		elseif key == 's' or key == 'down' then
			if v^2 > 2.25 then
			v= v/2.5
			elseif v>0 then
				v= v - 0.3
			else
				v= 0
			end
		end

	end
	CurrentJump=0
	function love.keyboard.wasPressed(key)
		if love.keyboard.keysPressed[key] then
			return true
		else
			return false
		end
	end

	function love.update(dt)
		local BACKGROUND_SCROLL_SPEED = 30*v
		local GRASS_SCROLL_SPEED = 90*v
		backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

		grassScroll = (grassScroll + GRASS_SCROLL_SPEED * dt) % GRASS_LOOPING_POINT

		timer = timer + v * dt
		regen_cool = regen_cool + dt

		actualScore = actualScore + math.floor(30 * v * dt)
		if actualScore > score then
			score = actualScore
		end
		math.randomseed(os.time())
		if (timer > math.random(2, 8)) then
			table.insert(boxes, box())
			timer = 0
		end
		if (regen_cool > 0.1) then
			explodedboxes={}
			count=0
		end
		if health == 10 then
			heart = love.graphics.newImage('health10.png')
		elseif health >=9 then
			heart = love.graphics.newImage('health9.png')
		elseif health >=8 then
			heart = love.graphics.newImage('health8.png')
		elseif health >=7 then
			heart = love.graphics.newImage('health7.png')
		elseif health >=6 then
			heart = love.graphics.newImage('health6.png')
		elseif health >=5 then
			heart = love.graphics.newImage('health5.png')
		elseif health >=4 then
			heart = love.graphics.newImage('health4.png')
		elseif health >=3 then
			heart = love.graphics.newImage('health3.png')
		elseif health >=2 then
			heart = love.graphics.newImage('health2.png')
		elseif health >=1 then
			heart = love.graphics.newImage('health1.png')
		else
			heart = love.graphics.newImage('health0.png')
		end

	bike:update(dt)
		for k, box in pairs(boxes) do
			box:update(dt, v)
			--insert function to remove boxes out of scene later
		end

		for l, box in pairs(boxes) do

				if bike:collides(box) then
                   health = health - 1
				   love.audio.newSource('explosion.wav', 'static'):play()
				   regen_cool = 0
				   table.insert(explodedboxes, box)
				   table.remove(boxes, l)
				   actualScore = actualScore - 200

					if score <= 200 then
						score = 0
					else
						score = score - 200
					end
                end
		end

		if health < 10 then
			if allowRegen == 'true' then
			if regen_cool > 5 then
				health = health + 0.5 * dt
			end
			end
		else
			health = 10
			regen_cool = 0
		end
		love.draw(dt)

		love.keyboard.keysPressed = {}
	end

	function love.draw(dt)
		push:start()

		love.graphics.draw(background, -backgroundScroll, 0)
		love.graphics.draw(grass, -grassScroll, VIRTUAL_HEIGHT-63)
		love.graphics.draw(heart, 0, 0)
		love.graphics.print('Biker77', VIRTUAL_WIDTH * 3 / 4, VIRTUAL_HEIGHT *6 / 7)
		love.graphics.print('Score: '..tostring(score), 10, VIRTUAL_HEIGHT / 7)
		if health >= 1 then
			bike:render()
		else
			v = 0
			allowRegen = 'false'
			love.graphics.print('Game over', VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
			function love.keypressed(key)
				if key == 'escape' then
					love.event.quit()
				end
			end

		end
		for k, box in pairs(boxes) do
			box:render('true')
			count =0
		end
		for m, box in pairs(explodedboxes) do

			box:render('false')
		end
		push:finish()
	end

