import "./grid" for Grid
import "./rng" for MAP_RNG
import "./bitflags" for BitFlags

var TILE_NULL = -1
var FLOOR = 0
var WALL = 1
var WALL_HORZ = 3       //00000011
var WALL_W_VERT = 5     //00000101
var WALL_E_VERT = 9     //00001001
var WALL_UL = 17        //00010001
var WALL_UR = 33        //00100001
var WALL_LL = 65        //01000001
var WALL_LR = 129       //10000001


class GameMap is Grid {
    construct new(w, h, lit, name, id) {
        super(w, h, WALL)
        _lit = lit
        _name = name
        _id = id
        _floors = Grid.new(w, h, false)
        _rooms = []
        _explored = Grid.new(w, h, false)
    }

    name { _name }
    id { _id }
    lit { _lit }

    isWall(x, y) { inBounds(x, y) && BitFlags.hasFlag(this[x, y], WALL) }
    
    isSurrounded(x, y) { 
        return !inBounds(x, y) || neighbors(x, y).all {|nei|
            var nx = nei[0]
            var ny = nei[1]
            return !inBounds(nx, ny) || isWall(nx, ny)
        }
    }

    isExplored(x, y) { _explored[x, y] }
    explore(x, y) { _explored[x, y] = true }

    setTile(x, y, tileType) {
        this[x, y] = tileType
        _floors[x, y] = (tileType == 0)
    }

    









}