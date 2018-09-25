local elements = {}
local selectedWindow = 'menu'
function setWindow(title, args)
  selectedWindow = title
  for n in ipairs(elements) do
    if elements[n].title == selectedWindow then
      elements[n].load(args)
    end
  end
end
function getWindow()
  return selectedWindow
end
function love.load()
  table.insert(elements, require('menu'))
  table.insert(elements, require('game'))
  table.insert(elements, require('lose'))
end

function love.draw()
  for n in ipairs(elements) do
    if elements[n].title == selectedWindow then
      elements[n].draw()
    end
  end
end

function love.update(dt)
  for n in ipairs(elements) do
    if elements[n].title == selectedWindow then
      elements[n].update(dt)
    end
  end
end
