return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "2020.04.10",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 150,
  height = 32,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 11,
  nextobjectid = 124,
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
      width = 150,
      height = 32,
      id = 2,
      name = "Background",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zstd",
      data = "KLUv/WAASk0XAALLDIsQAAAAABMrJ+2CMrlTOb3kO9mkmWRkSetS59JLMqY+6WBDEkpWpU0taybbTNMSgAACoIG7qKF2+gFBBVJBqUANEkATJChBxhPkQCGHIlNRTRIyyPuVHLcY/8xev8ijfsitDKWpb1Ur4biVDqnbaW+g6/Cwn+6esXbrV3sqmX2DsOf6BZ3VftPKdIrTKilq+tH3ArfhQcPvl/W5jLTpsHQJTDpbPDLADqXdmcHsDj547piskoWLGobsbs5b/gUs1zcGX3BLWn+u2lfiYlsNntyWIIZ1Ydcn9IXSpQvtlfC+w4XfP4gVZt+oglNs+f2s/+5UQnRnmhN0wuxynnDOayl1/r5HMs5IVRLxmByJZfuoXT7KqRz85A/p9Gb2r6ES4xuWNNo9VP8JddSOwe+QC33QdfLstBLSlbJfo/TIVyisW/uuev6n07uT12ElCIubxh/ZrPxWpsg9DoeJBwbDoe99cgn16csH1nh+AMznPMUw3jcxjc9ru1SVHFUM/XttivoK9e9viGwIv4JXErFO6F3F9f/+2j5h+cvevQGxplA2lPaX5N1j4zdsXojuWFwoG/eyYnivEuoaXkLtSh60pxNc/M2ztj8g1l2USsK3g5gAeyVx0Og7G8bFbW7+V4ucduwVOTvmfGUQ1zmYuY6z/NbKS04yO+3xXrkv3gGaAwjV/nVZp6UqYfQUHIxKQ0WnZP2+YZozVN7FZ3SuLrNLeF90xBmc8cl/qD389bdwsssq7BIOnwSd7mr9JVfrbl74rbvbc+wSsCj7lNUj+MGXazsPc57nOHHcVMkcl+EafGCAgZc6ugQAfjGYbtxtVjIeYCfp8D2DnzG88//h2yLLQ99jlZCuzC2A3fZhrTXwegsqTE9uz1eHKmF71xRn3LCTbVLc+6uEq3oWqIT6d/Fhvyz7fCzb961jmvG3/0KrkvRFFU7xe77c83hDfnrO9/C+EtBwnu93GoGm/LAeckjBSEg/pekN4gc="
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 150,
      height = 32,
      id = 1,
      name = "Front",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zstd",
      data = "KLUv/WAASqUEAFQCAAAEBAQEBAQEBAQEBAQEBAQEBAQEDQQNBA0EDQQNBA0EDQQNBD6o4Dwgg26WABH8/98QPEYVgCjAK2NNcTA5HATHYSUGguYxmAwGAsexkgewD3cS/XF4w893Mch78Atom4Zn6Ew3BrkH/gDt6fDGc7u4WvKYJcC7aAT8jDbAzugH2Bl9gJ3RBtgZ/QA79V6pwg8="
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 9,
      name = "Collectables",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "FragilePlatforms",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
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
          id = 114,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 512,
          width = 1056,
          height = 224,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 115,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 864,
          width = 256,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 116,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 864,
          width = 384,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 117,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3424,
          y = 864,
          width = 608,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 118,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2432,
          y = 864,
          width = 576,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 119,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1472,
          y = 864,
          width = 544,
          height = 160,
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
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
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
          id = 120,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 960,
          width = 416,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 121,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1056,
          y = 960,
          width = 416,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 122,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2016,
          y = 960,
          width = 416,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 123,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3008,
          y = 960,
          width = 416,
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
      id = 6,
      name = "AutoMovingPlatforms",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 8,
      name = "Trampolines",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {}
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
          id = 112,
          name = "player_spawn",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 832,
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
