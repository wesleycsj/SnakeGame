local Menu = {
  title = 'menu'
}
local option = 0
function Menu.load()

end
function Menu.draw()
  love.graphics.print('SNAKE GAME', 50,50)
  if option == 0 then
    love.graphics.print('> START NEW GAME', 80,80)
    love.graphics.print('EXIT', 80,100)
  else
    love.graphics.print('START NEW GAME', 80,80)
    love.graphics.print('> EXIT', 80,100)
  end
end

function Menu.update()
  if love.keyboard.isDown('up') and option > 0 then
    option = option - 1
  elseif love.keyboard.isDown('down') and option < 1 then
    option = option + 1
  end
  if love.keyboard.isDown('return') then
    if option == 0 then
      setWindow('game')
    elseif option == 1 then
      love.event.quit()
    end
  end
end

return Menu
