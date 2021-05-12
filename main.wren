import "graphics" for Canvas, Color
import "dome" for Window
import "./gfx" for SpriteData, PIXEL_SIZE
import "./bsp" for BSPNode, BSPUtil
import "input" for Keyboard
import "math" for M
import "./actor" for Actor

class Game {
  static init() {
    __scale = 2
    Canvas.resize(40 * PIXEL_SIZE, 30 * PIXEL_SIZE)
    rescale()
    Window.lockstep = true
    __frame = 0
    var root = BSPNode.new(1, 1, 100, 100)
    var numNodes = BSPUtil.bspSplit(root)
    if (numNodes == 0) {
      Fiber.abort("BSP Failed to split nodes")
    }
    __rooms = []
    __player = Actor.new("char-person")

    root.makeRooms()

    BSPUtil.inOrder(root) {|node|
      if (node.room) {
        __rooms.add(node.room)
      } 
    }
  }
  static update() {
    if (Keyboard["w"].justPressed) {
      __player.moveBy(0, -1)
    }
    if (Keyboard["a"].justPressed) {
      __player.moveBy(-1, 0)
    }
    if (Keyboard["s"].justPressed) {
      __player.moveBy(0, 1)
    }
    if (Keyboard["d"].justPressed) {
      __player.moveBy(1, 0)
    }
    if (Keyboard.isKeyDown("1")) {
      __scale = 1
      rescale()
    }
    if (Keyboard.isKeyDown("2")) {
      __scale = 2
      rescale()
    }
    if (Keyboard.isKeyDown("3")) {
      __scale = 3
      rescale()
    }
    if (Keyboard.isKeyDown("4")) {
      __scale = 4
      rescale()
    }

    //Canvas.offset(__cx, __cy)
  }
  static draw(dt) {
    Canvas.cls()
    __mustDraw = false
    for (room in __rooms) {
      SpriteData.drawRoom(room)
      SpriteData.draw(__player.sprite, __player.x, __player.y)
    }
    SpriteData.drawHealth(4, 20)
    Canvas.print("Player at %(__player.x),%(__player.y)", 0, 0, Color.white)
  }

  static rescale() {
    Window.resize(Canvas.width * __scale, Canvas.height * __scale)
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
