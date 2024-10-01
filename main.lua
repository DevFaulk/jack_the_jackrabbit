require("snake")

-- Handle game quit
function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  -- Handle snake movement
  if key == "right" or key == "left" or key == "down" or key == "up" then
    local slide = 1
    lastKey = key

    local segments = ipairs(Snake.segments)
    for index, segment in segments do
      if key == "right" or lastKey == "right" then
        segment.x = segment.x + slide
        if index > 0 then
          
        end
      end
      if key == "left" or lastKey == "left" then
        segment.x = segment.x - slide
      end
      if key == "up" or lastKey == "up" then
        segment.y = segment.y - slide
      end
      if key == "down" or lastKey == "down" then
        segment.y = segment.y + slide
      end
      if index > 0 or index == len(segments) then
        lastKey = key
      end

      for index, slide in 

    end
    print(lastKey)   -- uncomment to debug for last key pressed
  end
end

function love.draw()
  local gridXCount = 20
  local gridYCount = 15
  local cellSize = 20

  scoreSoFar = 0

  for segmentIndex, segment in ipairs(Snake.segments) do
    score(scoreSoFar, segment, cellSize)
  end
end

function score(scoreSoFar, segment, cellSize)
  scoreSoFar = scoreSoFar + 1 --increment score so far
  love.graphics.setColor(.9, .9, .9)
  love.graphics.rectangle(
    'fill',
    (segment.x - 1) * cellSize,
    (segment.y - 1) * cellSize,
    cellSize - 1,
    cellSize - 1
  )
end
