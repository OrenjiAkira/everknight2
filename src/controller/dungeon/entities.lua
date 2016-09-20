
local dungeon_entities = require 'controller' :new {}

local dungeon = hump.gamestate.current()
local entities = {}

local function other(t, index)
  return function(s, var)
    var = next(s, var)
    return var, s[var]
  end, t, index
end

function dungeon_entities:update ()
  for name, entity in pairs(entities) do
    entity:update()
    for bname, body in other(entities, name) do
      entity:checkandcollide(body)
    end
    hump.signal.emit('check_tilemap_collision', entity)
    hump.signal.emit('update_position', name, entity.pos)
  end
end

function dungeon_entities:draw ()
  for name, entity in pairs(entities) do
    entity:draw()
  end
end

function dungeon_entities:get (name)
  return entities[name]
end

local function find_entity (entity)
  for name, e in pairs(entities) do
    if entity == e then return name end
  end
end

function dungeon_entities:__init ()
  self.actions = {
    {
      signal = 'add_entity',
      func = function (name, entity)
        if entities[name] then
          return error("Can't add second " .. name)
        end
        if not entity:isdead() then
          entities[name] = entity
        end
      end
    },
    {
      signal = 'remove_entity',
      func = function (name)
        entities[name] = nil
        hump.signal.emit('remove_sprite', name)
      end
    },
    {
      signal = 'entity_collision',
      func = function (entity, somebody)
        entity:on_collision(somebody)
      end
    },
    {
      signal = 'entity_death',
      func = function (entity)
        local name = find_entity(entity)
        if name then
          hump.signal.emit('remove_entity', name)
          print("DEATH:", name)
        end
      end
    },
    {
      signal = 'entity_immunity',
      func = function (entity)
        local name = find_entity(entity)
        if name then
          hump.signal.emit('shine_sprite', name, globals.stagger)
        end
      end
    },
    {
      signal = 'entity_turn',
      func = function (entity, dir)
        local name = find_entity(entity)
        if name then
          if dir == 'left' or dir == 'up_left' or dir == 'down_left' then
            hump.signal.emit('flip_horizontal', name, false)
          elseif dir == 'right' or dir == 'up_right' or dir == 'down_right' then
            hump.signal.emit('flip_horizontal', name, true)
          end
        end
      end
    }
  }
end

return dungeon_entities:new {}
