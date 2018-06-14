fs = require 'fs'


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    if err then return cb err

    #Grouping the date set for countryCode
    regexp = ///(.*?[\t]#{countryCode}[\t][1-9|-]\d*[\n])///      #/(.*?[\t]RU[\t][1-9|-]\d*[\n])/gi
    data = data.match RegExp(regexp, 'g')

    counter = 0

    data.forEach (line, i) ->
      line = line.split '\t'
      # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
      # line[0],       line[1],       line[3]

      counter += line[1] - line[0]

    cb null, counter
