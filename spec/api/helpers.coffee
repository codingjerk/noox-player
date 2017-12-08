rqst       = require 'request'
{Readable} = require 'stream'


module.exports = (BASE) =>
    class InfiniteStream extends Readable
        constructor: (options) -> super options
        _read: -> @push ' '
        toJSON: -> '[InfiniteStream]'

    rp = (opts) => new Promise (resolve, reject) =>
        rqst opts, (err, res, body) =>
            if err then reject err
            resolve {res, body}

    class Request
        constructor: (@method, @path) ->
            @uri = "#{BASE}#{@path}"

            Object.defineProperty @, 'dropsInfiniteBody', get: @_dropsInfiniteBody
            Object.defineProperty @, 'rejectsAnyOptions', get: @_rejectsAnyOptions

        returnsStatus: (code, body, should) ->
            should ?= "should return #{code} status code"
            it should, =>
                {res} = await rp {@uri, @method, body}
                res.statusCode.should.equal code

        returnsBody: (body) ->
            b = JSON.stringify body
            it "should return #{b} body", =>
                {res} = await rp {@uri, @method}
                res.body.should.equal body

        acceptsBody: (...bodies) ->
            each = (body) => @returnsStatus 200, body, "should accept #{JSON.stringify body} body"
            bodies.forEach each

        rejectsBody: (...bodies) ->
            each = (body) => @returnsStatus 400, body, "should reject #{JSON.stringify body} body"
            bodies.forEach each

        _dropsInfiniteBody: ->
            @rejectsBody new InfiniteStream

        _rejectsAnyOptions: ->
            it 'should reject any options'

    (method, path, test) =>
        describe "#{method} #{path}", =>
            test new Request method, path
