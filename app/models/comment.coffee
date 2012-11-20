mongoose = require "mongoose"

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

module.exports = Comment = mongoose.model "Comment", schema