# Description:
#   スラリンがスラリンがオススメのお店を選択してくれます
#
# Commands:
#   hubot tabelog (ランチ|ディナー) for hoge in fuga
#
# Author:
#   @ginonpan
'use strict'

_         = require 'underscore'
cheerio   = require 'cheerio'
request   = require 'request'

module.exports = (robot) ->
  endpoint = 'https://tabelog.com/rst/rstsearch'

  exists = (array) ->
    return array.stars? and array.stars != '' and array.score? and array.score != ''

  robot.respond /tabelog(:? (ランチ|ディナー))?( for [^ ]+)?( (:?in|at) [^ ]+)?$/i, (msg) ->
    params = {}
    for s in msg.match
      if _.isString s
        if s.match /^ (ランチ|ディナー)/i
          params.type = RegExp.$1
          console.log 'type: ' + params.type
        else if s.match /^ for /i
          params.keyword = s.slice(5)
          console.log 'keyword: ' + params.keyword
        else if s.match /^ in /i
          params.zone = s.slice(4)
          console.log 'zone: ' + params.zone

    unless params.type
      d = new Date()
      h = d.getHours()
      if 12 < h and h < 14
        params.type = 'ランチ'
      else if 18 < h and h < 23
        params.type = 'ディナー'

    findRestaurants params, (restaurants)->
      message = "オススメのお店は見つからなかったよ…"
      if params.keyword
        message += ' for ' + params.keyword
      if params.zone
        message += ' in ' + params.zone
      restaurant = _.sample(restaurants, 1)[0]
      console.log restaurant
      if restaurant
        messages = []
        messages.push restaurant.name
        if exists(restaurant)
          messages.push restaurant.stars + ' ' + restaurant.score
        messages.push restaurant.link
        message = messages.join("\n")
      msg.send restaurant.image, message


  findRestaurants = (params, callback) ->
    qs = []
    if params.type == 'ランチ'
      qs.push 'SrtT=rtl'
    else if params.type == 'ディナー'
      qs.push 'SrtT=rtd'
    else
      qs.push 'SrtT=rt'
    if params.keyword
      qs.push 'sk=' + encodeURIComponent params.keyword
    if params.zone
      qs.push 'sa=' + encodeURIComponent params.zone

    url = endpoint + '?' + qs.join('&')
    console.log "url: " + url
    request url, (error, response, body) ->
      if !error and response.statusCode is 200
        $ = cheerio.load body
        restaurants = $('.rstlst-group').map (idx, elem)->
          $restaurant = $(this)
          return {
            name: $restaurant.find('.mname a').text(),
            link: $restaurant.find('.mname a').attr('href'),
            image: $restaurant.find('.photoimg img').attr('src'),
            score: $restaurant.find('.score-overall .score').text(),
            stars: $restaurant.find('.score-overall .star').text(),
          }
        callback restaurants
      else
        console.log error
