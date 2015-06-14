angular.module "mosimosi"
  .factory "Draggable", ->
    dragging: false
    basePos: null
    originalSize: null
    el: null
    helper: null
