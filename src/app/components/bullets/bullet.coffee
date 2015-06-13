angular.module "mosimosi"
  .controller "BulletsCtrl", ($scope, bulletFactory, $firebaseObject, $firebaseArray, $q) ->

    bullets = [
      bulletFactory.newBullet([0], 'Developing with AngularJS', true, true),
      bulletFactory.newBullet([1], 'Add sub tasks', false, true, [bulletFactory.newBullet([1, 0], 'Increase indent', false, true), bulletFactory.newBullet([1, 1], 'Decrease indent', false, true)]),
      bulletFactory.newBullet([2], 'Add a shortcut to clean all complete tasks', false, false),
      bulletFactory.newBullet([3], 'Add localStorage for saving tasks', false, false),
      bulletFactory.newBullet([4], 'Add the possibility to navigate through tasks', false, false),
      bulletFactory.newBullet([5], 'Add breadcrumb', false, false)
    ]

    $scope.bullets = bullets

    # ref = new Firebase("https://mosi-mosi.firebaseio.com/things")

    # # $scope.things = $firebaseObject(ref)
    # $scope.things = $firebaseArray(ref)

    # ###
    # thing = {
    #   $id: ""
    #   subject: ""
    #   parent: ""
    # }
    # ###

    # $scope.things.$loaded((things)->

    #   # console.log things

    #   # もし、バレットがなければ空のバレットを追加
    #   if things.length == 0
    #     $scope.things.$add(
    #       subject: ""
    #     )
    #   else
    #     # $scope.things = $scope.things.filter (t) -> !!!t.parent

    # )

    # $scope.thingFilter = (element, index)->
    #   # console.log element, index

    #   return !!!element.parent


    # $scope.subThings = (thing)->
    #   # query = ref.orderByChild("parent").equalTo(thing.$id)
    #   # things = $firebaseArray(query)

    #   things = $scope.things.filter (t) -> t.parent == thing.$id

    # $scope.addBullet = ($event, thing)->
    #   thing.subject = $event.target.value
    #   $scope.things.$save(thing)

    #   $scope.things.$add(
    #     subject: ""
    #   )

    #   # console.log $event, thing

    # $scope.completeBullet = ($event, thing)->
    #   console.log $event, thing

    # $scope.selectBullet = (thing, index)->
    #   console.log thing, index

    #   thing.selected = true
    #   $scope.things.$save(thing)

    # $scope.removeCharacter = ($event, thing)->
    #   # console.log $event, thing
    #   if $event.target.value == ""
    #     $scope.things.$remove(thing)

    #   $event.preventDefault()

    # $scope.removeBullet = ($event, thing)->
    #   console.log $event, thing

    # $scope.toBullet = ($event, thing)->
    #   # console.log $event, thing
    #   parentThing = $scope.things.$getRecord(thing.parent)
    #   parentThingKey = parentThing.parent || null
    #   thing.parent = parentThingKey 
    #   $scope.things.$save(thing)

    # $scope.toSubBullet = ($event, thing)->
    #   # console.log $event, thing

    #   index = $scope.things.$indexFor(thing.$id)
    #   console.log index, "index"

    #   previousThingKey = $scope.things.$keyAt(index - 1)
    #   console.log previousThingKey, "key"

    #   # previousThing = $scope.things.$getRecord(key)

    #   if previousThingKey
    #     thing.parent = previousThingKey
    #     $scope.things.$save(thing)

    # $scope.expandHideBullets = ($event, thing)->
    #   console.log $event, thing


  .factory 'bulletFactory', ->
    return {
      newBullet: (index, text, focus, complete, subBullets, hideBullets) -> {
        index: index or [ 0 ]
        text: text or ''
        focus: focus or false
        complete: complete or false
        bullets: subBullets or []
        hideBullets: hideBullets or false
      }
    }

  .factory 'bulletUtils', ->
    hasChildrenIndexes = (indexes) ->
      if indexes.length > 1
        return true
      false

    nextIndexes = (indexes) ->
      newIndexes = indexes.slice()
      newIndexes.splice 0, 1
      newIndexes

    return {
      checkArray: (arrayToTest) ->
        if !arrayToTest or !angular.isArray(arrayToTest)
          throw new Error(arrayToTest + ' is not an array!')
        this
      checkNumber: (numberToTest) ->
        if !numberToTest or !angular.isNumber(numberToTest)
          throw new Error(numberToTest + ' is not a number!')
        this
      findBulletsArray: (bullets, indexes) ->
        # Check if there are childrend indexes
        if hasChildrenIndexes(indexes)
          # Fetch the index from the first element of the array
          index = indexes[0]
          # Recursive call to the subItems of the item
          return @findBulletsArray(bullets[index].bullets, nextIndexes(indexes))
        bullets
      findBullet: (bullets, indexes) ->
        bulletsArray = @findBulletsArray(bullets, indexes)
        lastIndex = indexes[indexes.length - 1]
        if bulletsArray and lastIndex >= 0 and lastIndex < bulletsArray.length
          return bulletsArray[lastIndex]
        throw new Error('Bullet not found for indexes ' + indexes)
    }

  .directive 'bullets', (bulletFactory, bulletUtils) ->
    addStepToIndex = (indexes, step) ->
      bulletUtils.checkArray indexes
      indexesArray = indexes.slice()
      if step and angular.isNumber(step)
        indexesArray[indexesArray.length - 1] = indexesArray[indexesArray.length - 1] + step
      indexesArray

    populateIndexes = (bullets, indexes) ->
      i = undefined
      if bullets
        i = 0
        while i < bullets.length
          indexesArray = undefined
          if indexes
            indexesArray = indexes.slice()
          else
            indexesArray = []
          indexesArray.push i
          bullets[i].index = indexesArray
          # bullets[i].focus = false;
          populateIndexes bullets[i].bullets, indexesArray
          i++

    return {
      restrict: 'E'
      templateUrl: 'app/components/bullets/bullets.html'
      scope: bullets: '='
      link: (scope) ->
        currentBullet = undefined

        scope.$watch 'bullets', ((bullets) ->
          populateIndexes bullets
          return
        ), true

        scope.hasBullets = (bullet) ->
          bullet.bullets.length > 0

        scope.selectBullet = (indexes, step) ->
          indexesArray = addStepToIndex(indexes, step)
          try
            selectedBullet = bulletUtils.findBullet(scope.bullets, indexesArray)
            if currentBullet
              currentBullet.focus = false
            selectedBullet.focus = true
            currentBullet = selectedBullet
          catch err

        scope.addBullet = ($event, indexes) ->
          bullets = bulletUtils.findBulletsArray(scope.bullets, indexes.slice())
          newIndexes = addStepToIndex(indexes, 1)
          index = newIndexes[newIndexes.length - 1]
          bulletUtils.checkArray bullets
          bullets.splice index, 0, bulletFactory.newBullet()
          scope.selectBullet newIndexes
          $event.preventDefault()


        scope.completeBullet = ($event, indexes) ->
          selectedBullet = bulletUtils.findBullet(scope.bullets, indexes)
          selectedBullet.complete = !selectedBullet.complete
          scope.selectBullet indexes, 1
          $event.preventDefault()

        scope.removeBullet = ($event, indexes) ->
          index = indexes[indexes.length - 1]
          bullets = bulletUtils.findBulletsArray(scope.bullets, indexes.slice())
          indexToFocus = [ 0 ]
          bullets.splice index, 1
          # In case we removed every bullets
          if !scope.bullets.length
            scope.bullets.push bulletFactory.newBullet()
          if bullets[index]
            indexToFocus = indexes.slice()
            indexToFocus[indexToFocus.length - 1] = index
          else if bullets[index - 1]
            indexToFocus = indexes.slice()
            indexToFocus[indexToFocus.length - 1] = index - 1
          scope.selectBullet indexToFocus
          $event.preventDefault()

        scope.toSubBullet = ($event, indexes) ->
          newIndexes = indexes.slice()
          bullets = bulletUtils.findBulletsArray(scope.bullets, newIndexes)
          bullet = bulletUtils.findBullet(scope.bullets, newIndexes)
          index = indexes[indexes.length - 1]
          previousIndex = index - 1
          previousBullet = bullets[previousIndex]
          if previousBullet
            # Push the bullet to the previous bullet sub bullets array
            previousBullet.bullets.push bullet
            # Remove the bullet from the origin bullets array
            bullets.splice index, 1
            # Put the cursor on the bullet
            newIndexes = previousBullet.index
            newIndexes.push previousBullet.bullets.length - 1
            scope.selectBullet newIndexes
          $event.preventDefault()

        scope.toBullet = ($event, indexes) ->
          newIndexes = indexes.slice()
          oldBullets = bulletUtils.findBulletsArray(scope.bullets, newIndexes)
          oldBullet = bulletUtils.findBullet(scope.bullets, newIndexes)
          oldIndex = indexes[indexes.length - 1]
          # Remove the last index of the array
          newIndexes.pop()
          # Add the bullet to the parent bullets array
          bullets = bulletUtils.findBulletsArray(scope.bullets, newIndexes)
          newIndex = newIndexes[newIndexes.length - 1] + 1
          if newIndex
            # Remove the bullet from the sub bullets
            oldBullets.splice oldIndex, 1
            # Add the bullet to the parent bullets array
            bullets.splice newIndex, 0, oldBullet
            # Put the cursor on the bullet
            newIndexes[newIndexes.length - 1] = newIndex
            scope.selectBullet newIndexes
          $event.preventDefault()

        scope.expandHideBullets = ($event, indexes) ->
          bullet = bulletUtils.findBullet(scope.bullets, indexes.slice())
          bullet.hideBullets = !bullet.hideBullets
          $event.preventDefault()
    }

  .directive 'bulFocusme', ()->
    return {
      restrict: 'A'
      scope:
        trigger: '=bulFocusme'
      link: (scope, element)->
          scope.$watch('trigger', (value) ->
            if value == true
              element[0].focus()
              scope.trigger = false
          )
  }