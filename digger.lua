local args = {...}

local xTarget = 0
local zTarget = 0
local depth = 0
local num = 0
local num_2 = 0
local num_3 = 0
local row = 0
local direction = "r"
local dir_1 = "r"
local dir_2 = "l"

local x = 0
local z = 0
local y = 0

xTarget = tonumber(args[1]) - 1
zTarget = tonumber(args[2])
depth = tonumber(args[3])
direction = args[4]

if xTarget == nil or xTarget < 1 then
  print("Please enter a postive value...")
  return
end

if zTarget == nil or zTarget < 1 then
  zTarget = xTarget
else
  zTarget = zTarget - 1
end

if depth == nil or depth < 1 then
  depth = 1
end

----------

function refuel()
  while turtle.getFuelLevel() == 0 do
    for i = 1,16 do
      if turtle.getItemCount(i) > 0 then
        b = false
        turtle.select(i)
        b = turtle.refuel(1)
        if b then
          break
        end
      end
    end
    if b then
      break
    end
    print("In need of fuel.")
    print("Press enter to continue...")
    while true do
      event, peram = os.pullEvent("key")
      if event == "key" and peram == 28 then
        break
      end
    end
  end
end

function dig()
  if turtle.detect() then
    turtle.dig()
  end
end

function digUp()
  turtle.digUp()
end

function digDown()
  turtle.digDown()
end

function right()
  turtle.turnRight()
end

function left()
  turtle.turnLeft()
end

function forward()
  b = false
  while b ~= true do
    refuel()
    dig()
    b = turtle.forward()
  end
  x = x + 1
end

function up()
  b = false
  while b ~= true do
    refuel()
    digUp()
    b = turtle.up()
  end
  y = y + 1
end

function down()
  b = false
  while b ~= true do
    refuel()
    digDown()
    b = turtle.down()
  end
  y = y - 1
end

function back()
  b = false
  while b ~= true do
    b = turtle.back()
  end
  x = x - 1
end

function digRow()
  for i = 1,xTarget do
    forward()
  end
end

function digLayer(facing)
  row = 0
  for i = 1,zTarget do
  digRow()
  row = row + 1
  num = row % 2
    if num == 0 and facing == "r" then
      left()
      forward()
      left()
    elseif num == 1 and facing == "r" then
      right()
      forward()
      right()
    elseif num == 0 and facing == "l" then
      right()
      forward()
      right()
    elseif num == 1 and facing == "l" then
      left()
      forward()
      left()
    end
  end
  digRow()
end

function digHole(facing)
  if facing == "r" then
    dir_1 = "r"
    dir_2 = "l"
  elseif facing == "l" then
    dir_1 = "l"
    dir_2 = "r"
  end
  for i = 1,depth do
    num_2 = zTarget % 2
    num_3 = y % 2
    down()
    if num_2 ==  0 then
      digLayer(dir_1)
      right()
      right()
    elseif num_2 == 1 then
      if num_3 == 0 then
        digLayer(dir_1)
        right()
        right()
      elseif num_3 == 1 then
        digLayer(dir_2)
        right()
        right()
      end
    end
  end
end


digHole(direction)