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
  nextlayerid = 11,
  nextobjectid = 112,
  properties = {
    ["darkness"] = 0.10000000000000001
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
      data = "KLUv/WDALG0MAMQCBAAAAAQEBAQEBAQEBAQEBAQEBAQEBA0NAAQEBAQADQQEBA0EDQQEBAQEBA2A86igTQDgAg1QBQASIBGYCDSCBCloIAKdQCaYhFIABcYwhA3dAJXM4SJpn8etUKgAImZC+4jSdnZYw2GYBBdMoudboEzQlBk0RDfPf7SEDEyQVeou1s4nZG2W/9P8yOyRP6wOwyfM7wF9cv+8G44NIPyE8nuAn9yf74ZjQ4zC0Htg5y2FB6xlwLpPz57CML1dd2CC/jH4hYz1YazXAEq1z0gMs+9JTsDU8x3sKGlJrtLrQeio3JvIPEwYz94LMeOyuAVCyjAB1wA5lIo4IEc5+oiPP/g4/IKuQHbR4SGV/+Hgod8JdKTyXMzxcZRakEj2pGK4RD7nN3XFHrqN38+OnoI2e1gjGx2ggzyJPIk/NBM3HxXnO3QWb586egv6Kw/r+C5c9PbCOt8LJ724GJf/xUivF67nuHDi2wvrfC+c9OJiXP4XI72+OJPPxZPeYsWGFlqLdSgxnQWwzhoMzD4="
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 9,
      name = "Collectables",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 109,
          name = "super_speed",
          type = "",
          shape = "rectangle",
          x = 1440,
          y = 992,
          width = 32,
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
      id = 7,
      name = "FragilePlatforms",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 92,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 1856,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 93,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1152,
          y = 1696,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 94,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 1536,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 95,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1152,
          y = 1376,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 96,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 1216,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 97,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1152,
          y = 1120,
          width = 128,
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
      id = 3,
      name = "Walls",
      visible = true,
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
          width = 448,
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
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 928,
          y = 768,
          width = 160,
          height = 1184,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 768,
          y = 1440,
          width = 160,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 704,
          y = 1248,
          width = 96,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 1088,
          width = 96,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 960,
          width = 96,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 608,
          y = 1568,
          width = 96,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 1856,
          width = 288,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 1824,
          width = 96,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 736,
          y = 1792,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 27,
          name = "",
          type = "",
          shape = "rectangle",
          x = 768,
          y = 1728,
          width = 160,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 44,
          name = "",
          type = "",
          shape = "rectangle",
          x = 608,
          y = 576,
          width = 64,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 46,
          name = "",
          type = "",
          shape = "rectangle",
          x = 608,
          y = 0,
          width = 352,
          height = 576,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 50,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1056,
          y = 96,
          width = 128,
          height = 640,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 51,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1024,
          y = 672,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 55,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 832,
          width = 96,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 60,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 0,
          width = 416,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 61,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 0,
          width = 160,
          height = 96,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 192,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1024,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 65,
          name = "",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 512,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 66,
          name = "",
          type = "",
          shape = "rectangle",
          x = 928,
          y = 704,
          width = 32,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 67,
          name = "",
          type = "",
          shape = "rectangle",
          x = 896,
          y = 768,
          width = 32,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 68,
          name = "",
          type = "",
          shape = "rectangle",
          x = 864,
          y = 800,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 76,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1056,
          y = 736,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 77,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1184,
          y = 640,
          width = 288,
          height = 96,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 78,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 608,
          width = 96,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 79,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 320,
          width = 160,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 80,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1408,
          y = 96,
          width = 128,
          height = 224,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 81,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1184,
          y = 96,
          width = 32,
          height = 192,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 84,
          name = "",
          type = "",
          shape = "rectangle",
          x = 896,
          y = 1696,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 85,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1440,
          y = 736,
          width = 32,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 86,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1504,
          y = 480,
          width = 32,
          height = 480,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 87,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 928,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 88,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1376,
          y = 832,
          width = 32,
          height = 96,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 89,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 832,
          width = 256,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 90,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1120,
          y = 864,
          width = 32,
          height = 1024,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 91,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 1920,
          width = 448,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 99,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1504,
          y = 1056,
          width = 32,
          height = 864,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 100,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1312,
          y = 1024,
          width = 224,
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
      id = 10,
      name = "EventTriggers",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 110,
          name = "trigger_next_level2",
          type = "",
          shape = "rectangle",
          x = 1536,
          y = 960,
          width = 192,
          height = 64,
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
      visible = true,
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
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "rectangle",
          x = 896,
          y = 832,
          width = 32,
          height = 608,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 32,
          name = "",
          type = "",
          shape = "rectangle",
          x = 896,
          y = 1504,
          width = 32,
          height = 192,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 33,
          name = "",
          type = "",
          shape = "rectangle",
          x = 608,
          y = 608,
          width = 32,
          height = 960,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 56,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 608,
          width = 64,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 57,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 576,
          width = 288,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 83,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 1568,
          width = 160,
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
      id = 6,
      name = "AutoMovingPlatforms",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 1424,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 864,
            ["ey"] = 1424,
            ["isDeadly"] = true,
            ["speed"] = 130,
            ["sx"] = 640,
            ["sy"] = 1424
          }
        },
        {
          id = 40,
          name = "",
          type = "",
          shape = "rectangle",
          x = 864,
          y = 944,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 864,
            ["ey"] = 944,
            ["isDeadly"] = true,
            ["speed"] = 130,
            ["sx"] = 640,
            ["sy"] = 944
          }
        },
        {
          id = 41,
          name = "",
          type = "",
          shape = "rectangle",
          x = 704,
          y = 1072,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 864,
            ["ey"] = 1072,
            ["isDeadly"] = true,
            ["speed"] = 130,
            ["sx"] = 640,
            ["sy"] = 1072
          }
        },
        {
          id = 42,
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 1232,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 864,
            ["ey"] = 1232,
            ["isDeadly"] = true,
            ["speed"] = 130,
            ["sx"] = 640,
            ["sy"] = 1232
          }
        },
        {
          id = 59,
          name = "",
          type = "",
          shape = "rectangle",
          x = 992,
          y = 32,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 992,
            ["ey"] = 736,
            ["isDeadly"] = true,
            ["speed"] = 500,
            ["sx"] = 992,
            ["sy"] = 32
          }
        },
        {
          id = 72,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1216,
          y = 0,
          width = 160,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 1216,
            ["ey"] = 128,
            ["isDeadly"] = true,
            ["speed"] = 100,
            ["sx"] = 1216,
            ["sy"] = 0
          }
        },
        {
          id = 73,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1216,
          y = 160,
          width = 160,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 1216,
            ["ey"] = 288,
            ["isDeadly"] = true,
            ["speed"] = 100,
            ["sx"] = 1216,
            ["sy"] = 160
          }
        },
        {
          id = 74,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1216,
          y = 320,
          width = 160,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 1216,
            ["ey"] = 448,
            ["isDeadly"] = true,
            ["speed"] = 100,
            ["sx"] = 1216,
            ["sy"] = 320
          }
        },
        {
          id = 75,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1216,
          y = 480,
          width = 160,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 1216,
            ["ey"] = 608,
            ["isDeadly"] = true,
            ["speed"] = 100,
            ["sx"] = 1216,
            ["sy"] = 480
          }
        },
        {
          id = 102,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 1888,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 1280,
            ["ey"] = 1888,
            ["isDeadly"] = true,
            ["speed"] = 500,
            ["sx"] = 1280,
            ["sy"] = 1056
          }
        },
        {
          id = 103,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1344,
          y = 1056,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["ex"] = 1344,
            ["ey"] = 1888,
            ["isDeadly"] = true,
            ["speed"] = 500,
            ["sx"] = 1344,
            ["sy"] = 1056
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 8,
      name = "Trampolines",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 104,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1472,
          y = 896,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["directionX"] = -1,
            ["directionY"] = 0
          }
        },
        {
          id = 105,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1408,
          y = 896,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["directionX"] = 0,
            ["directionY"] = -1
          }
        },
        {
          id = 106,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1408,
          y = 800,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["directionX"] = -1,
            ["directionY"] = 0
          }
        },
        {
          id = 107,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 1888,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["directionX"] = 1,
            ["directionY"] = 0
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "PlayerObjects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 36,
          name = "player_checkpoint",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 1792,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 70,
          name = "player_checkpoint",
          type = "",
          shape = "rectangle",
          x = 864,
          y = 768,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 71,
          name = "player_checkpoint",
          type = "",
          shape = "rectangle",
          x = 1088,
          y = 64,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 98,
          name = "player_spawn",
          type = "",
          shape = "rectangle",
          x = 1312,
          y = 864,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 108,
          name = "player_checkpoint",
          type = "",
          shape = "rectangle",
          x = 1184,
          y = 1888,
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
