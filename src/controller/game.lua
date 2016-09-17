
local sprites = basic.pack 'database.sprites'

local gamecontroller = {}

local slash_body = require 'attack' :new { 0, 0, 1, 1 }
local slash_sprite = require 'sprite' :new { sprites.slash }
local dash_speed = 0.3
local directions = {
  right      = math.pi * 0/4,
  down_right = math.pi * 1/4,
  down       = math.pi * 2/4,
  down_left  = math.pi * 3/4,
  left       = math.pi * 4/4,
  up_left    = math.pi * 5/4,
  up         = math.pi * 6/4,
  up_right   = math.pi * 7/4
}

local function animateslash (player, dist)
  slash_sprite:setrotation(math.atan2(dist.y, dist.x))
  dist:add{0, -1/4, 0}
  slash_body.pos:set((player.pos + dist/4):unpack())
  hump.gamestate.current():add_body('slash', slash_body)
  hump.gamestate.current():add_drawable('slash', slash_sprite)
  hump.timer.after(
    0.2,
    function()
      hump.gamestate.current():del_body('slash') hump.timer.clear()
      hump.gamestate.current():del_drawable('slash') hump.timer.clear()
    end
  )
  hump.timer.every(
    globals.frameunit,
    function()
      slash_body.pos:set((player.pos + dist/4):unpack())
    end
  )
end

local function longattack (player, dirangle)
  local dist = basic.vector:new { math.cos(dirangle), math.sin(dirangle) }
  animateslash(player, dist*1)
  dist:mul(dash_speed)
  player:lock(0.5)
  player.speed:add(dist)
end

local function shortattack (player, dirangle)
  local dist = basic.vector:new { math.cos(dirangle), math.sin(dirangle) }
  player:lock(0.3)
  animateslash(player, dist)
end

gamecontroller.input_attack = {
  signal = 'presskey',
  func = function (action)
    local player = hump.gamestate.current():getbody('player')
    if not player or player.locked then return end
    local dir = player:getdirection()
    if action == 'maru' then
      shortattack(player, dir)
    elseif action == 'batsu' then
      longattack(player, dir)
    end
  end
}

gamecontroller.input_move_player = {
  signal = 'holdkey',
  func = function (action)
    if action == 'maru' or action == 'batsu' or action == 'quit' then return end
    local player = hump.gamestate.current():getbody('player')
    if not player or player.locked then return end
    local movement = basic.vector:new {}
    local speed = globals.frameunit * globals.unit / 64
    movement:set(speed * math.cos(directions[action]), speed * math.sin(directions[action]))
    player:face(action)
    player:move(movement)
  end
}

gamecontroller.body_collision = {
  signal = 'body_collision',
  func = function (body, somebody)
    body:on_collision(somebody)
  end
}

gamecontroller.body_death = {
  signal = 'body_death',
  func = function(somebody)
    local scene = hump.gamestate.current()
    local bodyname = scene:find_body(somebody)
    if bodyname then
      scene:del_body(bodyname)
      scene:del_drawable(bodyname)
    end
  end
}

return require 'controller' :new { actions = gamecontroller }
