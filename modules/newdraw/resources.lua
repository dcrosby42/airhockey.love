return {
  {
    type = "ecs",
    name = "main",
    data = {
      entities = { datafile = "modules/newdraw/entities.lua" },
      components = {
        data = {
        }
      },
      systems = { datafile = "modules/newdraw/systems.lua" },
      drawSystems = { datafile = "modules/newdraw/drawSystems.lua" },
      name = "Scenegraph Experiment",
    },
  },
  {
    type = "settings",
    name = "dev",
    data = { bgmusic = false },
  },
  {
    type = "pic",
    name = "tree",
    data = { path = "modules/newdraw/images/Tree2_85x110.png" },
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
  {
    type = "pic",
    name = "grid_white",
    data = { path = "modules/common/images/grid_white_100_20.png" },
  },
  {
    type = "pic",
    name = "grid_black",
    data = { path = "modules/common/images/grid_100_20.png" },
  },


  {
    type = "sound",
    name = "drop_puck1",
    data = {
      file = "modules/airhockey/sounds/drop_puck1.wav",
      type = "sound",
      volume = 1,
    },
  },
  {
    type = "sound",
    name = "drop_puck2",
    data = {
      file = "modules/airhockey/sounds/drop_puck2.wav",
      type = "sound",
      volume = 1,
    },
  },
  {
    type = "sound",
    name = "hit1",
    data = {
      file = "modules/airhockey/sounds/hit1.wav",
      type = "sound",
      volume = 1,
    },
  },
  {
    type = "sound",
    name = "score_goal",
    data = {
      file = "modules/airhockey/sounds/score_goal.wav",
      type = "sound",
      volume = 1,
    },
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
  {
    type = "font",
    name = "Adventure",
    data = {
      file = "modules/common/fonts/Adventure.ttf",
      choices = { 24, 48, 64 },
    },
  },
  {
    type = "font",
    name = "AdventureOutline",
    data = {
      file = "modules/common/fonts/Adventure_Outline.ttf",
      choices = { 24, 48, 64 },
    },
  },
  {
    type = "font",
    name = "GreatThings",
    data = {
      file = "modules/common/fonts/goingtodogreatthings.ttf",
      choices = { 24, 48, 64 },
    },
  },
  {
    type = "font",
    name = "Lucky",
    data = {
      file = "modules/common/fonts/LuckiestGuy.ttf",
      choices = { 24, 48, 64 },
    },
  },
  {
    type = "font",
    name = "narpassword",
    data = {
      file = "modules/common/fonts/narpassword.ttf",
      choices = { 24, 48, 64 },
    },
  },
}
