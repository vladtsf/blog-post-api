express = require("express")
path    = require("path")
fs      = require("fs")
pkg     = require("../package.json")
uuid    = require("node-uuid")

module.exports = (app) ->

  app.configure "development", ->
    app.use express.errorHandler()
    app.set "mongodb", "mongodb://localhost/vtsvang-blog-posts-api-#{ uuid.v4() }"

  app.configure "production", ->
    app.set "mongodb", process.env.MONGODB
    app.use express.logger("dev")

  app.configure ->
    app.set "db", require( "../app/middleware/db" )
    app.set "port", process.env.PORT or 3000
    app.use express.bodyParser()
    app.use express.cookieParser()
    # app.use express.cookieSession
    #     secret: "something about keyboard cat"
    #     key: "ssid"
    #     store: require("../app/middleware/session")
    # app.use express.csrf()
    app.use express.methodOverride()
    app.use app.router
