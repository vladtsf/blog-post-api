express   = require( "express" )
namespace = require( "express-namespace" )
http      = require( "http" )

module.exports = app = express()

require( "../config/environment" )( app )
require( "../config/routes" )( app, require("./middleware/route")( app ) )

http.createServer(app).listen app.get( "port" ), ->
  console.log "Express server listening on port #{ app.get("port") }"

