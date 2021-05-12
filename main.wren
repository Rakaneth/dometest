import "graphics" for Canvas, Color
import "dome" for Window
import "gfx" for SpriteData, PIXEL_SIZE
import "bsp" for BSPNode, BSPUtil
import "input" for Keyboard
import "math" for M

class Game {
  static init() {
    var scale = 4
    Canvas.resize(40 * PIXEL_SIZE, 30 * PIXEL_SIZE)
    Window.resize(Canvas.width * scale, Canvas.height * scale)
    Window.lockstep = true
    __mustDraw = true
    __frame = 0
    var root = BSPNode.new(1, 1, 100, 100)
    var numNodes = BSPUtil.bspSplit(root)
    if (numNodes == 0) {
      Fiber.abort("BSP Failed to split nodes")
    }
    __rooms = []
    __cx = 0
    __cy = 0

    root.makeRooms()

    BSPUtil.inOrder(root) {|node|
      if (node.room) {
        __rooms.add(node.room)
      } 
    }
  }
  static update() {
    if (Keyboard["w"].justPressed) {
      __cy = __cy - 1
      __mustDraw = true
    }
    if (Keyboard["a"].justPressed) {
      __cx = __cx - 1
      __mustDraw = true
    }
    if (Keyboard["s"].justPressed) {
      __cy = __cy + 1
      __mustDraw = true
    }
    if (Keyboard["d"].justPressed) {
      __cx = __cx + 1
      __mustDraw = true
    }
    //Canvas.offset(__cx, __cy)
  }
  static draw(dt) {
    if (__mustDraw) {
      Canvas.cls()
      __mustDraw = false
      for (room in __rooms) {
        SpriteData.drawRoom(room)
        SpriteData.draw("char-person", __cx, __cy)
      }
      SpriteData.drawHealth(4, 20)
      Canvas.print("Player at %(__cx),%(__cy)", 0, 0, Color.white)
    }
  }

  static spriteTest() {
    var wx = 0
    var wy = 0
    for (img in SpriteData.tagList) {
      SpriteData.draw(img, wx, wy)
      wx = wx + 1
      if (wx >= 10) {
        wx = 0
        wy = wy + 1
      }
    }
  }
}
