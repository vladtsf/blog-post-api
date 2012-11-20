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
              res.send 504
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
    res.send( 404 )

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
    res.send( 404 )

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