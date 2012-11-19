module.exports = (app) ->
  return (method, path, route) ->
    controllerName = route.split( "#" )[ 0 ]
    actionName = route.split( "#" )[ 1 ]

    controller = require( "../controllers/#{controllerName}" )

    # define route handler
    app[method] path, (req, res) =>
      controllerInstance = new controller( req, res )

      unless controllerInstance.stop
        if controllerInstance[actionName]?
          controllerInstance[actionName].apply( controllerInstance, arguments)
        else
          res.send( 404 )

      controllerInstance = null