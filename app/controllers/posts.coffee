class PostsController
  Post = require "../models/post"
  Comment = require "../models/comment"

  initialize: ->

  #
  # List the posts
  #
  # @example: {
  #   limit: 10,
  #   offset: 0,
  #   count: 10,
  #   posts: [
  #     _id: "509e8743159227186b0ec460",
  #     title: "Hello, world!",
  #     body: "Lorem ipsum..."
  #   ]
  # }
  #
  list: ( req, res ) ->
    offset = parseInt( req.query.offset ) || 0
    limit = parseInt( req.query.limit ) || 10

    Post
      .count()
      .exec ( err, count ) ->
        Post
          .find()
          .select( "_id title body" )
          .sort( "-_id" )
          .skip( offset )
          .limit( limit )
          .exec ( err, posts ) ->
            if err
              res.send 503
            else
              res.json { offset, limit, count, posts }


  #
  # Show the post
  #
  # @example: {
  #   _id: 10,
  #   title: "Hello, world!",
  #   body: "Lorem ipsum",
  #   comments: [
  #     _id: "509e8743159227186b0ec460",
  #     body: "Lorem ipsum...",
  #     comments: []
  #   ]
  # }
  #
  show: ( req, res ) ->
    res.send( 404 )

  #
  # Updates the post
  #
  # @example: {
  #   _id: "509e8743159227186b0ec460",
  #   title: "Hello, world!",
  #   body: "Lorem ipsum",
  #   comments: [
  #     _id: "509e8743159227186b0ec460",
  #     body: "Lorem ipsum...",
  #     comments: []
  #   ]
  # }
  #
  update: ( req, res ) ->
    res.send( 404 )

  #
  # Creates a post
  #
  # @example: {
  #   _id: "509e8743159227186b0ec460",
  #   title: "Hello, world!",
  #   body: "Lorem ipsum",
  #   comments: []
  # }
  #
  create: ( req, res ) ->
    post = new Post( { title, body } = req.body )
    post.save ( err, post ) ->
      if err
        res.send 503
      else
        res.json { _id, title, body, comments } = post

  #
  # Removes a post
  #
  # @example: {
  #   success: true
  # }
  #
  remove: ( req, res ) ->
    res.send( 404 )

  #
  # Creates a comment
  #
  # @example: {
  #   _id: "509e8743159227186b0ec460",
  #   body: "Hola, bro!",
  #   comments: []
  # }
  #
  createComment: ( req, res ) ->
    { post: postId, parent: parentId } = req.route.params

    # @todo: refactor to async
    # find a post
    Post
      .findOne( _id: postId )
      .exec ( err, post ) =>
        if err
          res.send 503
        else unless post
          res.send 404
        else
          # Create a comment
          new Comment( body: req.body.body ).save ( err, comment ) =>
            if err
              res.send 503
            else
              unless parentId
                post.update { $addToSet: { comments : comment._id } }, ( err, numAffected ) =>
                  if err
                    res.send 503
                  else
                    res.json { _id, body, comments } = comment
              else
                Comment
                  .findOne( _id: parentId )
                  .exec ( err, parentComment ) =>
                    if err
                      res.send 503
                    else unless parentComment
                      comment.remove ( err ) =>
                        res.send unless err then 404 else 503
                    else
                      parentComment.update { $addToSet: { comments : comment._id } }, ( err, numAffected ) =>
                        if err
                          res.send 503
                        else
                          res.json { _id, body, comments } = comment

  #
  # Removes a comment
  #
  # @example: {
  #   success: true
  # }
  #
  deleteComment: ( req, res ) ->
    res.send( 404 )

module.exports = PostsController