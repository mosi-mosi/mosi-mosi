angular.module "mosimosi"
  .controller "AuthCtrl", ($scope, $state, $firebaseAuth, $firebaseObject, $firebaseArray) ->
    ref = new Firebase("https://mosi-mosi.firebaseio.com")
    auth = $firebaseAuth(ref)

    $scope.login = (provider)->
      if provider == "facebook"
        auth.$authWithOAuthPopup("facebook", {}).then((authData) ->
          console.log authData

          $firebaseArray(ref.child('users')).$add({
            'uid': authData.uid
            'displayName': authData.facebook.displayName
            'id': authData.facebook.id
            'picture': authData.facebook.cachedUserProfile.picture.data.url
          })

          $state.go('home');

          console.log("Logged in as:", authData.uid)
        ).catch((error)->
          
          alert("認証エラー");
          console.log("Authentication failed:", error)
        )
