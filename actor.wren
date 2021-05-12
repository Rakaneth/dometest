class Actor {
    construct new(spriteName) {
        _spriteName = spriteName
        _x = 0
        _y = 0
    }

    x { _x }
    y { _y }
    sprite { _spriteName }

    moveBy(dx, dy) {
        _x = _x + dx
        _y = _y + dy
    }

    moveTo(x, y) {
        _x = x
        _y = y
    }
}