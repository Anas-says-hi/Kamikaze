anim8 = require 'anim8'


function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest", 1) 

  --player spritesheet
  player_image = love.graphics.newImage('sprites/player_spritesheet.png')
  player_g = anim8.newGrid(49, 39, player_image:getWidth(), player_image:getHeight())
  player_animation = anim8.newAnimation(player_g('1-7',1), 0.05)

  --enemey spritesheet
  enemy_image = love.graphics.newImage('sprites/enemy.png')
  enemy_g = anim8.newGrid(49, 39, enemy_image:getWidth(), enemy_image:getHeight())
  enemy_animation = anim8.newAnimation(enemy_g('1-7',1), 0.05)

  --bullets
  bullets = {}
  bulletSpeed = 10

  --enemis
  enemies = {}
  enemies[1] = {x = 0,y = 0}

  --player
  player = {}
  player.x = (800/2 - 50)/2
  player.y = 230
  player.speed = 0
  player.maxSpeed = 5
  player.accel = 0.5
  player.friction = 0.08
  
  enemey_spawner_time = love.timer.getTime()
  currTime = love.timer.getTime()+ 2
end

function love.update(dt)

  --spawning enrmies
  enemey_spawner_time = love.timer.getTime()

  if enemey_spawner_time >= currTime then
    currTime = love.timer.getTime() + 2
    table.insert(enemies, {x= math.random(0, (800 - 80)/2), y = -39})
  end
  
  --player movement and controls
  
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    player.speed = player.speed + player.accel
    if(player.speed < player.maxSpeed) then
    end
  elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    player.speed = player.speed - player.accel
  end

  if player.speed >= player.maxSpeed then
    player.speed = player.maxSpeed
  elseif player.speed <= -player.maxSpeed then
    player.speed = -player.maxSpeed
  end

  if math.abs(player.speed) < player.friction then
    player.speed = 0
end

  if player.speed < 0 then
    player.speed = player.speed + player.friction
  elseif player.speed > 0 then
    player.speed = player.speed - player.friction
  end

  if player.x >= (800 - 80)/2 then
    player.x = (800-80)/2 - 0.01
  elseif player.x < -30/2 then
    player.x = -30/2 -0.01
  end

  player.x = player.speed + player.x

  --enemies
  for _, enemy in ipairs(enemies) do
    enemy.y = enemy.y + 1
  end


  --bullets
  for _, bullet in ipairs(bullets) do
    bullet.y = bullet.y - bulletSpeed
    if(bullet.y < -10) then 
      table.remove(bullets, _)
    end
  end

  --animations
  player_animation:update(dt)
  enemy_animation:update(dt)

end

function love.draw()
  love.graphics.scale(2)
  love.graphics.setBackgroundColor(23/255,32/255,56/255)

  for _, bullet in ipairs(bullets) do
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
  end
  for _, enemy in ipairs(enemies) do
    enemy_animation:draw(enemy_image, enemy.x, enemy.y)
  end

  player_animation:draw(player_image, player.x, player.y)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

function love.keypressed(key, scancode, isrepeat)
    if key == "e" or key == "up" then
      table.insert(bullets, {x = player.x +  49/2,y = player.y + 10,width = 1,height = 10})
    end
 end