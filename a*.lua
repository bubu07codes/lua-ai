-- a* pathfinding algorithm in lua
-- bubu07codes 2025

-- a node class to represent each point in the grid
local Node = {}
Node.__index = Node

function Node:new(x, y)
    return setmetatable({
        x = x,
        y = y,
        gCost = math.huge,
        hCost = 0,
        parent = nil
    }, Node)
end

function Node:fCost()
    return self.gCost + self.hCost
end

local function aStar(start, goal, isWalkable)
    local openList = {}
    local closedList = {}
    local startNode = Node:new(start.x, start.y)
    local goalNode = Node:new(goal.x, goal.y)
    startNode.gCost = 0
    startNode.hCost = math.abs(start.x - goal.x) + math.abs(start.y - goal.y)
    table.insert(openList, startNode)

    while #openList > 0 do
        -- finds the node with lowest fCost (shortest distance)
        local currentNode = table.remove(openList)
        if currentNode.x == goal.x and currentNode.y == goal.y then
            local path = {}
            local current = currentNode
            while current do
                table.insert(path, 1, {x = current.x, y = current.y})
                current = current.parent
            end
            return path
        end

        table.insert(closedList, currentNode)

        -- neighbors
        for dx = -1, 1 do
            for dy = -1, 1 do
                if dx == 0 and dy == 0 then goto continue end
                local neighborX = currentNode.x + dx
                local neighborY = currentNode.y + dy
                if not isWalkable(neighborX, neighborY) then goto continue end
                local neighbor = Node:new(neighborX, neighborY)
                if table.contains(closedList, neighbor) then goto continue end

                local tentativeGCost = currentNode.gCost + 1
                if tentativeGCost < neighbor.gCost then
                    neighbor.gCost = tentativeGCost
                    neighbor.hCost = math.abs(neighbor.x - goal.x) + math.abs(neighbor.y - goal.y)
                    neighbor.parent = currentNode
                    table.insert(openList, neighbor)
                end

                ::continue::
            end
        end
    end

    return nil -- no path was found
end

function table.contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v.x == val.x and v.y == val.y then
            return true
        end
    end
    return false
end

-- example
local map = {
    {0, 0, 0, 0, 0},
    {0, 1, 1, 1, 0},
    {0, 0, 0, 1, 0},
    {0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0}
}

local function isWalkable(x, y)
    if x < 1 or x > #map or y < 1 or y > #map[1] then return false end
    return map[y][x] == 0
end

local start = {x = 1, y = 1}
local goal = {x = 5, y = 5}
local path = aStar(start, goal, isWalkable)

if path then
    for _, p in ipairs(path) do
        print(string.format("Step: (%d, %d)", p.x, p.y))
    end
else
    print("No path found")
end
