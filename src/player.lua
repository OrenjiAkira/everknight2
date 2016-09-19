
local entity = require 'entity'

local player = entity:new {
  __type = 'player'
}

function player:__init ()
  self.maxhp = 10
  self.locked = false
end

function player:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    self:take_damage(somebody.attack, somebody.pos)
  elseif somebody:get_type() == 'collectable' then
    hump.signal.emit('get_item', somebody.item)
    somebody.damage = 999
  elseif somebody:get_type() ~= 'attack' then
    self:stop()
  end
end

function player:lock (time)
  self.timer:after(time, function() self:unlock() end)
  self.locked = true
end

function player:unlock ()
  self.locked = false
end

function player:update ()
  entity.update(self) -- call entity update
  hump.signal.emit('check_player_position', self.pos)
end

function player:draw ()
  entity.draw(self) -- call entity draw
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  love.graphics.printf(
    "PLAYER",
    globals.unit * (self.pos.x - 1),
    globals.unit * (self.pos.y - self.size - 0.5),
    globals.unit * 2,
    "center"
  )
  love.graphics.pop()
end

return player
