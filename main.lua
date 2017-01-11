printf = function(s,...) return io.write(s:format(...)) end

-- #============================================================================
-- # load ()
-- #============================================================================
function love.load()
    game = {
        w = 300,
        h = 300
    }
    p1 = {
        pad = {
            w = 30,
            h = 100,
            x = 0,
            y = 0,
            speed = 300,  -- pixels/sec
        },
        up_pressed = false,
        down_pressed = false
    }
    p2 = {
        pad = {
            w = 10,
            h = 60,
            x = 0,
            y = 0,
            speed = 300
        },
        up_pressed = false,
        down_pressed = false
    }
    ball = {
        w = 15,
        h = 15,
        x = 0,
        y = 0,
        speed = 300,
        direction = 0  -- should be 0 - 360 or something like that (?)
    }

    -- initialize positions
    p1.pad.x = 0
    p1.pad.y = game.h / 2 - p1.pad.h / 2
    p2.pad.x = game.w - p2.pad.w
    p2.pad.y = game.h / 2 - p2.pad.h / 2
    ball.x = game.w / 2 - ball.h / 2
    ball.y = game.h / 2 - ball.w / 2
end

-- #============================================================================
-- # update ()
-- #============================================================================
function love.update(dt)
    if game_is_paused then
        return
    end

    update_player_position(p1, dt)
    update_player_position(p2, dt)
    update_ball_position(ball, dt)
end

-- #============================================================================
-- # update_player_position ()
-- #============================================================================
function update_player_position(p, dt)
    local y_diff = p.pad.speed * dt
    if p.up_pressed then
        p.pad.y = math.max(p.pad.y - y_diff, 0)
    end
    if p.down_pressed then
        p.pad.y = math.min(p.pad.y + y_diff, game.h - p.pad.h)
    end
end

-- #============================================================================
-- # update_ball_position ()
-- #============================================================================
function update_ball_position(b, dt)

end

-- #============================================================================
-- # draw ()
-- #============================================================================
function love.draw()
    love.graphics.setColor(255, 255, 255)
    draw_gui()
    draw_player(p1)
    draw_player(p2)
    draw_ball(ball)
end

-- #============================================================================
-- # draw_gui ()
-- #============================================================================
function draw_gui(p)
    local vertices = {
        0     , 0,
        game.w, 0,
        game.w, game.h,
        0     , game.h
    }
    love.graphics.polygon('line', vertices)
end

-- #============================================================================
-- # draw_player ()
-- #============================================================================
function draw_player(p)
    draw_rectangle(p.pad)
end

-- #============================================================================
-- # draw_ball ()
-- #============================================================================
function draw_ball(b)
    draw_rectangle(b)
end

-- #============================================================================
-- # draw_rectangle ()
-- #============================================================================
function draw_rectangle(r)
    local vertices = {
        r.x      , r.y,
        r.x + r.w, r.y,
        r.x + r.w, r.y + r.h,
        r.x      , r.y + r.h,
    }
    love.graphics.polygon('fill', vertices)
end

-- #============================================================================
-- # keypressed ()
-- #============================================================================
function love.keypressed(key)
    key_pressed_or_released(key, true)
end

-- #============================================================================
-- # keyreleased ()
-- #============================================================================
function love.keyreleased(key)
    key_pressed_or_released(key, false)
end

-- #============================================================================
-- # key_pressed_or_released ()
-- #============================================================================
function key_pressed_or_released(key, pressed)
    if key == 'up' then       p1.up_pressed = pressed
    elseif key == 'down' then p1.down_pressed = pressed
    elseif key == 'w' then    p2.up_pressed = pressed
    elseif key == 's' then    p2.down_pressed = pressed end
end

-- #============================================================================
-- # focus ()
-- #============================================================================
function love.focus(f)
    game_is_paused = not f
    -- if not f then
    --     printf("Lost focut\n")
    -- else
    --     printf("Gained focus\n")
    -- end
end

-- #============================================================================
-- # quit ()
-- #============================================================================
function love.quit()
    printf("Thanks for playing! Come back soon!\n")
end
