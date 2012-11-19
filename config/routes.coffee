module.exports = (app, route) ->

  app.namespace "/posts", ->
    route "get", "/", "posts#list"
    route "get", "/:id", "posts#show"
    route "put", "/:id", "posts#update"
    route "post", "/", "posts#create"
    route "delete", "/:id", "posts#remove"

    app.namespace "/:post/comments", ->
      route "post", "/", "posts#createComment"
      route "post", "/:parent", "posts#createComment"
      route "delete", "/:id", "posts#deleteComment"

