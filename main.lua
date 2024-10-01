function love.draw()
    local gridXCount = 20
    local gridYCount = 15
    local cellSize = 20

    snakeSegments = {
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 }
    }

    scoreSoFar = 0

    for segmentIndex, segment in ipairs(snakeSegments) do
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
