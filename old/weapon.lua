
local prefixes, suffixes = module.afixes.prefixes, module.afixes.suffixes

local weapon = basic.prototype:new {
  0, 1, 4,
  name = 'sord',
  __type = 'weapon'
}

function weapon:__init ()
  self.level = self[1]
  self.dices = self[2]
  self.sides = self[3]
  self.prefixes = {}
  self.suffixes = {}
  self:set_afixes()
  self:set_name()
  -- formula = BASEPOWER + N * D(V) + PLAYERATK
end

function weapon:generate_dmg ()
  return math.floor(gamedata.level * .25 * (self.level + basic.dice.throw(self.dices, self.sides)))
end

function weapon:set_afixes ()
  local iterations = 0
  local level = self.level/4
  while level >= 1 do
    iterations = iterations + 1
    level = level/4
  end
  for i = 1, iterations do
    if love.math.random() < .5 then
      table.insert(
        self.prefixes,
        prefixes[love.math.random(#prefixes)]
      )
    else
      table.insert(
        self.suffixes,
        suffixes[love.math.random(#suffixes)]
      )
    end
  end
end

function weapon:set_name ()
  local name = ""
  for i,prefix in ipairs(self.prefixes) do name = name .. prefix .. ' ' end
  name = name .. self.name
  for i,suffix in ipairs(self.suffixes) do
    if i == 1 then name = name .. ' of ' end
    name = name .. suffix
    if i < #self.suffixes then name = name .. ' and ' end
  end
  self.name = name
end

return weapon
