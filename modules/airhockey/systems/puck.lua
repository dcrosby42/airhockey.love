local Debug = require("mydebug").sub("Puck", false, false)
local inspect = require "inspect"

-- CHEATING! USING "file state" to track physics contact IDs for a limited
-- time in order to debounce/dedup sfx due to prolonged contact.

local TTL = 10
local hist = {}
local t = 0

local function track(contact_id)
  hist[contact_id] = t
end

local function tracking(contact_id)
  return hist[contact_id] ~= nil
end

local function cleanup()
  for id, tstamp in pairs(hist) do
    if t > (tstamp + TTL) then
      hist[id] = nil
    end
  end
end

return defineUpdateSystem(
  allOf(hasTag("puck"), hasComps("pos")),
  function(e, estore, input, res)
    t = t + input.dt -- accumulate time passing
    if e.contact then
      -- don't add sound if we already made noise for a given contact id
      local contact_id = "contact_" .. e.contact.cid
      if not tracking(contact_id) then
        e:newComp("sound", { name = contact_id, sound = "hit1" })
        track(contact_id) -- keep track of this contact
        Debug.println("contact_id history size: " .. tcount(hist))
      end
      cleanup() -- remove old contact ids
    end
  end)
