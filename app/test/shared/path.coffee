app = require '../../app'

{pathRaw, pathFor} = app.locals.path

describe 'path', ->
  describe '#pathRaw', ->
    it 'should parse all verbs', ->
      pathFor('index').should.equal '/'
