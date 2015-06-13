angular.module "mosimosi"
  .directive "resizable", () ->
    $ = angular.element

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
      heightDelta =
        if delta.y < 0
          Math.ceil(delta.y / step) * step
        else
          Math.floor(delta.y / step) * step

      return if parseInt(element.css("height")) - heightDelta < step

      element.css
        height: "-=#{heightDelta}"
        top: "+=#{heightDelta}"
      return heightDelta != 0

    changeElementBottom = (element, delta, step) ->
      heightDelta =
        if delta.y < 0
          Math.ceil(delta.y / step) * step
        else
          Math.floor(delta.y / step) * step

      return if parseInt(element.css("height")) + heightDelta < step

      element.css
        height: "+=#{heightDelta}"
      return heightDelta != 0

    restrict: "A"
    scope:
      directions: "="
      step: "@"
      resizeStart: "&"
      resizeEnd: "&"
    link: (scope, element, attrs) ->
      element.addClass "resizable"
      element.css "position", "relative" if element.css("position") == "static"
      directions = scope.directions

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

          scope.resizeStart()

      $body.on "mousemove", (event) ->
        return if !info.resizing

        scope.$apply () ->
          delta =
            x: event.pageX - info.basePos.x
            y: event.pageY - info.basePos.y

          console.log delta

          # update the base position if the element is resized
          if changeElementSize element, info.direction, delta, scope.step
            info.basePos =
              x: event.pageX
              y: event.pageY


      $body.on "mouseup", (event) ->
        return if !info.resizing

        scope.$apply () ->
          info.resizing = false
          scope.resizeEnd()
