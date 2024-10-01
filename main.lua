require("snake")

-- Handle game quit
function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  -- Handle snake movement
  if key == "right" or key == "left" or key == "down" or key == "up" then
    for index, segment in ipairs(Snake.segments) do
      if key == "right" then
        segment.x = segment.x + 1
      end
      if key == "left" then
        segment.x = segment.x - 1
      end
      if key == "down" then
        segment.y = segment.y - 1
      end
      if key == "up" then
        segment.y = segment.y + 1
      end
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
end
