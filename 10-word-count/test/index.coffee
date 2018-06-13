assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4, bytes: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 20, bytes: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 19, bytes: 19
    helper input, expected, done

  it 'should count lines of a transformed stream', (done) ->
    input = 'first line\nsecond line'

    expected = words: 4, lines: 2, characters: 21, bytes: 22
    helper input, expected, done

  it 'should handle camel cased words for single word', (done) ->
    input = 'firstSecond'

    expected = words: 2, lines: 1, characters: 11, bytes: 11
    helper input, expected, done

  it 'should handle camel cased words in a phrase', (done) ->
    input = 'firstSecond thridFourth'

    expected = words: 4, lines: 1, characters: 23, bytes: 23
    helper input, expected, done

  it 'should handle camel cased words with quated text', (done) ->
    input = '"firstSecond thridFourth"'

    expected = words: 1, lines: 1, characters: 25, bytes: 25
    helper input, expected, done

  it 'should handle camel cased words with single words', (done) ->
    input = 'my name Is jhonKepler'

    expected = words: 5, lines: 1, characters: 21, bytes: 21
    helper input, expected, done

  it 'should count as one word of camel case quated text', (done) ->
    input = '"jhonKepler"'

    expected = words: 1, lines: 1, characters: 12, bytes: 12
    helper input, expected, done

  it 'should handle camel case text with multiple lines', (done) ->
    input = 'jhonKepler\ntonyBlar\nfoo bar'

    expected = words: 6, lines: 3, characters: 25, bytes: 27
    helper input, expected, done

  it 'should handle Quated text with camel cased and new lines', (done) ->
    input = '"QuatedText"\njhonKepler\ntonyBlar\nfoo bar'

    expected = words: 7, lines: 4, characters: 37, bytes: 40
    helper input, expected, done

  it 'should count integer as a word', (done) ->
    input = '0 is a word\njhonKepler\ntonyBlar\nfoo bar'

    expected = words: 10, lines: 4, characters: 36, bytes: 39
    helper input, expected, done

  it 'should count upercase text as a single word', (done) ->
    input = 'UPERCASE\njhonKepler\ntonyBlar\nfoo bar'

    expected = words: 7, lines: 4, characters: 33, bytes: 36
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
