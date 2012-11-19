global.app = require( "../app" )
global.request = require( "supertest" )( app )
global.fs = require( "fs" )
global.path = require( "path" )
global.__testsRootDir = __dirname