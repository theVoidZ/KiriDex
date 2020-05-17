return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "2020.04.10",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 11,
  height = 10,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {
    ["description"] = "Hmmm"
  },
  tilesets = {
    {
      name = "Walls baba is you",
      firstgid = 1,
      filename = "../Walls baba is you.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 18,
      image = "../Walls baba is you-sheet.png",
      imagewidth = 576,
      imageheight = 32,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 18,
      tiles = {
        {
          id = 0,
          type = "floor"
        },
        {
          id = 1,
          type = "wall"
        },
        {
          id = 2,
          type = "player"
        },
        {
          id = 3,
          type = "enemy1r"
        },
        {
          id = 4,
          type = "enemy1d"
        },
        {
          id = 5,
          type = "enemy1l"
        },
        {
          id = 6,
          type = "enemy1u"
        },
        {
          id = 7,
          type = "spike"
        },
        {
          id = 8,
          type = "cake"
        },
        {
          id = 9,
          type = "key"
        },
        {
          id = 10,
          type = "door"
        },
        {
          id = 11,
          type = "box"
        },
        {
          id = 12,
          type = "enemy2u"
        },
        {
          id = 13,
          type = "enemy2r"
        },
        {
          id = 14,
          type = "enemy2d"
        },
        {
          id = 15,
          type = "enemy2l"
        },
        {
          id = 16,
          type = "portalblue"
        },
        {
          id = 17,
          type = "portalorange"
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 11,
      height = 10,
      id = 1,
      name = "Walls",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 12, 10, 1, 17, 2, 1, 1, 14, 10, 2,
        2, 1, 12, 12, 1, 2, 1, 7, 7, 1, 2,
        2, 1, 1, 12, 3, 2, 1, 7, 5, 1, 2,
        2, 12, 1, 1, 12, 2, 13, 8, 8, 1, 2,
        2, 1, 12, 12, 1, 2, 1, 8, 8, 1, 2,
        2, 12, 12, 11, 1, 2, 1, 5, 7, 15, 2,
        2, 2, 2, 8, 2, 2, 1, 5, 5, 1, 2,
        2, 9, 11, 8, 8, 2, 13, 1, 1, 18, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
      }
    }
  }
}
