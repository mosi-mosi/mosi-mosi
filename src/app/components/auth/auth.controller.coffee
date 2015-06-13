angular.module "mosimosi"
  .controller "AuthCtrl", ($scope, $firebaseAuth) ->
    ref = new Firebase("https://mosi-mosi.firebaseio.com")
    
    auth = $firebaseAuth(ref)

    auth.$authWithOAuthPopup("facebook").then((authData) ->
      console.log("Logged in as:", authData.uid)
    ).catch((error)->
      console.log("Authentication failed:", error)
    )