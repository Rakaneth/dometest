class Grid {
    construct new(width, height, initValue) {
        _width = width
        _height = height
        _items = List.filled(width * height, initValue)
        _neiHelper = Fn.new { |l|
            var results = []
            for (cand in l) {
                if (inBounds(cand[0], cand[1])) {
                    results.add(cand)
                }
            }

            return results
        }
    }

    construct new(width, height) {
        _width = width
        _height = height
        _items = List.filled(width * height, null)
        _neiHelper = Fn.new { |l|
            var results = []
            for (cand in l) {
                if (inBounds(cand[0], cand[1])) {
                    results.add(cand)
                }
            }
            return results
        }
    }

    width { _width }
    height { _height }
    items { _items }

    inBounds(x, y) {
        if (x < 0 || y < 0) return false
        return x < _width && y < _height
    }

    index(x, y) { y * _width + x }

    deIndex(idx) { 
        var x = idx % _width
        var y = (idx / _width).floor
        return [x, y]
    }

    [x, y] {
        if (inBounds(x, y)) {
            var idx = index(x, y)
            return _items[idx]
        }

        return null
    }

    [x, y]=(value) {
        if (inBounds(x, y)) {
            var idx = index(x, y)
            _items[idx] = value
        }
    }

    neighbors(x, y) {
        var cands = [
            [x, y-1],
            [x+1, y],
            [x, y+1],
            [x-1, y]
        ]

        return _neiHelper.call(cands)
    }

    neighbors8(x, y) {
        var cands = [
            [x, y-1],
            [x+1, y-1],
            [x+1, y],
            [x+1, y+1],
            [x, y+1],
            [x-1, y+1],
            [x-1, y],
            [x-1, y-1]
        ]

        return _neiHelper.call(cands)
    }

    eachNeighbor8(x, y, cb) {
        var cands = [
            [x, y-1],
            [x+1, y-1],
            [x+1, y],
            [x+1, y+1],
            [x, y+1],
            [x-1, y+1],
            [x-1, y],
            [x-1, y-1]
        ]

        cands.each {|cand|
            var cx = cand[0] 
            var cy = cand[1]
            cb.call(cx, cy, this[cx, cy])
        }
    }

    eachNeighbor(x, y, cb) {
        var cands = [
            [x, y-1],
            [x+1, y],
            [x, y+1],
            [x-1, y]
        ]

        cands.each {|cand|
            var cx = cand[0] 
            var cy = cand[1]
            cb.call(cx, cy, this[cx, cy])
        }
    }

    mapNeighbor(x, y, cb) {
        var cands = [
            [x, y-1],
            [x+1, y],
            [x, y+1],
            [x-1, y]
        ]

        return cands.map {|cand|
            var cx = cand[0]
            var cy = cand[1]
            return cb.call(cx, cy, this[cx, cy])
        }
    }

    mapNeighbor8(x, y, cb) {
        var cands = [
            [x, y-1],
            [x+1, y-1],
            [x+1, y],
            [x+1, y+1],
            [x, y+1],
            [x-1, y+1],
            [x-1, y],
            [x-1, y-1]
        ]

        return cands.map {|cand|
            var cx = cand[0] 
            var cy = cand[1]
            return cb.call(cx, cy, this[cx, cy])
        }
    }

    iterate(idx) {
        if (idx == null) {
            return 0
        }

        if (idx < _width * _height - 1) {
            return idx + 1
        }

        return false
    }

    iteratorValue(idx) { _items[idx] }

    floodFilled(x, y, value) {
        if (this[x, y] != value) return []
        var results = [[x, y]]
        var frontier = [[x, y]]
        var sIdx = index(x, y)
        var visited = {}
        visited[sIdx] = true

        while (frontier.count > 0) {
            var pt = frontier.removeAt(0)
            var px = pt[0]
            var py = pt[1]
            for (neibor in neighbors(px, py)) {
                var nx = neibor[0]
                var ny = neibor[1]
                var nIdx = index(nx, ny)
                if (!visited.containsKey(nIdx)) {
                    if (this[nx, ny] == value) {
                        results.add(neibor)
                    }
                    visited[nIdx] = true
                    frontier.add(neibor)
                }
            }
        }

        return results
    }    
}