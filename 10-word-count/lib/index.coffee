through2 = require 'through2'


module.exports = ->
  words       = 0
  lines       = 0
  characters  = 0
  bytes       = 0

  transform   = (chunk, encoding, cb) ->

    bytes = Buffer.from(chunk).length
    tokens = []
    lines = chunk.split '\n'

    lines.forEach (line, i) ->
      characters += line.length

      if /"(?:\\?.)*?"/.test line
        tokens.push line

      else
        regex = /[\s_]+|([a-z0-9])(?=[A-Z])/g;
        line = line.replace(regex, "$1 ")
        console.log line
        splited_line = line.split(' ')

        tokens = tokens.concat line.split(' ')

    words = tokens.length
    lines = lines.length


    return cb()

  flush = (cb) ->
    this.push {words, lines, characters, bytes}
    this.push null
    return cb()

  return through2.obj transform, flush
