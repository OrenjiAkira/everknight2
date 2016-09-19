
local dynamic_body = physics.collision_body:new {
  __type = 'dynamic_body'
}

local directions = {
  right      = basic.vector:new { math.cos(math.pi * 0/4), math.sin(math.pi * 0/4), },
  down_right = basic.vector:new { math.cos(math.pi * 1/4), math.sin(math.pi * 1/4), },
  down       = basic.vector:new { math.cos(math.pi * 2/4), math.sin(math.pi * 2/4), },
  down_left  = basic.vector:new { math.cos(math.pi * 3/4), math.sin(math.pi * 3/4), },
  left       = basic.vector:new { math.cos(math.pi * 4/4), math.sin(math.pi * 4/4), },
  up_left    = basic.vector:new { math.cos(math.pi * 5/4), math.sin(math.pi * 5/4), },
  up         = basic.vector:new { math.cos(math.pi * 6/4), math.sin(math.pi * 6/4), },
  up_right   = basic.vector:new { math.cos(math.pi * 7/4), math.sin(math.pi * 7/4), },
}

function dynamic_body:__init ()
  self.speed = basic.vector:new {}
  self.dir = 'down'
end

function dynamic_body:update ()
  self:deaccelerate()
  self.pos:add(self.speed)
end

function dynamic_body:draw ()
end

function dynamic_body:repulse (point)
  local antigravity = self.pos - point
  self:move(0.5 * antigravity:normalized())
end

--function dynamic_body:checkandcollide (somebody)
--end

function dynamic_body:on_collision (somebody)
  -- do stuff
end

function dynamic_body:move (acc)
  self.speed:add(acc)
  self:face(acc)
end

function dynamic_body:stop ()
  self.pos:sub(self.speed)
  self.speed:set()
end

function dynamic_body:deaccelerate ()
  self.speed:mul(0.8)
  if self.speed * self.speed < globals.epsilon then
    self.speed:set(0, 0)
  end
end

function dynamic_body:face(dir)
  if type(dir) == 'string' then
    self.dir = dir
  else
    -- assume it's a vector
    local angle = math.atan2(dir.y, dir.x)
    print(angle)
    local pi = math.pi
    if angle >= 0 then
      if     angle <= 1 * pi / 8 then self.dir = 'right'
      elseif angle <= 3 * pi / 8 then self.dir = 'down_right'
      elseif angle <= 5 * pi / 8 then self.dir = 'down'
      elseif angle <= 7 * pi / 8 then self.dir = 'down_left'
      else self.dir = 'left' end
    else
      if     angle >= -1 * pi / 8 then self.dir = 'right'
      elseif angle >= -3 * pi / 8 then self.dir = 'up_right'
      elseif angle >= -5 * pi / 8 then self.dir = 'up'
      elseif angle >= -7 * pi / 8 then self.dir = 'up_left'
      else self.dir = 'left' end
    end
  end
end

function dynamic_body:getdirection ()
  if type(self) == 'string' then
    return directions[self] and directions[self] * 1
  else
    return directions[self.dir] * 1
  end
end

return dynamic_body
