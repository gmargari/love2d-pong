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
            x = nil,
            y = nil,
            speed = nil,  -- pixels/sec
        },
        up_button = 'w',
        down_button = 's',
        up_pressed = false,
        down_pressed = false,
        wins = 0,
    }

    p2 = {
        pad = {
            w = 10,
            h = 60,
            x = nil,
            y = nil,
            speed = nil,
        },
        up_button = 'up',
        down_button = 'down',
        up_pressed = false,
        down_pressed = false,
        wins = 0,
    }

    ball = {
        w = 15,
        h = 15,
        x = 0,
        y = 0,
        speed = {
            x = nil,
            y = nil,
        }
    }

    init_players()
    init_ball()
end

-- #============================================================================
-- # init_players ()
-- #============================================================================
function init_players()
    p1.pad.x = 0
    p1.pad.y = game.h / 2 - p1.pad.h / 2
    p1.pad.speed = 300  -- pixels/sec

    p2.pad.x = game.w - p2.pad.w
    p2.pad.y = game.h / 2 - p2.pad.h / 2
    p2.pad.speed = 300
end

-- #============================================================================
-- # init_ball ()
-- #============================================================================
function init_ball()
    ball.x = game.w / 2 - ball.h / 2
    ball.y = game.h / 2 - ball.w / 2
    ball.speed.x = 30
    ball.speed.y = 20
end

-- #============================================================================
-- # update ()
-- #============================================================================
function love.update(dt)
    if game_is_paused then
        love.graphics.print('Game paused', 100, 100)
        return
    end

    update_player_position(p1, dt)
    update_player_position(p2, dt)
    update_ball_position(ball, dt)

    col = collision_ball_with_vertical_bounds(ball, game)
    if col == 1 then
        p2.wins = p2.wins + 1
        init_ball()
    elseif col == 2 then
        p1.wins = p1.wins + 1
        init_ball()
    end
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
    collision_ball_with_pad(b, dt, p1.pad)
    collision_ball_with_pad(b, dt, p2.pad)
    collision_ball_with_horizontal_bounds(b, dt, game)
    b.x = b.x + b.speed.x * dt
    b.y = b.y + b.speed.y * dt
end

-- #============================================================================
-- # collision_ball_with_pad ()
-- #============================================================================
function collision_ball_with_pad(b, dt, p)
    new_b = b
    new_b.x = b.x + b.speed.x * dt
    new_b.y = b.y + b.speed.y * dt
    if collision(new_b, p) then
        b.speed.x = b.speed.x * -1
    end
end

-- #============================================================================
-- # collision_ball_with_horizontal_bounds ()
-- #============================================================================
function collision_ball_with_horizontal_bounds(b, dt, game)
    new_b = b
    new_b.x = b.x + b.speed.x * dt
    new_b.y = b.y + b.speed.y * dt
    if new_b.y < 0 or new_b.y + new_b.h > game.h  then
        b.speed.y = b.speed.y * -1
    end
end

-- #============================================================================
-- # collision_ball_with_horizontal_bounds ()
-- #============================================================================
function collision_ball_with_vertical_bounds(b, game)
    if b.x < 0 then
        return 1
    elseif b.x + b.w > game.w  then
        return 2
    else
        return nil
    end
end

-- #============================================================================
-- # collision ()
-- #============================================================================
function collision(r1, r2)
    return r1.x < r2.x + r2.w and
           r2.x < r1.x + r1.w and
           r1.y < r2.y + r2.h and
           r2.y < r1.y + r1.h
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
    score_x = game.w
    score_y = game.h + 2
    love.graphics.printf(p1.wins.." : "..p2.wins, 0, score_y, score_x, 'center')
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
    if key == p1.up_button then       p1.up_pressed = pressed
    elseif key == p1.down_button then p1.down_pressed = pressed
    elseif key == p2.up_button then   p2.up_pressed = pressed
    elseif key == p2.down_button then p2.down_pressed = pressed
    elseif key == 'p' and pressed then game_is_paused = not game_is_paused
    end
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
