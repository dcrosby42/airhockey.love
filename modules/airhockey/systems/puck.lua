local Debug = require("mydebug").sub("Puck", false, false)
local inspect = require "inspect"

-- Puck update system.
-- Plays puck "hit" sound on physical contact.  A bit of contact-tracking
-- rigamarole is used to keep track of first-arrival of any given instance of a contact,
-- to avoid generating a cacophony of sfx.

-- !! CHEATING !! USING static module-level vars to track physics contact IDs for a limited
-- time in order to debounce/dedup sfx due to prolonged contact.

-- how long we keep track of physics contacts before forgetting about them
local TTL = 10
-- cache of contacts. map of contact id (based on cid) to time-of-initial-contact
local hist = {}
-- time. num seconds (decimal) overall gameplay time
local t = 0

-- Track initial contact time.
local function track(contact_id)
  hist[contact_id] = t
end

-- Return true if contact_is currenly being tracked
local function tracking(contact_id)
  return hist[contact_id] ~= nil
end

-- Remove any contacts from the hist cache if they've aged out based on TTL and initial contact time
local function cleanup()
  for id, tstamp in pairs(hist) do
    if t > (tstamp + TTL) then
      hist[id] = nil
    end
  end
end

return defineUpdateSystem(
  allOf(hasTag("puck"), hasComps("tr")),
  function(e, estore, input, res)
    -- Regularly update elapsed time since game start
    t = t + input.dt

    if e.contact then
      local hitE = estore:getEntity(e.contact.otherEid)
      if hitE.tags.goal then
        e:getParent():newEntity({
          { 'tag',   { name = 'goal_scored' } },
          { 'state', { name = 'winner', value = hitE.states.winner.value } },
        })
        estore:destroyEntity(e)
        Debug.println("GOAL! for " .. hitE.states.winner.value)
      else
        local contact_id = "contact_" .. e.contact.cid
        -- Only generate sound effect if we're NOT already tracking this physics contact:
        if not tracking(contact_id) then
          -- Make a sound
          e:newComp("sound", { name = contact_id, sound = "hit1" })
          -- track the contact
          track(contact_id) -- keep track of this contact

          Debug.println("contact!")
          Debug.println("  contact_id history size: " .. tcount(hist))
        end
        cleanup() -- stop tracking expired contacts
      end
    end
  end)
