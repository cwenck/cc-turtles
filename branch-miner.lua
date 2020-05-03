args = {...}
 
local distance = 0
local torchFreq = 0
local water = "n"
local num = 0
 
if args[1] == nil then
  print("Please imput a positive value...")
  return
end
distance = tonumber(args[1]) - 1
torchFreq = tonumber(args[2])
water = args[3]
 
if distance < 1 then
  print("Please imput a positive value...")
  return
end
 
if torchFreq == nil then
  torchFreq = 0
end
 
if water == nil then
  water = "n"
end
 
 
local x = 0
local z = 0
local y = 0
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
    d = turtle.dig()
    sleep(.3)
    return d
  end
end
 
function digUp()
  d = turtle.digUp()
  return d
end
 
function digDown()
  d = turtle.digDown()
  return d
end
 
function right()
  turtle.turnRight()
end
 
function left()
  turtle.turnLeft()
end
 
function placeWater(direction)
  turtle.select(15)
  b1 = false
  b2 = false
  while b1 ~= true and b2 ~= true do
    if direction == "f" then
      b1 = turtle.place()
      b2 = dig()
    elseif direction == "u" then
      b1 = turtle.placeUp()
      b2 = digUp()
    end
  end
  turtle.select(1)
end
 
function torch(frequency)
  num = x % frequency
  if num == 1 and turtle.getItemCount(16) > 1 then
    b = false
    while b ~= true do
      b = turtle.back()
    end
    turtle.select(16)
    turtle.placeUp()
    turtle.select(1)
    b = false
    while b ~= true do
      b = turtle.forward()
    end
  end
end
 
function forward()
  b = false
  if water == "y" then
    dig()
    placeWater("f")
  end
  while b ~= true do
    refuel()
    dig()
    b = turtle.forward()
  end
  digUp()
  if water == "y" then
    placeWater("u")
  end
  torch(torchFreq)
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
 
function returnBack()
  b = false
  while b ~= true do
    refuel()
    dig()
    b = turtle.forward()
  end
  x = x - 1
end
 
function branch()
  for i = 1,distance do
    forward()
  end
  right()
  right()
  for  i = 1,distance do
    returnBack()
  end
end
 
branch()