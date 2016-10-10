
local sprites = require 'controller' :new { 'dungeon' }

function sprites:__init ()
  local DEATH_TIME = 0.6
  local sprites_model = self:get_model('sprites')
  local hitbox_model = self:get_model('hitboxes')

  -- initialise actions
  self:register_action('death', function (id)
    local sprite = sprites_model:get_element(id)
    local hitbox = hitbox_model:get_element(id)
    local offset = require 'basic.vector' :new {}
    sprite:freeze_animation()
    sprite:set_brightness(1023)
    sprite:set_alpha(200)
    sprites_model:death_animation(sprite, offset)
  end)

  self:register_action('done', function (id)
    sprites_model:remove_element(id)
  end)

  self:register_action('position', function (id, pos)
    local sprite = sprites_model:get_element(id)
    if not sprite then return end

    sprite:set_pos(pos:unpack())
  end)

  self:register_action('change_state', function (id, state)
    local sprite = sprites_model:get_element(id)
    if not sprite then return end

    sprite:set_animation(state)
  end)

  self:register_action('take_damage', function (id, harmful_id, dmg, stagger)
    local sprite = sprites_model:get_element(id)
    if not sprite then return end

    local shine = 1280
    sprite:set_brightness(shine)
    self.timer:during(stagger, function ()
      shine = shine - 30
      sprite:set_brightness(shine)
    end, function ()
      sprite:set_brightness(255)
    end)
  end)

  self:register_action('move', function (id, acc)
    local sprite = sprites_model:get_element(id)
    if not sprite then return end

    local EPSILON = (1/globals.unit)^2
    if acc.x < -EPSILON then
      sprite:set_flip_h(false)
    elseif acc.x > EPSILON then
      sprite:set_flip_h(true)
    end
  end)
end

return sprites:new {}
