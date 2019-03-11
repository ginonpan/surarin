# Description
#   スラリンが資料を管理してくれます
#
# Commands:
#   surarin docs set <name> <doc>
#   surarin <name>
#   surarin docs delete <name>
#   surarin docs list
#
# Author:
#   @ginonpan

_ = require 'lodash'

module.exports = (robot) ->
  DOCS = 'docs_data'

  # データ取得
  getData = () ->
    data = robot.brain.get(DOCS) or {}
    return data

  # データセット
  setData = (data) ->
    robot.brain.set DOCS, data

  # ドキュメント名をセット
  setDoc = (name, doc) ->
    data = getData()
    data[name] = doc
    setData(data)
    return

  # ドキュメント名を削除
  deleteDoc = (name) ->
    data = getData()
    if data[name] is undefined
      return false
    delete data[name]
    return true

  # ドキュメント名を取得
  getDoc = (name) ->
    data = getData()
    if data[name] is undefined
      return false
    else
      return data[name]

  robot.respond /docs (.+)/i, (msg) ->
    items = msg.match[1].split(/\s+/)
    head  = items[0]
    docName = items[1]

    # set, dump,deleteの場合、return
    if head is 'set' or head is 'list' or head is 'delete'
      return

    items = getDoc items[0].substring(1)
    if not items
      msg.send "登録されていない資料だよ！"
      return

    doc = _.sample items
    msg.send "#{docName}はこちら！ → #{doc}"

  # ドキュメントを設定
  robot.respond /docs set (.+)/i, (msg) ->
    items = msg.match[1].split(/\s+/)
    docName = items[0]
    doc = items[1]
    setDoc docName, doc
    msg.send "資料#{docName}を設定したよ！"

  # ドキュメントを削除
  robot.respond /docs delete (.+)/i, (msg) ->
    name = msg.match[1].split(/\s+/)[0]
    if deleteDoc name
      msg.send "資料：#{name}を削除したよ！"
    else
      msg.send "資料：#{name}は存在しないよ！"

  # for debug
  robot.respond /docs list/i, (msg) ->
    data = getData()
    if _.size(data) is 0
      msg.send "登録されている資料はないよー"
      return
    for gname, gelm of data
      msg.send "#{gname}: #{gelm.join()}"
