local Game = {
  title = 'game',
}
-- Game objects
local Round = {}
local Snake = {}

local Rats = {}

function Game.load()
  Snake = {
    xHead = 0,
    yHead = 0,
    oldXHead = 0,
    oldYHead = 0,
    tilesize = 16,
    timing = 0,
    speedTime = 0.3,
    movingTo = 'right',
    tails = {}
  }
  Snake.x = love.graphics.getWidth()/2, - Snake.tilesize
  Snake.y = love.graphics.getHeight()/2 - Snake.tilesize
  Round = {
    level = 1,
    points = 0,
  }
  Rats = {}
  seed()
end
function moveSnake()
  Snake.oldXHead = Snake.x
  Snake.oldYHead = Snake.y
  if Snake.movingTo == 'up' then
    Snake.y = Snake.y - Snake.tilesize
  elseif Snake.movingTo == 'down' then
    Snake.y = Snake.y + Snake.tilesize
  elseif Snake.movingTo == 'left' then
    Snake.x = Snake.x - Snake.tilesize
  elseif Snake.movingTo == 'right' then
    Snake.x = Snake.x + Snake.tilesize
  end
  if (Snake.x < 0 or Snake.x > love.graphics.getWidth()) or (Snake.y < 0 or Snake.y > love.graphics.getHeight()) then
    setWindow('lose', {
      points = Round.points,
      level = Round.level
    })
  end
  for n in ipairs(Snake.tails) do
    if (Snake.x == Snake.tails[n].x) and (Snake.y == Snake.tails[n].y) then
      setWindow('lose', {
        points = Round.points,
        level = Round.level
      })
    end
  end
  for n in ipairs(Rats) do
    if (Snake.x == Rats[n].x) and (Snake.y == Rats[n].y) then
      Round.points = Round.points + (5 * Round.level)
      appendTail()
      seed()
      if (Round.points % 10 == 0) then
        Round.level = Round.level + 1
        if Snake.speedTime > 0.05 then
          Snake.speedTime = Snake.speedTime - 0.02
        end
      else
        if Snake.speedTime > 0.05 then
          Snake.speedTime = Snake.speedTime - 0.005
        end
      end
      table.remove(Rats, n)
    end
  end
  if #Snake.tails == 1 then
    Snake.tails[1].oldXHead = Snake.tails[1].x
    Snake.tails[1].oldYHead = Snake.tails[1].y
    Snake.tails[1].x = Snake.oldXHead
    Snake.tails[1].y = Snake.oldYHead
  elseif #Snake.tails > 1 then
    for n = 1, (#Snake.tails),1 do
      if n == 1 then
        Snake.tails[1].oldXHead = Snake.tails[1].x
        Snake.tails[1].oldYHead = Snake.tails[1].y
        Snake.tails[1].x = Snake.oldXHead
        Snake.tails[1].y = Snake.oldYHead
      else
        Snake.tails[n].oldXHead = Snake.tails[n].x
        Snake.tails[n].oldYHead = Snake.tails[n].y
        Snake.tails[n].x = Snake.tails[n-1].oldXHead
        Snake.tails[n].y = Snake.tails[n-1].oldYHead
      end
    end
  end
end
function seed()
  local newValue = 0
  local xSeed = Snake.x
  local ySeed = Snake.y
  -- Just tests if the seed don't is inside a tail or snake head
  while (xSeed == Snake.x) and (ySeed == Snake.y) do
    xSeed =  math.floor(math.random(love.graphics.getWidth() - Snake.tilesize) / 16) * 16
    ySeed =  math.floor(math.random(love.graphics.getHeight() - Snake.tilesize) / 16) * 16
    for n in ipairs(Snake.tails) do
      if (xSeed == Snake.tails[n].x) and (ySeed == Snake.tails[n]) then
        xSeed =  math.floor(math.random(love.graphics.getWidth() - Snake.tilesize) / 16) * 16
        ySeed =  math.floor(math.random(love.graphics.getHeight() - Snake.tilesize) / 16) * 16
      end
    end
  end
  table.insert(Rats, {
    x = xSeed,
    y = ySeed
  })
end
function appendTail()
  if #Snake.tails == 0 then
    table.insert(Snake.tails, {
      x = Snake.oldXHead,
      y = Snake.oldYHead,
      oldXHead = 0,
      oldYHead = 0
    })
  else
    table.insert(Snake.tails, {
      x = Snake.tails[#Snake.tails].oldXHead,
      y = Snake.tails[#Snake.tails].oldYHead,
      oldXHead = 0,
      oldYHead = 0
    })
  end
end
function Game.draw()
  -- Menu text
  love.graphics.setColor(1,1,1)
  love.graphics.print('Points:' .. Round.points .. ' Level:' .. Round.level, 20,20)
  -- Snake
  love.graphics.setColor(1,0,0)
  love.graphics.rectangle('fill', Snake.x, Snake.y, Snake.tilesize, Snake.tilesize)
  -- Rats
  love.graphics.setColor(1,1,1)
  for n in ipairs(Rats) do
    love.graphics.rectangle('fill', Rats[n].x, Rats[n].y, Snake.tilesize, Snake.tilesize)
  end
  -- Tails
  love.graphics.setColor(0,0,0)
  local opacityNumber = 1 / #Snake.tails
  local opacity = 1
  for n in ipairs(Snake.tails) do
    love.graphics.setColor(0,0,255, opacity)
    love.graphics.rectangle('fill', Snake.tails[n].x, Snake.tails[n].y, Snake.tilesize, Snake.tilesize)
    opacity = opacity - opacityNumber
  end
  love.graphics.setColor(1,1,1)
end
function Game.update(dt)
  if Snake.timing < Snake.speedTime then
    Snake.timing = Snake.timing + dt
  else
    moveSnake()
    Snake.timing = 0
  end
  if love.keyboard.isDown('up') and not(Snake.movingTo == 'down') then
    Snake.movingTo = 'up'
  elseif love.keyboard.isDown('down') and not(Snake.movingTo == 'up') then
    Snake.movingTo = 'down'
  elseif love.keyboard.isDown('left') and not(Snake.movingTo == 'right') then
    Snake.movingTo = 'left'
  elseif love.keyboard.isDown('right') and not(Snake.movingTo == 'left') then
    Snake.movingTo = 'right'
  end
end

return Game
