chai = require 'chai'
chai.should()


PORT = 3000
request = require('./helpers')("http://localhost:#{PORT}/v1")


Server  = require '../../src/server'
server = new Server


describe 'API/v1', =>
    before => server.start PORT
    after  => server.stop()

    request 'GET', '/playback', (it) =>
        it.returnsStatus 200
        it.returnsBody 'idle'

        it.rejectsAnyOptions

    request 'GET', '/playlist', (it) =>
        it.returnsStatus 200
        it.returnsBody '[]'

        it.rejectsAnyOptions

    request 'GET', '/playlist/prev', (it) =>
        it.returnsStatus 204
        it.returnsBody ''

        it.rejectsAnyOptions

    request 'GET', '/playlist/current', (it) =>
        it.returnsStatus 204
        it.returnsBody ''

        it.rejectsAnyOptions

    request 'GET', '/playlist/next', (it) =>
        it.returnsStatus 204
        it.returnsBody ''

        it.rejectsAnyOptions

    request 'GET', '/position', (it) =>
        it.returnsStatus 200
        it.returnsBody '0'

        it.rejectsAnyOptions

    request 'GET', '/volume', (it) =>
        it.returnsStatus 200
        it.returnsBody '1'

        it.rejectsAnyOptions

    request 'POST', '/playback', (it) =>
        it.returnsStatus 400
        it.returnsBody ''

        it.acceptsBody 'play', 'pause', 'stop'
        it.rejectsBody '', 'unacceptable', 'idle'

        it.dropsInfiniteBody
        it.rejectsAnyOptions

    request 'POST', '/playback', (it) =>
        it.returnsStatus 400

        it.acceptsBody 'play', 'pause', 'stop'
        it.rejectsBody '', 'something random', 'idle'

        it.dropsInfiniteBody
        it.rejectsAnyOptions

    request 'POST', '/playlist', (it) =>
        it.returnsStatus 400

        it.acceptsBody '[]'
        it.rejectsBody '{}', 'null', 'true'
        it.rejectsBody '[3]', '[null]', '[true]', '[{}]'

        it.dropsInfiniteBody
        it.rejectsAnyOptions

    request 'POST', '/position', (it) =>
        it.returnsStatus 400

        it.acceptsBody '0', '0.0', '1', '1.0', '0.5'
        it.rejectsBody '"str"', 'null', 'true'
        it.rejectsBody '1.1', '-0.5'

        it.dropsInfiniteBody
        it.rejectsAnyOptions

    request 'POST', '/volume', (it) =>
        it.returnsStatus 400

        # TODO: check if we want to allow burst volume
        it.acceptsBody '0', '0.0', '1', '1.0', '0.5'
        it.rejectsBody '"str"', 'null', 'true'
        it.rejectsBody '1.1', '-0.5'

        it.dropsInfiniteBody
        it.rejectsAnyOptions
