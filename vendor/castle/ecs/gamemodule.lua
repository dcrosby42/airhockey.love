local ResourceLoader = require "castle.resourceloader"
local EcsAdapter = require "castle.ecs.moduleadapter"

local GameModule = {}

function GameModule.newFromConfigs(configs, loaders)
  loaders = loaders or require('castle/ecs/loaders')
  local res = ResourceLoader.buildResourceRoot(configs, loaders)
  return EcsAdapter({
    create = res.ecs.main.entities.initialEntities,
    update = res.ecs.main.update,
    draw = res.ecs.main.draw,
    loadResources = function()
      return res
    end,
  })
end

function GameModule.newFromFile(path, loaders)

  local configs = ResourceLoader.loadfile(path)()
  return GameModule.newFromConfigs(configs, loaders)
end

return GameModule
