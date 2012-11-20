mongoose = require "mongoose"
Comment = require "./comment"

schema = new mongoose.Schema
  title:
    type: String
    required: on
  body:
    type: String
    required: on
  comments: [
    type: mongoose.Schema.Types.ObjectId
    ref: "Comment"
  ]

module.exports = Post = mongoose.model "Post", schema