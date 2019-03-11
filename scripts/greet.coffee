# Description:
#   スラリンが挨拶をしてくれます
#
# Commands:
#   surarin おはよう
#   surarin おつかれ
#   surarin あそぼ
#
# Author:
#   @ginonpan


module.exports = (robot) ->

  robot.respond /おはよう/i, (msg) ->
    msg.send "おはよう！"

  robot.hear /((疲|つか)れた|(おつか|お疲)れ)/i, (msg) ->
    msg.send "おつかれ！"

  robot.respond /(あそぼ|遊ぼ)/i, (msg) ->
    rand_str = msg.random [
      "「ピキピキ」"
      "スラリン が あらわれた▼"
      "スラリン が なかまに なりたそうに こちらをみている▼"
      "へんじがない ただのしかばねのようだ▼"
      "「ぼくわるいスライムじゃないよ！」"
      "#{msg.message.user.name} は にげだした▼"
    ]
    msg.send "#{rand_str}"
