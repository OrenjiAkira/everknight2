
local audio = basic.prototype:new {
  __type = 'audio'
}

function audio:__init ()
  self.SE = {
    Die = module.sfx:new { 'Die.wav' },
    Get = module.sfx:new { 'Get.wav' },
    Grow = module.sfx:new { 'Grow.wav' },
    Heal = module.sfx:new { 'Heal.wav' },
    Hit = module.sfx:new { 'Hit.wav' },
    Hurt = module.sfx:new { 'Hurt.wav' },
    Ok = module.sfx:new { 'Ok.wav' },
    Slash = module.sfx:new { 'Slash.wav' },
  }
end

function audio:playSFX (name)
  self.SE[name]:play()
end

function audio:silent ()
  love.audio.stop()
end

return audio:new {}
