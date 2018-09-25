local LostWindow = {
  title = 'lose'
}
local args = {
  level = 0,
  points = 0
}
function LostWindow.load(arguments)
  args.level = arguments.level
  args.points = arguments.points
end

function LostWindow.draw()
  love.graphics.print('You lose at level ' .. args.level .. ' with ' .. args.points .. ' points.' .. 'Hit \'enter\' to play again.', (love.graphics.getWidth() / 2) - 150, love.graphics.getHeight() / 2)
  love.graphics.print('Hit \'esc\' to go back to menu.',(love.graphics.getWidth() / 2) - 150, (love.graphics.getHeight() / 2) + 20)
end

function LostWindow.update()
  if love.keyboard.isDown('return') then
    setWindow('game')
  elseif love.keyboard.isDown('escape') then
    setWindow('menu')
  end
end

return LostWindow
