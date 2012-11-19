express = require("express")
path    = require("path")
fs      = require("fs")
pkg     = require("../package.json")

module.exports = (app) ->

  app.configure "development", ->
    app.use express.errorHandler()
    app.set "mongodb", "mongodb://testuser:7258cbbd2eb535757a0514b83c460f9e@alex.mongohq.com:10016/blog-posts-api"

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
