local SoundCanvas = require("castle.soundcanvas")
local inspect = require("inspect")

local sndCanvas = SoundCanvas.default

local Debug = require "mydebug"
Debug = Debug.sub("SoundManager", false, false)

local DrawSound = {}

-- This module can be used in a couple ways:
-- 1. As a "regular" drawSystem, by virtue of the returned drawSystem property being set to a 
--    shared default sound space.
-- 2. As a constructor for isolated sound space.  Users import this module and create their own
--    instance, eg, DrawSound.new("qbert")

-- 'sound' comp: {loop=false, state='playing',volume=1,pitch=1,playtime=0,duration=''}
-- soundConfig: {  (from Resources)
--     file="data/sounds/music/Into-Battle_v001.mp3",
--     mode="stream",
--     source={love.audio.Source}
--     data=love.sound.newSoundData(file),
--     volume=0.6,
--     duration=0.2 -- either configured or calc'd
--   }
-- Source https://love2d.org/wiki/Source
--

function DrawSound.new(prefix)
  return defineDrawSystem({"sound"}, function(e, estore, res)
    -- For each sound component in this entity:
    for _, soundComp in pairs(e.sounds) do
      local key = prefix .. "." .. soundComp.sound .. "." .. soundComp.cid
      local soundConfig = res.sounds[soundComp.sound]
      assert(soundConfig, "No sound configured for '" .. soundComp.sound ..
                 "', in sound Component of Entity: " .. entityDebugString(e))
      local soundState = {
        playState = soundComp.state,
        volume = soundComp.volume,
        pitch = soundComp.pitch,
        playTime = soundComp.playtime,
        duration = soundComp.duration,
        isLooping = soundComp.loop,
      }
      sndCanvas:drawSound(key, soundConfig, soundState)
    end -- end for-each sound component
  end -- end handler
  ) -- end system
end -- end "new"

return {new = DrawSound.new, drawSystem = DrawSound.new("default")}
