
local player = physics.dynamic_body:new {
  __type = 'player'
}

function player:__init ()
  self.locked = false
end

function player:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    self:take_damage(somebody.attack)
    self:repulse(somebody.pos)
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

return player
