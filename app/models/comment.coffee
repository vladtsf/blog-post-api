mongoose = require "mongoose"

schema = new mongoose.Schema
  body:
    type: String
    required: on
  comments: [
    type: mongoose.Schema.Types.ObjectId
    ref: "Comment"
  ]

module.exports = Comment = mongoose.model "Comment", schema