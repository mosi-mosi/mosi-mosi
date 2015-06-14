angular.module "mosimosi"
  .directive "draggable", ($parse) ->
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

    return {
      restrict: "A"
      scope: false

      link: (scope, element, attrs) ->
        element.addClass "draggable"
        element.css "position", "relative" if element.css("position") == "static"

        axis = attrs.axis
        step = $parse(attrs.step)(scope) || 1
        canMoveY = axis != "x"
        canMoveX = axis != "y"
        dragStart = $parse attrs.dragStart
        dragEnd = $parse attrs.dragEnd
        $body = $("body")

        info =
          dragging: false
          basePos: null
          originalSize: null

        element.on "mousedown", (event) ->
          scope.$apply () ->
            info.dragging = true
            info.basePos =
              x: event.pageX
              y: event.pageY
            info.originalPos =
              top: element.position().top
              left: element.position().left

            dragStart scope

        $body.on "mousemove", (event) ->
          return if !info.dragging

          scope.$apply () ->
            delta =
              x: event.pageX - info.basePos.x
              y: event.pageY - info.basePos.y

            if canMoveX && moveElementX element, delta.x, step
              info.basePos.x = event.pageX

            if canMoveY && moveElementY element, delta.y, step
              info.basePos.y = event.pageY

        $body.on "mouseup", (event) ->
          return if !info.dragging

          scope.$apply () ->
            info.dragging = false
            dragEnd scope,
              info:
                x: (element.position().left - info.originalPos.left) / step
                y: (element.position().top - info.originalPos.top) / step
    }
