import "grid" for Grid
import "rng" for MAP_RNG
import "bsp" for BSPNode, BSPUtil

class Tile {
    construct new(gfx, see, walk) {
        _gfx = gfx
        _see = see
        _walk = walk
    }

    gfx { _gfx }
    isTransparent { _see }
    isWalkable { _walk }
}

var NULL_TILE = Tile.new(null, false, false)
var WALL_UL = Tile.new("wall-ul", false, false)
var WALL_HORZ = Tile.new("wall-horz", false, false)
var WALL_UR = Tile.new("wall-ur", false, false)
var WALL_VERT_L = Tile.new("wall-vert-l", false, false)
var WALL_VERT_R = Tile.new("wall-vert-r", false, false)
var WALL_LL = Tile.new("wall-ll", false, false)
var WALL_LR = Tile.new("wall-lr", false, false)
var FLOOR = Tile.new("floor-empty", true, true)
var MAP_RNG = Random.new()

class GameMap is Grid {
    construct new(width, height, id, name, dark) {
        super(width, height)
        _id = id
        _name = name
        _dark = dark
    }

    id { _id }
    name { _name }
    dark { _dark }

    isWall(x, y) {
        var t = this[x, y]
        return t && t.gfx.contains("wall")
    }

    isFloor(x, y) {
        var t = this[x, y]
        return t && t.gfx.contains("floor")
    }
}

class MapBuilder {
    
    //0 = floor, 1 = wall
    static bsp(width, height, id, name, dark) {
        var grid = Grid.new(width, height, 1)
        var root = BSPNode.new(1, 1, width-2, height-2)
        BSPUtil.bspSplit(root)
        root.makeRooms()
        BSPUtil.inOrder(root) { |node|
            if (node.room) {
                for (rpt in node.room) {
                    var rx = rpt[0]
                    var ry = rpt[1]
                    grid.set(rx, ry, 0)
                }
            } else if (node.path) {
                for (ppt in node.path) {
                    var px = ppt[0]
                    var py = ppt[1]
                    grid.set(px, py, 0)
                }
            }
        }

        var wallNum = Fn.new {|x, y|
            
        }

        
    }
}