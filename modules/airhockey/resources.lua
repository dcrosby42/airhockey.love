return {
  {
    type = "ecs",
    name = "main",
    data = {
      entities = { datafile = "modules/airhockey/entities.lua" },
      components = {
        -- datafile = "modules/airhockey/components.lua",
        data = {
          -- animalspawner = {'kind', ''},
        }
      },
      systems = {
        data = {
          "castle.systems.timer",
          "castle.systems.selfdestruct",
          "castle.systems.physics",
          "castle.systems.sound",
          "castle.systems.touchbutton",
          "modules.airhockey.systems.devsystem",
          "modules.airhockey.systems.touch",
          "modules.airhockey.systems.mallet_reset",
          "modules.airhockey.systems.puck_reset",
          "modules.airhockey.systems.mallet",
          "modules.airhockey.systems.puck",
          "modules.airhockey.systems.goal_scored",
        }
      },
      drawSystems = {
        data = {
          "castle.drawing.scenegraph_system",
        }
      },
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
    name = "mallet_icon",
    data = { path = "modules/airhockey/images/mallet-icon-white.png" },
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

  {
    type = "sound",
    name = "drop_puck1",
    data = { file = "modules/airhockey/sounds/drop_puck1.wav", },
  },
  {
    type = "sound",
    name = "drop_puck2",
    data = { file = "modules/airhockey/sounds/drop_puck2.wav", },
  },
  {
    type = "sound",
    name = "hit1",
    data = { file = "modules/airhockey/sounds/hit1.wav", },
  },
  {
    type = "sound",
    name = "score_goal",
    data = { file = "modules/airhockey/sounds/score_goal.wav", },
  },
  {
    type = "music",
    name = "city",
    data = { file = "modules/airhockey/sounds/welcome-to-city.mp3", },
  },
  {
    type = "sound",
    name = "enterprise",
    data = { file = "modules/airhockey/sounds/tng_hum_clean.mp3", },
  },
  {
    type = "font",
    name = "alarm_clock",
    data = {
      file = "modules/airhockey/fonts/alarm_clock.ttf",
      choices = {
        { name = "small",  size = 24 },
        { name = "medium", size = 64 },
      },
    },
  },
  -- {
  --   type = "sound",
  --   name = "drop_puck1",
  --   music = false,
  --   data = {
  --     file = "modules/airhockey/sounds/drop_puck1.wav",
  --     music = false,
  --     type = "sound",
  --     volume = 1,
  --   },
  -- },
  -- {
  --   type = "music",
  --   name = "city",
  --   music = true,
  --   data = {
  --     file = "modules/airhockey/sounds/welcome-to-city.mp3",
  --     music = true,
  --     type = "music",
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
