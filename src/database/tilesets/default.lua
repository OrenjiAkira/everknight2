
local default = {}

default.img = love.graphics.newImage('assets/images/tileset.png')
default.tilesize = globals.unit
default.obstacles = {
  [2] = true,
  [3] = true,
  [4] = true,
  [5] = true,
  [6] = true,
  [7] = true,
  [8] = true,
  [11] = true,
  [12] = true,
  [13] = true,
  [14] = true,
  [15] = true,
  [16] = true,
}

return default
