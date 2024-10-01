require("snake")

-- Initialize the Snake module with segments
Snake = {}
Snake.segments = {
	{ x = 5, y = 5 } -- Starting position of the snake's head
}

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

-- Handle game quit
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	-- Handle snake movement
	if key == "right" or key == "left" or key == "down" or key == "up" then
		print(key)
	end

	local head = Snake.segments[1]

	if key == "right" then
		head.x = head.x + 1
	elseif key == "left" then
		head.x = head.x - 1
	elseif key == "down" then
		head.y = head.y + 1
	elseif key == "up" then
		head.y = head.y - 1
	end

	-- Update the rest of the segments to follow the head
	for i = #Snake.segments, 2, -1 do
		Snake.segments[i].x = Snake.segments[i - 1].x
		Snake.segments[i].y = Snake.segments[i - 1].y
	end
end

function love.draw()
	local cellSize = 20

	for _, segment in ipairs(Snake.segments) do
		buildSnake(segment, cellSize)
	end
end

function buildSnake(segment, cellSize)
	love.graphics.setColor(0.9, 0.9, 0.9)
	love.graphics.rectangle(
		'fill',
		(segment.x - 1) * cellSize,
		(segment.y - 1) * cellSize,
		cellSize - 1,
		cellSize - 1
	)
end

function love.load()
	-- Additional initialization if needed
end
