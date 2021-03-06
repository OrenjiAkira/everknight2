
local controller = basic.prototype:new {
  actions = {},
  __type = 'controller'
}

function controller:connect()
  for _,action in pairs(self.actions) do
    basic.signal:register(action.signal, action.func)
  end
end

function controller:update()
  -- implement on instance
end

function controller:draw()
  -- implement on instance
end

function controller:disconnect()
  for _,action in pairs(self.actions) do
    basic.signal:remove(action.signal, action.func)
  end
end

return controller
