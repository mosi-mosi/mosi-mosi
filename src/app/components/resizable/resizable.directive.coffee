angular.module "mosimosi"
  .directive "resizable", ($parse) ->
    $ = angular.element

    calcDeltaStep = (delta, step) ->
      if delta < 0
        Math.ceil delta / step
      else
        Math.floor delta / step

    changeElementSize = (element, dir, delta, step) ->
      switch dir
        when "top"
          changeElementTop element, delta, step
        when "bottom"
          changeElementBottom element, delta, step
        when "left"
          throw new Error("Not Implemented for direction #{dir}")
        when "right"
          throw new Error("Not Implemented for direction #{dir}")
        else
          throw new Error("Unexpected direction: #{dir}")

    changeElementTop = (element, delta, step) ->
      heightDelta = calcDeltaStep(delta.y, step) * step

      return false if parseInt(element.css("height")) - heightDelta < step

      element.css
        height: "-=#{heightDelta}"
        top: "+=#{heightDelta}"
      return heightDelta != 0

    changeElementBottom = (element, delta, step) ->
      heightDelta = calcDeltaStep(delta.y, step) * step

      return false if parseInt(element.css("height")) + heightDelta < step

      element.css
        height: "+=#{heightDelta}"
      return heightDelta != 0

    restrict: "A"
    scope: false

    link: (scope, element, attrs) ->
      element.addClass "resizable"
      element.css "position", "relative" if element.css("position") == "static"
      directions = $parse(attrs.directions) scope
      step = $parse(attrs.step) scope
      resizeStart = $parse attrs.resizeStart
      resizeEnd = $parse attrs.resizeEnd

      # append resize handlers
      handles = $()
      for d in directions
        handles = handles.add $("<div class='resizable-handle resizable-handle-#{d}' data-direction='#{d}'></div>")
      element.append handles

      # register listeners for resize
      info =
        resizing: false
        direction: null
        basePos: null
        originalSize: null

      $body = $("body")

      # retain the information about resize when mouse down
      element.on "mousedown", ".resizable-handle", (event) ->
        event.stopPropagation()
        scope.$apply () ->
          info.resizing = true
          info.direction = $(event.currentTarget).attr("data-direction")
          info.basePos =
            x: event.pageX
            y: event.pageY
          info.originalSize =
            width: parseInt element.css "width"
            height: parseInt element.css "height"

          resizeStart scope

      $body.on "mousemove", (event) ->
        return if !info.resizing

        scope.$apply () ->
          delta =
            x: event.pageX - info.basePos.x
            y: event.pageY - info.basePos.y

          # update the base position if the element is resized
          if changeElementSize element, info.direction, delta, step
            info.basePos =
              x: event.pageX
              y: event.pageY


      $body.on "mouseup", (event) ->
        return if !info.resizing

        scope.$apply () ->
          info.resizing = false
          resizeEnd scope,
            info:
              direction: info.direction
              x: (parseInt(element.css "width") - info.originalSize.width) / step
              y: (parseInt(element.css "height") - info.originalSize.height) / step
