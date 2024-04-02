anim8 = require 'libs/anim8'
flux = require "libs/flux"

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest" , 1)
  logo_image = love.graphics.newImage("sprites/logo.png")

  shoot_sound = love.audio.newSource("sounds/shoot.wav", "static")
  enemy_shoot_sound = love.audio.newSource("sounds/shoot.wav", "static")
  enemy_shoot_sound:setPitch(0.5)
  explosion_sound = love.audio.newSource("sounds/explosion.wav", "static")
  hurt_sound = love.audio.newSource("sounds/hitHurt.wav", "static")
  --bullet
  bullet_image = love.graphics.newImage("sprites/bullet.png")
  ----
  bar = love.graphics.newImage('sprites/bar.png')
  pressX = love.graphics.newImage('sprites/pressX.png')
  font = love.graphics.newImageFont("fonts/font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
  -- ocean = love.graphics.newImage("sprites/ocean.png")


  --ships
  ship_image = love.graphics.newImage('sprites/ship.png')
  ship_exp_image = love.graphics.newImage('sprites/ship_destroy.png')
  ship_exp_g = anim8.newGrid(327, 100, ship_exp_image:getWidth(), ship_exp_image:getHeight())
  ship_exp_animation = anim8.newAnimation(ship_exp_g('1-13',1), 0.07, "pauseAtEnd")
  ship_exp = {}
  ship_exp.x = 600
  ship_exp.y = 0

  ships = {}
  shipTimer = love.timer.getTime() + 50
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
  player_animation = anim8.newAnimation(player_g('1-7',1), 0.25)
  player_animation_2 = anim8.newAnimation(player_g('1-7',2), 0.05)
  player_animation_3 = anim8.newAnimation(player_g('1-7',3), 0.05)

  --enemy spritesheet
  enemy_image = love.graphics.newImage('sprites/enemy.png')
  enemy_g = anim8.newGrid(49, 39, enemy_image:getWidth(), enemy_image:getHeight())
  enemy_animation = anim8.newAnimation(enemy_g('1-7',1), 0.05)

  --explosion
  exp_image = love.graphics.newImage('sprites/explosion.png')
  exp_g = anim8.newGrid(64, 64, exp_image:getWidth(), exp_image:getHeight())
  exp_animation = anim8.newAnimation(exp_g('1-9',1), 0.07, "pauseAtEnd")

  shoot_image = love.graphics.newImage('sprites/shoot.png')
  shoot_g = anim8.newGrid(32, 32, shoot_image:getWidth(), shoot_image:getHeight())
  shoot_anim = anim8.newAnimation(shoot_g('1-5',1), 0.07, "pauseAtEnd")

  shot = {
    x= 0,
    y= 600
  }

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
  player.numberOfBullets = 150
  player.currAnim = player_animation
  player.hits = 0

  player_crashing = {}
  player_crashing.x = 200
  player_crashing.y = 600

  currTime = love.timer.getTime()
  enemyTimerSeconds = 2
  enemyTimer = love.timer.getTime() + enemyTimerSeconds
  enemyBulletTimer = love.timer.getTime() + 1

  score = 0
  state = "menu"

  kamikazeShip = {
    x = 0,
    y = 0,
    width = 327/2,
    height = 62/2,
    index = 0,
  }

  defaultsSet = true

end

function setDefaults() 
  ships = {}
  shipTimer = love.timer.getTime() + 50
  cloudTimer = love.timer.getTime() + 2

  bullets = {}
  bulletSpeed = 10
  defaultsSet = true
  bullets = {}
  enemy_bullets = {}

  player.x = (800/2 - 50)/2
  player.y = 230
  player.speed = 0
  player.maxSpeed = 5
  player.accel = 0.5
  player.friction = 0.08
  player.numberOfBullets = 150
  player.currAnim = player_animation
  player.hits = 0

  player.currAnim = player_animation
  cloudTimer = love.timer.getTime() + 2
  enemyTimerSeconds = 2
  enemyTimer = love.timer.getTime() + enemyTimerSeconds
  enemyBulletTimer = love.timer.getTime() + 1
  shipTimer = love.timer.getTime() + 50
  score = 0
  enemies = {}
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
  ships = {}
  tutorial = false
end

function love.update(dt)

  flux.update(dt)
  if state == "playing" then

    if tutorial == false and ships[1] ~= nil then
      tutorial = true
    end

    if not defaultsSet then
      setDefaults()
    end

    if enemyTimerSeconds >= 0.3 then
      enemyTimerSeconds = enemyTimerSeconds - 0.00004
    end

    print(enemyTimerSeconds)
    -- ships

    if state == "playing" then
      flux.to(player, 2, { y = 230 })
      player_crashing.y = 600
    end

    if love.timer.getTime() >= shipTimer then
      shipTimer = love.timer.getTime() + 50
      table.insert(ships, {x = math.random(60, 100), y = -39, rotation = math.random(-5,5), canBeDestroyed = false})
    end

    for _, ship in ipairs(ships) do
      if state == "playing" then
        ship.y = ship.y + 0.5
      end

      if ship.y > 20 and ship.y < 200 then
        ship.canBeDestroyed = true
      else 
        ship.canBeDestroyed = false
      end
    end

    if love.keyboard.isDown("x") then
      for _, ship in ipairs(ships) do
        if ship.canBeDestroyed then
          kamikazeShip.x = ship.x
          kamikazeShip.y = ship.y
          kamikazeShip.index = _

          state = "kamikaze"
        end
      end
    end


    ----------------

    --clouds

    if love.timer.getTime() >= cloudTimer then
      cloudTimer = love.timer.getTime() + 2
      if state == "playing" then
        table.insert(clouds, {x = math.random(0, (800 - 80)/2), y = -400, sprite = math.random(1,3)})
      end
    end

    
    for _, cloud in ipairs(clouds) do
      if state == "playing" then
        cloud.y = cloud.y + 0.5
      end
      if cloud.y >= 600 then
        table.remove(clouds, _)
      end
    end

    -----------------------------------------------------
    
    --spawning enrmies

    currTime = love.timer.getTime()

    if currTime >= enemyTimer then
      enemyTimer = love.timer.getTime() + enemyTimerSeconds

      if math.random(1,2) == 2 then
        enemyX = math.random(0, (800 - 80)/2)
      else 
        enemyX = player.x + math.random(10,20)
      end
      enemyY = -39
      id = math.random(1,3)
      bulletTimer = love.timer.getTime() + math.random(0.8,1.4)
      
      if state == "playing" then
        table.insert(enemies, {x = enemyX, y = enemyY, shots = 0, id = id, bulletTimer = bulletTimer})
      end
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

      if CheckCollision(player.x + 8, player.y, 22+10, 39, enemy_bullet.x, enemy_bullet.y, 1, 10) then
        player.hits = player.hits + 1
        shoot_anim:gotoFrame(1)
        shoot_anim:resume()
        hurt_sound:play()  
        shot.x = enemy_bullet.x
        shot.y = enemy_bullet.y
        table.remove(enemy_bullets, _)
      end
      
      if(enemy_bullet.y >= 600) then
        table.remove(enemy_bullets, _)
      end
    end
    
    if player.hits == 0 then
      player.currAnim = player_animation
    end
    if player.hits >= 1 then
      player.currAnim = player_animation_2
    end
    if player.hits >= 2 then
      
      player.currAnim = player_animation_3
    end
    if player.hits >= 3 then
      state = "over"
    end
    
    ---------------------------------------
    
    --enemies shooting bullets and enemy movement
    for _, enemy in ipairs(enemies) do
      -- enemy.x = enemy.x + 1
      enemy.y = enemy.y + 1
      
      if love.timer.getTime() > enemy.bulletTimer then
        enemy.bulletTimer = love.timer.getTime() + math.random(0.8,1.4)
        enemy_shoot_sound:play()
        table.insert(enemy_bullets, {x = enemy.x + 25, y = enemy.y, width = 1, height = 10})
      end
      -- print(enemy.shots)
      if enemy.shots > 2 then
        score = score + 10
        explosion.x = enemy.x
        explosion.y = enemy.y
        exp_animation:gotoFrame(1)
        exp_animation:resume()
        explosion_sound:play()

        table.remove(enemies, _)
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
      
      for _, enemy in ipairs(enemies) do
        for _, bullet in ipairs(bullets) do
          if CheckCollision(bullet.x, bullet.y, bullet.width, bullet.height, enemy.x, enemy.y, 49, 39) then
            table.remove(bullets, _)
            enemy.shots = enemy.shots + 1
            shot.x = bullet.x - 10
            shot.y = bullet.y - 10
            shoot_anim:gotoFrame(1)
            shoot_anim:resume()
            hurt_sound:play()
        end
      end
    end
  end

  if state == "kamikaze" then
    flux.to(player, 4, { y = 600 })

    for _, enemy in ipairs(enemies) do
      -- enemy.x = enemy.x + 1
      enemy.y = enemy.y + 1
      
      if enemy.y >= 600 then
        table.remove(enemies, _)
      end
    end
    enemy_bullets = {}
    -- player_crashing.x = kamikazeShip.x + 10
    flux.to(player_crashing, 1.7, {y = kamikazeShip.y - 200, x = kamikazeShip.x + 70 }):ease("linear"):delay(1.5)
    if CheckCollision(player_crashing.x, player_crashing.y, 22/2, 39/2, kamikazeShip.x, kamikazeShip.y, kamikazeShip.width, kamikazeShip.height) then
      ship_exp.x = kamikazeShip.x
      ship_exp.y = kamikazeShip.y
      explosion.x = player_crashing.x - 20
      explosion.y = player_crashing.y - 20
      ship_exp_animation:gotoFrame(1)
      ship_exp_animation:resume()
      exp_animation:gotoFrame(2)
      exp_animation:resume()
      explosion_sound:play()

      table.remove(ships, kamikazeShip.index)
      player.numberOfBullets = 150
      score = score + 100
      player.hits = 0
      state = "playing"
      
    end
  end

  if state == "over" then
    defaultsSet = false
    if love.keyboard.isDown("r") then
      state = "playing"
    end
  end
  if state == "menu" then
    defaultsSet = false
    if love.keyboard.isDown("return") then
      state = "playing"
    end
  end


  --animations
  player.currAnim:update(dt)
  enemy_animation:update(dt)
  exp_animation:update(dt)
  ship_exp_animation:update(dt)
  shoot_anim:update(dt)

end

function love.draw()

  love.graphics.scale(2)
  love.graphics.setBackgroundColor(23/255,32/255,56/255)
  
  love.graphics.setColor(1,1,1,1)

  love.graphics.draw(bar, 0, 0)
  love.graphics.setFont(font, 100)


  if state == "playing" or state == "kamikaze" then
  
    for _, ship in ipairs(ships) do
      love.graphics.setColor(0,0,0,0.5)
      love.graphics.rectangle("fill", ship.x + 7, ship.y + 10, 180,23, 3)
      love.graphics.setColor(0.7,0.7,0.7,1)
      love.graphics.draw(ship_image, ship.x, ship.y, 0,0.5)
      love.graphics.setColor(1,1,1,1)

      if ship.canBeDestroyed then
        love.graphics.draw(pressX, ship.x + 80, ship.y,0, 0.3)
        love.graphics.print("PRESS X TO DESTROY SHIP",ship.x + 40, ship.y + 20,0, 0.4)
        if tutorial then
        end
      end
    end

    player_animation:draw(player_image, player_crashing.x, player_crashing.y, 0,0.5)


    love.graphics.setColor(0.7,0.7,0.7,1)
    ship_exp_animation:draw(ship_exp_image,ship_exp.x,ship_exp.y, 0,0.5)
    love.graphics.setColor(1,1,1,1)
    -- love.graphics.draw(ship_image,50,50)

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

    love.graphics.setColor(0,0,0,0.4)
    player_animation:draw(player_image, player.x + 30, player.y + 30,0,0.5)
    love.graphics.setColor(1,1,1,1)
    player.currAnim:draw(player_image, player.x, player.y)
    
    exp_animation:draw(exp_image, explosion.x, explosion.y)
    
    
    for _,enemyBullet in ipairs(enemy_bullets) do
      love.graphics.rectangle("fill", enemyBullet.x, enemyBullet.y, enemyBullet.width, enemyBullet.height)
    end
    for _, enemy in ipairs(enemies) do
      love.graphics.setColor(0,0,0,0.4)
      enemy_animation:draw(enemy_image, enemy.x + 30, enemy.y + 30,0,0.5)
      love.graphics.setColor(1,1,1,1)
      
      enemy_animation:draw(enemy_image, enemy.x, enemy.y)
    end
    shoot_anim:draw(shoot_image, shot.x, shot.y)

    
    for _, bullet in ipairs(bullets) do
      love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.draw(bullet_image, 330, 270 - 6)
    love.graphics.print(player.numberOfBullets, 400 - 65, 260, 0,2)

    love.graphics.print(score, 10, 260, 0,2)
  end
  
  --game over
  if state == "over" then
    love.graphics.setColor(0,0,0,0.6)
    love.graphics.rectangle("fill",800/4 - 200/2,600/4 - 200/2,200,200,20)
    love.graphics.setColor(1,0,0,1)
    love.graphics.printf("DESTROYED",(800/4 - 200/2),(600/4 - 200/2) + 50,100,"center",0,2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("SCORE: " .. score,(800/4 - 200/2),(600/4 - 200/2) + 80,120,"center",0,1.7)
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.printf("[R] TO RESTART",(800/4 - 200/2),(600/4 - 200/2) + 130,200,"center",0,1)
  end  

  if state == "menu" then
    love.graphics.draw(logo_image, 80, 30, 0, 2)
    love.graphics.printf("[Enter] to Play",0,200 + math.sin(love.timer.getTime()* 10),400,"center",0,1)
  end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" and state == "playing" or key == "up" and state == "playing" then
      if player.numberOfBullets ~= 0 then
        player.numberOfBullets = player.numberOfBullets - 1
        table.insert(bullets, {x = player.x +  49/2,y = player.y + 10,width = 1,height = 10})
        shoot_sound:play()
      end
    end
 end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end