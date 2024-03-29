return {
  {
    type = "ecs",
    name = "main",
    data = {
      name = "Anim Scratch",
      entities = { datafile = "modules/girl/entities.lua" },
      components = {
        data = {
        }
      },
      -- systems = { datafile = "modules/girl/systems.lua" },
      systems = {
        data = {
          "castle.systems.timer",
          "castle.systems.selfdestruct",
          "castle.systems.physics",
          "castle.systems.sound",
          -- "modukes.girl.systems.devsystem",
        }
      },
      -- drawSystems = { datafile = "modules/girl/drawSystems.lua" },
      drawSystems = {
        data = {
          "castle.drawing.bgcolor_system",
          "castle.drawing.scenegraph_system",
        }
      },
    },
  },
  {
    type = "pic",
    name = "tree",
    data = {
      path = "modules/newdraw/images/Tree2_85x110.png"
    },
  },
  {
    type = "pic",
    name = "girl3",
    data = {
      path = "modules/girl/images/Sun_girl_animation-3.png",
      sx = 0.5,
      sy = 0.5,
    },
  },
  {
    type = "anim",
    name = "sungirl_run",
    data = {
      path_prefix = "modules/girl/images/",
      frame_duration = 1 / 8,
      sx = 0.3,
      sy = 0.3,
      pics = {
        {
          path = "Sun_girl_animation-3.png",
        },
        {
          path = "Sun_girl_animation-4.png",
        },
        {
          path = "Sun_girl_animation-5.png",
        },
        {
          path = "Sun_girl_animation-6.png",
        },
      }
    }
  },
  {
    type = "anim",
    name = "sungirl_stand",
    data = {
      path_prefix = "modules/girl/images/",
      sx = 0.5,
      sy = 0.5,
      pics = {
        {
          path = "Sun_girl_animation-2.png",
          duration = 5,
        },
        {
          path = "Sun_girl_animation-1.png",
          duration = 0.2,
        },
      }
    }
  }

  -- "Sun_girl_animation-3",
  -- "Sun_girl_animation-4",
  -- "Sun_girl_animation-5",
  -- "Sun_girl_animation-6",
}
