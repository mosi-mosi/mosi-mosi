angular.module "mosimosi"
  .controller "BulletsCtrl", ($scope, $firebaseObject) ->
    # ref = new Firebase("https://mosi-mosi.firebaseio.com/")
    # $scope.things = $firebaseObject(ref)
  
    $scope.things = [
        subject: "aaa"
        subThings: [
          subject: "bbb"
        ,
          subject: "bbb"
        ]
      ,
        subject: "aaa"
        parentID: "123"
      ,
        subject: "aaa"
        parentID: "123"
      ,
        subject: "aaa"
        parentID: "123"
      ,
        subject: "aaa"
        parentID: "123"
      ,
        subject: "aaa"
        parentID: "123"
    ];