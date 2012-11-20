describe "Posts", ->

  before ( done ) ->
    Post = require( "../../app/models/post" )
    Comment = require( "../../app/models/comment" )

    @loremIpsum = fs.readFileSync( path.join( __testsRootDir, "fixtures", "lorem-ipsum.txt" ), "utf8" )

    Post.remove ( err1 ) =>
      Comment.remove ( err2 ) =>
        new Comment( body: "Hola, bro!" ).save ( err3, @dummyThreadedComment ) =>
          new Comment( body: "Hello, world!", comments: [ @dummyThreadedComment._id ] ).save ( err4, @dummyComment ) =>
            new Post( title: "Hello, world!", body: @loremIpsum, comments: [ @dummyComment._id ] ).save ( err5, @dummyPost ) =>
              done( err1 || err2 || err3 || err4 || err5 )

  after ( done ) ->
    require( "../../app/models/post" ).remove ( err1 ) ->
      require( "../../app/models/comment" ).remove ( err2 ) ->
        done( err1 || err2 )

  beforeEach ( done ) ->

    done()

  describe "list", ->

    it "should return json", ( done ) ->
      request
        .get( "/posts" )
        .expect( "Content-Type", /json/)
        .expect( 200 )
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "offset", 0
          res.body.should.have.property "limit"
          res.body.should.have.property "count"
          res.body.should.have.property( "posts" )

          done()

    it "should apply offset and limit", ( done ) ->
      request
        .get( "/posts?offset=10&limit=10" )
        .send( offset: 10, limit: 10 )
        .expect( 200 )
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "offset", 10
          res.body.should.have.property "limit", 10

          done()

  describe "create", ->

    it "should create post", ( done ) ->
      request
        .post( "/posts" )
        .send(
          title: "Hello, world!"
          body: @loremIpsum
        )
        .expect( 200 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "_id"
          res.body.should.have.property "title", "Hello, world!"
          res.body.should.have.property "body", @loremIpsum

          done()

  describe "comment", ->
    it "should be possible to comment post", ( done ) ->
      request
        .post( "/posts/#{ @dummyPost._id }/comments" )
        .send( body: "Hello, world!" )
        .expect( 200 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "_id"
          res.body.should.have.property "body", "Hello, world!"
          res.body.should.have.property "comments"
          res.body.comments.should.be.a "object"

          done()

    it "should be possible to post threaded comment", ( done ) ->
      request
        .post( "/posts/#{ @dummyPost._id }/comments/#{ @dummyComment._id }" )
        .send( body: "Hola, bro!" )
        .expect( 200 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "_id"
          res.body.should.have.property "body", "Hola, bro!"
          res.body.should.have.property "comments"
          res.body.comments.should.be.a "object"

          done()

    it "should be possible to remove comment", ( done ) ->
      request
        .del( "/posts/#{ @dummyPost._id }/comments/#{ @dummyThreadedComment._id }" )
        .expect( 200 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.success.should.be.true

          done()

    it "shouldn't be possible to remove nonexistent comment", ( done ) ->
      request
        .del( "/posts/#{ @dummyPost._id }/comments/509e8743159227" )
        .expect( 404 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.success.should.be.false

          done()

  describe "show", ->
    it "should show a post", ( done ) ->
      request
        .get( "/posts/#{ @dummyPost._id }" )
        .expect( 200 )
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "_id", "509e8743159227186b0ec460"
          res.body.should.have.property "title", "Hello, world!"
          res.body.should.have.property "body", @loremIpsum
          res.body.should.have.property "comments"
          res.body.comments.should.be.a "object"

          done()

    it "shouldn't show nonexistent post", ( done ) ->
      request
        .get( "/posts/509e8743159" )
        .expect( 404 )
        .end done

    it "should have a comments", ( done ) ->
      request
        .get( "/posts/#{ @dummyPost._id }" )
        .expect( 200 )
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "comments"
          res.body.comments.should.be.a "object"
          res.body.comments.should.not.be.empty
          res.body.comments[0].should.have.property "_id", "#{ @dummyPost._id }"
          res.body.comments[0].should.have.property "body", "Hello, world!"
          res.body.comments[0].should.have.property "comments"
          res.body.comments[0].comments.should.be.a "object"

          done()

  describe "update", ->

    it "should update post", ( done ) ->
      request
        .put( "/posts/#{ @dummyPost._id }" )
        .send(
          title: "Hola, world!"
          body: "Heya!"
        )
        .expect( 200 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "_id", "#{ @dummyPost._id }"
          res.body.should.have.property "title", "Hola, world!"
          res.body.should.have.property "body", "Heya!"
          res.body.should.have.property "comments"
          res.body.comments.should.be.a "object"

          done()

    it "shouldn't update nonexistent post", ( done ) ->
      request
        .put( "/posts/509e8743159" )
        .expect( 404 )
        .end( done )

  describe "delete", ->

    it "should delete post", ( done ) ->
      request
        .del( "/posts/#{ @dummyPost._id }" )
        .expect( 200 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "success", on

          done()

    it "shouldn't delete nonexistent post", ( done ) ->
      request
        .del( "/posts/509e8743159" )
        .expect( 404 )
        .expect( "Content-Type", /json/)
        .end ( err, res ) ->
          throw err if err

          res.body.should.be.a "object"
          res.body.should.have.property "success", off

          done()