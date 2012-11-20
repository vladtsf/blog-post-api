# blog-post-api [![build status](https://secure.travis-ci.org/vtsvang/blog-post-api.png)](http://travis-ci.org/vtsvang/blog-post-api)

Example of blog-posts REST API on Express and Mongoose.

## Bootstrap

### Install deps
`npm install`

### Start application
`npm start`

## Tests
Run tests with `npm test`

## API methods

### GET /posts/
List posts

### GET /posts/:id
Show post and comments

### PUT /posts/:id
Update post

### POST /posts/
Create post

### DELETE /posts/:id
Delete post

### POST /posts/:post/comments/
Post a comment

### POST /posts/:post/comments/:parent
Post comment reply

### DELETE /posts/:post/comments/:id
Delete comment