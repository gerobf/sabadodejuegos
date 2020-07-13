(local lurker (require "lib.lurker"))
(local pieces (require "pieces"))

(global colors {" " [.87 .87 .87]
                "i" [.47 .76 .94]
                "j" [.93 .91 .42]
                "l" [.49 .85 .76]
                "o" [.92 .69 .47]
                "s" [.83 .54 .93]
                "t" [.97 .58 .77]
                "z" [.66 .83 .46]})

(global inert {:gridX 10
               :gridY 18})

(global piece {:type 1
               :rotation 1
               :x 3
               :y 0})

(global timer {:value 0
               :limit .5})

(global sequence {})

(fn newSequence []
  (for [i 1 (# pieces.structures)]
    (let [position (love.math.random (+ (# sequence) 1))]
      (table.insert sequence position i))))

(fn newPiece []
  (set piece.x 3)
  (set piece.y 0)
  (set piece.type (table.remove sequence))
  (set piece.rotation 1)
  (if (= (# sequence) 0)
      (newSequence)))

(fn love.load []
  (love.graphics.setBackgroundColor 1 1 1)

  (for [y 1 inert.gridY]
    (tset inert y {})
    (for [x 1 inert.gridX]
      (tset (. inert y) x " ")))

  (newSequence)
  (newPiece))

(fn drawBlock [block x y]
  (let [blockSize 20
        blockDrawSize (- blockSize 1)
        color (. colors block)]
    (love.graphics.setColor color)
    (love.graphics.rectangle "fill"
                             (* (- x 1) blockSize)
                             (* (- y 1) blockSize)
                             blockDrawSize
                             blockDrawSize)))

(fn canMove? [tx ty tr]
  (let [return {:result true}]
    (for [x 1 4]
      (for [y 1 4]
        (let [testBlockX (+ tx x)
              testBlockY (+ ty y)]
          (if (and (~= " " (. (. (. (. pieces.structures piece.type)
                                    tr)
                                 y)
                              x))
                   (or (< testBlockX 1)
                       (> testBlockX inert.gridX)
                       (> testBlockY inert.gridY)
                       (~= " " (. inert testBlockY testBlockX))))
              (tset return :result false)))))
    return.result))

(fn love.draw []
  (for [y 1 inert.gridY]
    (for [x 1 inert.gridX]
      (drawBlock (. inert y x) x y)))

  (for [y 1 4]
    (for [x 1 4]
      (let [block (. (. (. (. pieces.structures piece.type)
                           piece.rotation)
                        y)
                     x)]
        (when (~= block " ")
          (drawBlock block (+ x piece.x) (+ y piece.y)))))))

(fn love.update [dt]
  (lurker.update dt)
  (tset timer :value (+ timer.value dt))
  (when (>= timer.value timer.limit)
    (tset timer :value (- timer.value timer.limit))
    (if (canMove? piece.x (+ piece.y 1) piece.rotation)
        (set piece.y (+ piece.y 1))
        (do
          (for [y 1 4]
            (for [x 1 4]
              (let [block (. (. (. (. pieces.structures piece.type)
                                   piece.rotation)
                                y)
                             x)]
                (if (~= block " ")
                    (tset (. inert (+ y piece.y)) (+ x piece.x) block)))))

          (for [y 1 inert.gridY]
            (let [is {:complete? true}]
              (for [x 1 inert.gridX]
                (if (= " " (. inert y x))
                    (tset is :complete? false)))
              (when is.complete?
                (for [removeY y 2 -1]
                  (for [removeX 1 inert.gridX]
                    (tset (. inert removeY) removeX
                          (. inert (- removeY 1) removeX))))
                (for [removeX 1 inert.gridX]
                  (tset (. inert 1) removeX " ")))))

          (newPiece)
          (if (not (canMove? piece.x piece.y piece.rotation))
              (love.load))))))

(fn love.keypressed [key]
  (if (= key "r") (love.load))

  (when (= key "x")
    (let [test {:rotation (+ piece.rotation 1)}]
      (when (> test.rotation (# (. pieces.structures piece.type)))
        (tset test :rotation 1))
      (if (canMove? piece.x piece.y test.rotation)
          (tset piece :rotation test.rotation))))

  (when (= key "z")
    (let [test {:rotation (- piece.rotation 1)}]
      (if (< test.rotation 1)
          (tset test :rotation (# (. pieces.structures piece.type))))
      (if (canMove? piece.x piece.y test.rotation)
          (tset piece :rotation test.rotation))))

  (when (= key "right")
    (let [test {:x (+ piece.x 1)}]
      (if (canMove? test.x piece.y piece.rotation)
          (tset piece :x test.x))))

  (when (= key "left")
    (let [test {:x (- piece.x 1)}]
      (if (canMove? test.x piece.y piece.rotation)
          (tset piece :x test.x))))

  (when (= key "down")
    (tset piece :type (+ piece.type 1))
    (if (> piece.type (# pieces.structures))
        (tset piece :type 1))
    (tset piece :rotation 1))

  (when (= key "up")
    (tset piece :y (- piece.y 5)))

  (when (= key "c")
    (while (canMove? piece.x (+ piece.y 1) piece.rotation)
      (set piece.y (+ piece.y 1))
      (set timer.value timer.limit))))
