anim8 = require 'libs/anim8'

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  

  bar = love.graphics.newImage('sprites/bar.png')
  -- ocean = love.graphics.newImage("sprites/ocean.png")
  --clouds
  cloud1_image = love.graphics.newImage('sprites/cloud1.png')
  cloud2_image = love.graphics.newImage('sprites/cloud2.png')
  cloud3_image = love.graphics.newImage('sprites/cloud3.png')
  clouds = {
    {
      x = math.random(0, (800 - 80)/2),
      y = 40,
      sprite = 1

    },
    {
      x = math.random(0, (800 - 80)/2),
      y = 10,
      sprite = 2
    },
    {
      x = math.random(0, (800 - 80)/2),
      y = math.random(0,200),
      sprite = 3
    },
    
  }
  cloudTimer = love.timer.getTime() + 2

  --player spritesheet
  player_image = love.graphics.newImage('sprites/player_spritesheet.png')
  player_g = anim8.newGrid(49, 39, player_image:getWidth(), player_image:getHeight())
  player_animation = anim8.newAnimation(player_g('1-7',1), 0.05)

  --enemy spritesheet
  enemy_image = love.graphics.newImage('sprites/enemy.png')
  enemy_g = anim8.newGrid(49, 39, enemy_image:getWidth(), enemy_image:getHeight())
  enemy_animation = anim8.newAnimation(enemy_g('1-7',1), 0.05)

  --explosion
  exp_image = love.graphics.newImage('sprites/explosion.png')
  exp_g = anim8.newGrid(64, 64, exp_image:getWidth(), exp_image:getHeight())
  exp_animation = anim8.newAnimation(exp_g('1-9',1), 0.07, "pauseAtEnd")


  --bullets
  bullets = {}
  bulletSpeed = 10

  --enemy bullets
  enemy_bullets = {}

  --enemis
  enemies = {}

  explosion = {}
  explosion.x = -200
  explosion.y = -200
  --player
  player = {}
  player.x = (800/2 - 50)/2
  player.y = 230
  player.speed = 0
  player.maxSpeed = 5
  player.accel = 0.5
  player.friction = 0.08

  currTime = love.timer.getTime()
  step = love.timer.getTime() + 2
  enemyBulletTimer = love.timer.getTime() + 1


end

function love.update(dt)
  --clouds

  if love.timer.getTime() >= cloudTimer then
    cloudTimer = love.timer.getTime() + 2
    table.insert(clouds, {x = math.random(0, (800 - 80)/2), y = -400, sprite = math.random(1,3)})
  end

  
  for _, cloud in ipairs(clouds) do
    cloud.y = cloud.y + 0.5
    print(cloud.sprite)
    if cloud.y >= 600 then
      table.remove(clouds, _)
    end
  end

  -----------------------------------------------------

  --spawning enrmies
  currTime = love.timer.getTime()

  if currTime >= step then
    step = love.timer.getTime() + 2
    table.insert(enemies, {x = math.random(0, (800 - 80)/2), y = -39, shots = 0, bulletTimer = love.timer.getTime() + math.random(0.8,1.4)})
  end

  ------------------------------------------
  
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

  -----------------------------------------------------------------------

  --player collides with enemy bullets

  for _, enemy_bullet in ipairs(enemy_bullets) do
    enemy_bullet.y = enemy_bullet.y + 5
    print(enemy_bullet.y)

    if CheckCollision(player.x + 13, player.y, 22, 39, enemy_bullet.x, enemy_bullet.y, 1, 10) then
      explosion.x = enemy_bullet.x
      explosion.y = enemy_bullet.y
      exp_animation:gotoFrame(1)
      exp_animation:resume()
      table.remove(enemy_bullets, _)
    end

    if(enemy_bullet.y >= 600) then
      table.remove(enemy_bullets, _)
    end
  end

  ---------------------------------------

  --enemies shooting bullets
  for _, enemy in ipairs(enemies) do
    enemy.y = enemy.y + 1

    if love.timer.getTime() > enemy.bulletTimer then
      enemy.bulletTimer = love.timer.getTime() + math.random(0.8,1.4)
      table.insert(enemy_bullets, {x = enemy.x + 25, y = enemy.y, width = 1, height = 10})
    end

    if enemy.y >= 600 then
      table.remove(enemies, _)
    end
  end

    --destroying player bullets after they reach a y position of -10
    for _, bullet in ipairs(bullets) do
      bullet.y = bullet.y - bulletSpeed
      if(bullet.y < -10) then 
        table.remove(bullets, _)
      end
    end

  --check enemy collision with bullets

  for _, bullet in ipairs(bullets) do
    for _, enemy in ipairs(enemies) do
      if CheckCollision(bullet.x, bullet.y, bullet.width, bullet.height, enemy.x, enemy.y, 49, 39) then
        table.remove(bullets, _)
        enemy.shots = enemy.shots + 0.5
        -- print(enemy.shots )

        if enemy.shots == 2 then
          explosion.x = enemy.x
          explosion.y = enemy.y
          exp_animation:gotoFrame(1)
          exp_animation:resume()
          table.remove(enemies, _)
        end

      end
    end
  end

  --animations
  player_animation:update(dt)
  enemy_animation:update(dt)
  exp_animation:update(dt)

end

function love.draw()

  love.graphics.scale(2)
  love.graphics.setBackgroundColor(23/255,32/255,56/255)
  -- love.graphics.draw(ocean,0,0)

  love.graphics.setColor(1,1,1,1)

  love.graphics.draw(bar, 0, 0)

  for _, cloud in ipairs(clouds) do
    love.graphics.setColor(1,1,1,0.1)
    if cloud.sprite == 1 then
      love.graphics.draw(cloud1_image, cloud.x, cloud.y)
    elseif cloud.sprite == 2 then
      love.graphics.draw(cloud2_image, cloud.x, cloud.y)
    else
      love.graphics.draw(cloud3_image, cloud.x, cloud.y)
    end
  end

  love.graphics.setColor(1,1,1,1)
  
  player_animation:draw(player_image, player.x, player.y)
  exp_animation:draw(exp_image, explosion.x, explosion.y)

  
  for _,enemyBullet in ipairs(enemy_bullets) do
    love.graphics.rectangle("fill", enemyBullet.x, enemyBullet.y, enemyBullet.width, enemyBullet.height)
  end
  
  for _, bullet in ipairs(bullets) do
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
  end
  for _, enemy in ipairs(enemies) do
    enemy_animation:draw(enemy_image, enemy.x, enemy.y)
  end

  -- love.graphics.draw(rainbow, 0, 0, 0, love.graphics.getDimensions())

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

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end