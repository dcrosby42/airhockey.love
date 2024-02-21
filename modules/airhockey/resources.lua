return {
  {
    type = "ecs",
    name = "main",
    data = {
      entities = { datafile = "modules/airhockey/entities.lua" },
      components = { datafile = "modules/airhockey/components.lua" },
      systems = { datafile = "modules/airhockey/systems.lua" },
      drawSystems = { datafile = "modules/airhockey/drawSystems.lua" },
    },
  },
  {
    type = "settings",
    name = "dev",
    data = { bgmusic = false },
  },
  {
    type = "pic",
    name = "puck_blue",
    data = { path = "modules/airhockey/images/airhockey_puck_blue.png" },
  },
  {
    type = "pic",
    name = "puck_red",
    data = { path = "modules/airhockey/images/airhockey_puck_red.png" },
  },
  {
    type = "pic",
    name = "rink1",
    data = { path = "modules/airhockey/images/rink1.png" },
  },
  {
    type = "pic",
    name = "mallet_blue",
    data = { path = "modules/airhockey/images/airhockey_mallet_blue.png" },
  },
  {
    type = "pic",
    name = "power_button",
    data = { path = "modules/common/images/power-button-outline.png" },
  },
  {
    type = "pic",
    name = "next_button",
    data = { path = "modules/common/images/skip-button-outline.png" },
  },
  {
    type = "pic",
    name = "debug_button",
    data = { path = "modules/common/images/downArrow_lineLight25.png" },
  },
  -- {
  --   type = "sound",
  --   name = "pig",
  --   data = {
  --     file = "modules/barnyard/sounds/pig.wav",
  --     type = "sound",
  --     volume = 0.5,
  --   },
  -- },
  -- {
  --   type = "font",
  --   name = "cartoon",
  --   data = {
  --     file = "modules/barnyard/fonts/LuckiestGuy.ttf",
  --     choices = {
  --       { name = "small",  size = 24 },
  --       { name = "medium", size = 48 },
  --     },
  --   },
  -- },
}
