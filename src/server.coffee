http    = require 'http'
express = require 'express'


class Server
    constructor: ->
        @express = express()
        @applyRoutes()
        @http = http.createServer @express

    start: (port) ->
        @http.listen port

    stop: ->
        @http.close()

    applyRoutes: ->
        @express.get '/v1/playback', (req, res) => res.send 'idle'
        @express.get '/v1/playlist', (req, res) => res.send '[]'
        @express.get '/v1/playlist/prev', (req, res) => res.status(204).send()
        @express.get '/v1/playlist/current', (req, res) => res.status(204).send()
        @express.get '/v1/playlist/next', (req, res) => res.status(204).send()
        @express.get '/v1/position', (req, res) => res.send '0'
        @express.get '/v1/volume',   (req, res) => res.send '1'

        @express.post '/v1/playback', (req, res) =>
            data = ''
            dataProcessor = (chunk) =>
                data += chunk

                if data.length >= 6
                    req.removeListener 'data', dataProcessor
                    res.status(400).send()

            req.on 'data', dataProcessor

            req.on 'end', =>
                if data in ['play', 'pause', 'stop']
                    res.status(200).send()

                res.status(400).send()

        @express.post '/v1/playlist', (req, res) =>
            data = ''
            dataProcessor = (chunk) =>
                data += chunk

                if data.length >= 1024
                    req.removeListener 'data', dataProcessor
                    res.status(400).send()

            req.on 'data', dataProcessor

            req.on 'end', =>
                try
                    json = JSON.parse(data)
                catch SyntaxError
                    res.status(400).send()

                if json not instanceof Array
                    return res.status(400).send()

                for e in json
                    if typeof e isnt 'string'
                        res.status(400).send()

                res.status(200).send()

        @express.post '/v1/position', (req, res) =>
            data = ''
            dataProcessor = (chunk) =>
                data += chunk

                if data.length >= 1024
                    req.removeListener 'data', dataProcessor
                    res.status(400).send()

            req.on 'data', dataProcessor

            req.on 'end', =>
                try
                    json = JSON.parse(data)
                catch SyntaxError
                    res.status(400).send()

                if typeof json isnt 'number'
                    res.status(400).send()

                if json < 0.0
                    res.status(400).send()

                if json > 1.0
                    res.status(400).send()

                res.status(200).send()

        @express.post '/v1/volume', (req, res) =>
            data = ''
            dataProcessor = (chunk) =>
                data += chunk

                if data.length >= 1024
                    req.removeListener 'data', dataProcessor
                    res.status(400).send()

            req.on 'data', dataProcessor

            req.on 'end', =>
                try
                    json = JSON.parse(data)
                catch SyntaxError
                    res.status(400).send()

                if typeof json isnt 'number'
                    res.status(400).send()

                if json < 0.0
                    res.status(400).send()

                if json > 1.0
                    res.status(400).send()

                res.status(200).send()

module.exports = Server

if require.main is module
    server = new Server
    server.start 3000
