import "rng" for MAP_RNG

var MAX_BSP_SIZE = 21
var MIN_BSP_SIZE = 7
var MIN_ROOM_SIZE = 5
var BSP_RATIO = (1 + 5.sqrt) / 2 //golden ratio


class Rect {
    construct new(x, y, w, h) {
        _x1 = x
        _x2 = x + w - 1
        _y1 = y
        _y2 = y + h - 1
    }

    x1 { _x1 }
    y1 { _y1 }
    x2 { _x2 }
    y2 { _y2 }
    width { _x2 - _x1 + 1}
    height { _y2 - _y1 + 1}
    
    intersect(other) {
        return !(x1 > other.x2 || x2 > other.x1 || y2 > other.y1 || y1 > other.y1)
    }

    toString { "Rect{x=%(_x1) y=%(_y1) x2=%(_x2) y2=%(y2)}"}

    iterate(idx) {
        if (idx == null) return [_x1, _y1]
        
        var x = idx[0]
        var y = idx[1]
        x = x + 1

        if (x >= width) {
            x = x1
            y = y+1
        } 

        if (y >= height) {
            return false
        }

        return [x, y]
    }

    iteratorValue(idx) { idx }
}

class BSPUtil {
    static moveAlong(x1, x2, y, cb) {
        var dx = x2 - x1
        var distX = dx.abs
        var incX = (distX == 0) ? 0 : dx / distX
        var x = x1
        while (x != x2) {
            cb.call(x, y)
            x = x + incX
        }
    }

    static moveAlongCorridor(x1, y1, x2, y2, cb) {
        var bendH = MAP_RNG.float() < 0.5
        var bendStop = 0

        if (bendH) {
            bendStop = MAP_RNG.int(y1, y2+1)
            BSPUtil.moveAlong(y1, bendStop, x1, cb)
            BSPUtil.moveAlong(bendStop, y2, x2, cb)
            BSPUtil.moveAlong(x1, x2, bendStop, cb)
        } else {
            bendStop = MAP_RNG.int(x1, x2+1)
            BSPUtil.moveAlong(x1, bendStop, y1, cb)
            BSPUtil.moveAlong(bendStop, x2, y2, cb)
            BSPUtil.moveAlong(y1, y2, bendStop, cb)
        }
    }

    static bspSplit(rootNode) {
        var results = [rootNode]
        var didSplit = true
        while (didSplit) {
            didSplit = false
            for (node in results) {
                if (node.isLeaf) {
                    if (node.shouldSplit || MAP_RNG.float() < 0.35) {
                        if (node.split()) {
                            results.add(node.left)
                            results.add(node.right)
                            didSplit = true
                        }
                    }
                }
            }
        }

        return results.count
    }

    static inOrder(rootNode, cb) {
        if (rootNode.left) {
            inOrder(rootNode.left, cb)
        }

        cb.call(rootNode)

        if (rootNode.right) {
            inOrder(rootNode.right, cb)
        }
    }

    static postOrder(rootNode, cb) {
        if (rootNode.left) {
            postOrder(rootNode.left, cb)
        }

        if (rootNode.right) {
            postOrder(rootNode.right, cb)
        }

        cb.call(rootNode)
    }

    static preOrder(rootNode, cb) {
        cb.call(rootNode)

        if (rootNode.left) {
            preOrder(rootNode.left, cb)
        }

        if (rootNode.right) {
            preOrder(rootNode.right, cb)
        }
    }

}

class BSPNode is Rect {
    construct new(x, y, w, h) {
        super(x, y, w, h)
        _left = null
        _right = null
        _room = null
        _path = []
        _link = null
    }

    path { _path }
    room { _room }
    left { _left }
    right { _right }

    split() {
        if (_left || _right) return false

        var splitH = MAP_RNG.float() < 0.5
        var w = width
        var h = height

        if (w > h && w/h > BSP_RATIO) {
            splitH = false
        } else if (h > w && h/w > BSP_RATIO) {
            splitH = true
        }

        var max = (splitH ? h : w) - MIN_BSP_SIZE
        if (max < MIN_BSP_SIZE) return false

        var s = MAP_RNG.int(MIN_BSP_SIZE, max+1)
        if (splitH) {
            _left = BSPNode.new(x1, y1, width, s)
            _right = BSPNode.new(x1, y1+s, width, height-s)
        } else {
            _left = BSPNode.new(x1, y1, s, height)
            _right = BSPNode.new(x1+s, y1, width-s, height)
        }

        return true
    }

    shouldSplit { width > MAX_BSP_SIZE || height > MAX_BSP_SIZE }
    isLeaf { !(_left || _right) }

    link {
        if (!_link) {
            if (_room) {
                var linkX = MAP_RNG.int(_room.x1, _room.x2+1)
                var linkY = MAP_RNG.int(_room.y1, _room.y2+1)
                _link = [linkX, linkY]
            } else {
                _link = MAP_RNG.sample(_path)
            }
        }

        return _link
    }

    makeRooms() {
        if (_left) {
            _left.makeRooms()
        }

        if (_right) {
            _right.makeRooms()
        }

        if (isLeaf) {
            var w = MAP_RNG.int(MIN_ROOM_SIZE, width - 1)
            var h = MAP_RNG.int(MIN_ROOM_SIZE, height - 1)
            var dx = MAP_RNG.int(1, width - w)
            var dy = MAP_RNG.int(1, height - h)
            _room = Rect.new(x1 + dx, y1 + dy, w, h)
        } else {
            if (_left.link && _right.link) {
                BSPUtil.moveAlongCorridor(_left.link[0], _left.link[1], _right.link[0], _right.link[1]) { |x, y| _path.add([x, y])}
            }
        }
    }

}