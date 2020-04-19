return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "2020.04.10",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 48,
  height = 61,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 6,
  nextobjectid = 18,
  properties = {
    ["darkness"] = 0.59999999999999998
  },
  tilesets = {
    {
      name = "MyTileset",
      firstgid = 1,
      filename = "MyTileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 0,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 7,
      tiles = {
        {
          id = 1,
          image = "wall old.png",
          width = 32,
          height = 32
        },
        {
          id = 3,
          image = "prototype_wall.png",
          width = 32,
          height = 32
        },
        {
          id = 4,
          image = "wall black.png",
          width = 32,
          height = 32
        },
        {
          id = 9,
          image = "blueDark1.png",
          width = 32,
          height = 32,
          probability = 0.2
        },
        {
          id = 10,
          image = "blueDark2.png",
          width = 32,
          height = 32
        },
        {
          id = 11,
          image = "blueDark3.png",
          width = 32,
          height = 32
        },
        {
          id = 12,
          image = "Hot_tile.png",
          width = 32,
          height = 32
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 48,
      height = 61,
      id = 2,
      name = "Background",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zstd",
      data = "KLUv/WDALLUSANLHCYsQAAAAACNJc02mtZZVZ7KdVKk3pcumWtbLmpzlJskyLVMABBCABIGEqOH6/gChBcYoqZkBEsATBDBBBBKEQCFmhYyKrFIpLRQEvQC9hfNCcolzi/dB2dMxa93yetN87E3V4tXnJ8+S48ymgvzxcZB83Ru+W8LmJGy1juXII9AjwECYZcRuzyS4cT6OoX3lP4Lvw43KrU+OJ47b5qmm44vCrMqPGE4649P561rG8n6n+Q3FrPyz+3FehZH421Z33m9MrXLLEeIvUnNUeiXjFYhdqT42vN373AexmLvu+FWYeHA6hFmN+3bzpMx9Sc25qx0DubK+7uIvDy7z/fwm7r5PqDdp27HDPNkex5yf9552xkr1yKyGD+k3jonBkw5mYB3SZtOdvwTPUVo7jyL2zOtHRcMwFk6QnsvXkJPTnnEi82jnd7BE7dgf8EsVvsHf1HrfrQxH8m92ZdAyZDP4bOvmg/s1/dC3oa1gfIr+1GXHS/SQse8dPfNcGJrwfH+vf9I2oI8Aj+GJcV1iwB5udnSGO+lef638+IL3GXnyDYk/UA0v4yk+p9dlvJn+wfez+YTJAHLU94+cmpXcdHjAvx/2ah8JW9XRc7JzsPrkAAOf0DibFkemEfCslAX0kSMWM85jw7X0YoKR3CO06xrupUbv0wy4Q4eGE7wxJi5hDygnG8DZ4jlifytgN9Fnfe59cHxOG54eSB0nzm4fhT2tdrh5WSDjhfbapf+yGVz+fLInuQ7Wu9N0Hsfvlkl9ptX9ZX1iNNHoxpUfcx1/NJ89eaj/3h8="
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 48,
      height = 61,
      id = 1,
      name = "Front",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zstd",
      data = "KLUv/WDALD0CADgEAAAADQQNHaDQXQNww5XCcgEoeNlM08tc/AOkShF/SYP6F+JHWp5aCVLFP9Ka+rsW1cpsFbxDLD0Kglkb9oNKeyYiYAal"
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "Walls",
      visible = false,
      opacity = 0.75,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 0,
          width = 224,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 416,
          y = 512,
          width = 192,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 448,
          y = 544,
          width = 160,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 704,
          width = 128,
          height = 960,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 1888,
          width = 320,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 160,
          height = 1952,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 0,
          width = 96,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 512,
          width = 64,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 576,
          width = 32,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "Hazards",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 352,
          y = 800,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 1024,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 352,
          y = 1248,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 1920,
          width = 320,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "PlayerObjects",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 4,
          name = "player_spawn",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 0,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
