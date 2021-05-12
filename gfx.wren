import "graphics" for ImageData, Canvas
import "bsp" for Rect

var SPRITESHEET = ImageData.loadFromFile("colored_tilemap.png")
var PIXEL_SIZE = 8

class SpriteData {
     static tagList {[
        "wall-ul",
        "wall-horz",
        "wall-small-entrance",
        "wall-ur",
        "char-person",
        "char-armored",
        "char-flex",
        "char-dress",
        "char-golem",
        "char-undead",
        "wall-vert-l",
        "floor-empty",
        "floor-plate",
        "wall-vert-r",
        "char-snake",
        "char-dog",
        "char-rat",
        "char-crab",
        "char-fish",
        "char-ray",
        "wall-ll",
        "wall-horz-hole",
        "wall-large-entrance",
        "wall-lr",
        "door-closed",
        "door-open",
        "obj-ladder",
        "obj-clay-pot",
        "obj-iron-pot",
        "obj-small-pot",
        "wall-entrance-r",
        "wall-entrance-l",
        "exit-l",
        "exit-r",
        "stairs-down",
        "stairs-up",
        "sign-round",
        "sign-rect",
        "sign-little",
        "obj-chest",
        "wall-square-ul",
        "wall-square-ur",
        "wall-mottled-horz",
        "wall-mottled-horz2",
        "floor-cobbles",
        "floor-grass",
        "obj-sword",
        "obj-axe",
        "obj-bow",
        "obj-armor",
        "wall-rect-ul",
        "wall-rect-ur",
        "wall-round-ll",
        "wall-round-lr",
        "obj-pinetree",
        "obj-oaktree",
        "obj-trees",
        "obj-key",
        "obj-meat",
        "obj-ring",
        "ui-switch-on",
        "ui-switch-off",
        "ui-switch-raised",
        "ui-thin-arrow",
        "ui-empty-heart",
        "ui-half-heart",
        "ui-full-heart",
        "ui-empty-shield",
        "ui-half-shield",
        "ui-full-shield",
        "map-path-start",
        "map-path-horz",
        "map-path-ur",
        "ui-large-arrow",
        "ui-exclam",
        "map-house",
        "map-tower",
        "map-tent",
        "map-cross",
        "map-shield",
        "fx-fireball",
        "fx-swirl",
        "fx-fireball-outer",
        "fx-explode",
        "fx-fire-bubbles",
        "fx-rolling-pin",
        "fx-small-explode",
        "obj-potion",
        "obj-shop-sign",
        "obj-candle",
    ]}

    static tilesInRow { 10 }
    static numRows { 9 }
    static spriteSheet { SPRITESHEET }

    static tileData(spriteID) {
        var idx = tagList.indexOf(spriteID)
        if (idx == -1) {
            Fiber.abort("Sprite ID %(spriteID) not found")
        } 

        var y = (idx / tilesInRow).floor
        var x = idx % tilesInRow

        return {
            "srcX": x * 9,
            "srcY": y * 9,
            "srcW": 8,
            "srcH": 8,
            "scaleX": PIXEL_SIZE / 8,
            "scaleY": PIXEL_SIZE / 8
        }
    }

    static draw(spriteID, worldX, worldY) {
        var transform = tileData(spriteID)
        spriteSheet.transform(transform).draw(worldX * PIXEL_SIZE, worldY * PIXEL_SIZE)
    }

    static drawRoom(rect) {
        SpriteData.draw("wall-ul", rect.x1, rect.y1)
        SpriteData.draw("wall-ur", rect.x2, rect.y1)
        SpriteData.draw("wall-ll", rect.x1, rect.y2)
        SpriteData.draw("wall-lr", rect.x2, rect.y2)
        
        for (i in 1...rect.width-1) {
            SpriteData.draw("wall-horz", rect.x1+i, rect.y1)        
            SpriteData.draw("wall-horz", rect.x1+i, rect.y2)
        }

        for (j in 1...rect.height-1) {
            SpriteData.draw("wall-vert-l", rect.x1, rect.y1+j)
            SpriteData.draw("wall-vert-r", rect.x2, rect.y1+j)
        }
    }

    static drawHealth(hp, maxHP) {
        Canvas.offset()
        var fullHearts = (hp / 2).floor
        var halfHeart = (hp & 1) == 1
        var emptyHearts = ((maxHP - hp) / 2).floor
        var i = 0
        var j = 0
        while (i < fullHearts) {
            SpriteData.draw("ui-full-heart", 5 + i, 1)
            i = i + 1
        }
        if (halfHeart) {
            SpriteData.draw("ui-half-heart", 5 + i, 1)
            i = i + 1
        }
        for (j in 0...emptyHearts) {
            SpriteData.draw("ui-empty-heart", 5 + i, 1)
            i = i + 1
        }
    }
}