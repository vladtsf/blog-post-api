mongoose = require "mongoose"
async = require "async"

schema = new mongoose.Schema
  body:
    type: String
    required: on
  comments: [
    type: mongoose.Schema.Types.ObjectId
    ref: "Comment"
  ]

# remove threads
schema.pre "remove", ( next ) ->
  return next() unless @comments.length

  Comment
    .find()
    .where( "_id" ).in( @comments )
    .remove()
    .exec( next )

schema.methods.loadThread = ( callback = -> ) ->
  Comment
    .find()
    .where( "_id" ).in( @comments )
    .populate( "comments" )
    .exec ( err, comments ) =>
      @set( "comments", comments )
      # @comments = comments
      console.log JSON.stringify( @ )
      callback( err )

module.exports = Comment = mongoose.model "Comment", schema