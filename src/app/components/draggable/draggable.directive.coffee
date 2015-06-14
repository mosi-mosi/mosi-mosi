angular.module "mosimosi"
  .directive "draggable", ($parse, Draggable) ->
    $ = angular.element

    calcDeltaStep = (delta, step) ->
      if delta < 0
        Math.ceil delta / step
      else
        Math.floor delta / step

    moveElementX = (element, delta, step) ->
      deltaLeft = calcDeltaStep(delta, step) * step
      element.css "left", "+=#{deltaLeft}"
      return deltaLeft != 0

    moveElementY = (element, delta, step) ->
      deltaTop = calcDeltaStep(delta, step) * step
      element.css "top", "+=#{deltaTop}"
      return deltaTop != 0

    restrict: "A"
    scope: false

    link: (scope, element, attrs) ->
      element.addClass "draggable"
      element.css "position", "relative" if element.css("position") == "static"

      axis = attrs.axis
      step = $parse(attrs.step)(scope) || 1
      canMoveY = attrs.axis != "x"
      canMoveX = attrs.axis != "y"
      clone = $parse(attrs.clone)(scope)
      dragStart = $parse attrs.dragStart
      dragEnd = $parse attrs.dragEnd
      $body = $("body")

      element.on "mousedown", (event) ->
        scope.$apply () ->
          Draggable.dragging = true
          Draggable.basePos =
            x: event.pageX
            y: event.pageY
          Draggable.originalPos =
            top: parseInt element.css "top"
            left: parseInt element.css "left"
          Draggable.el = element

          Draggable.helper = if clone then element.clone().css("opacity", 0.7) else element

          dragStart scope

      $body.on "mousemove", (event) ->
        return if !Draggable.dragging

        scope.$apply () ->
          delta =
            x: event.pageX - Draggable.basePos.x
            y: event.pageY - Draggable.basePos.y

          if canMoveX && moveElementX Draggable.helper, delta.x, step
            Draggable.basePos.x = event.pageX

          if canMoveY && moveElementY Draggable.helper, delta.y, step
            Draggable.basePos.y = event.pageY

      $body.on "mouseup", (event) ->
        return if !Draggable.dragging

        Draggable.helper.remove if clone

        scope.$apply () ->
          Draggable.dragging = false
          dragEnd scope,
            info:
              x: (parseInt(element.css "top") - Draggable.originalPos.top) / step
              y: (parseInt(element.css "left") - Draggable.originalPos.left) / step
