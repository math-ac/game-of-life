function love.load()
    love.window.setTitle("Game of Life")
    love.window.setMode(350, 250)
    love.graphics.setBackgroundColor(1, 1, 1)

    cell_size = 5
    grid_x = 70
    grid_y = 50

    grid = {}

    for x = 1, grid_x do
        grid[x] = {}
        for y = 1, grid_y do
            grid[x][y] = false
        end
    end

    love.keyboard.setKeyRepeat(true)
end

function love.update()
    selected_x = math.min(math.floor(love.mouse.getX() / cell_size) + 1, grid_x)
    selected_y = math.min(math.floor(love.mouse.getY() / cell_size) + 1, grid_y)

    if love.mouse.isDown(1) then
        grid[selected_x][selected_y] = true
    elseif love.mouse.isDown(2) then
        grid[selected_x][selected_y] = false
    end
end

function love.keypressed()
    if love.keyboard.isDown("space") then
        local next_grid = {}

        for x = 1, grid_x do
            next_grid[x] = {}

            for y = 1, grid_y do
                local neighbor_count = 0

                for dx = -1, 1 do
                    for dy = -1, 1 do
                        if not(dx == 0 and dy == 0)
                        and grid[x + dx]
                        and grid[x + dx][y + dy] then
                            neighbor_count = neighbor_count + 1
                        end
                    end
                end
                next_grid[x][y] = neighbor_count == 3
                                  or (grid[x][y] and neighbor_count == 2)
            end
        end
        grid = next_grid
    elseif love.keyboard.isDown("r") then
        for x = 1, grid_x do
            grid[x] = {}

            for y = 1, grid_y do
                grid[x][y] = false
            end
        end
    elseif love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function love.draw()
    for x = 1, grid_x do
        for y = 1, grid_y do
            local cell_draw_size = cell_size - 1

            if x == selected_x and y == selected_y then
                love.graphics.setColor(0, .5, 1)
            elseif grid[x][y] then
                love.graphics.setColor(1, .6, 0)
            else
                love.graphics.setColor(.9, .9, .9)
            end
            love.graphics.rectangle("fill", 
                                    (x - 1) * cell_size, 
                                    (y - 1) * cell_size, 
                                    cell_draw_size, 
                                    cell_draw_size)
        end
    end
end
