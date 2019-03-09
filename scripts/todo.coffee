# Description:
#   TODO管理機能
#
# Commands:
#   hubot todo add TASK
#   hubot todo list
#   hubot todo done N
#
# Author:
#   @ginonpan

module.exports = (robot) ->
  TODO = 'todo_list'

  # データ取得
  getTodo = () ->
    data = robot.brain.get(TODO) or {}
    return data["todo"] or []

  # リストからタスクを追加
  addTodo = (todo) ->
    data  = getTodo()
    data.push(todo)
    robot.brain.set TODO, {"todo": data}
    return true

  # リストからタスクを削除
  removeTodo = (index) ->
    data = getTodo()
    if data.length < index
      return false
    todo = data[index-1]
    data.splice(index-1, 1)
    robot.brain.set TODO, {"todo": data}
    return todo

  # リスト表示
  robot.respond /todo list$/i, (msg) ->
    data = getTodo()
    if data.length == 0
      msg.send "TODOはないよ！"
      return
    else
      msg.send "TODOリストだよ！"

    for todo, index in data
      msg.send "#{index+1}: #{todo}"
    return

  # タスクを追加
  robot.respond /todo add (.+)/i, (msg) ->
    todo = msg.match[1].split(/\s+/)[0]
    if addTodo(todo)
      msg.send "TODO \"#{todo}\"を追加したよ！"
    else
      msg.send "TODOの登録に失敗したよ！"

  # タスクを削除
  robot.respond /todo done (\d)/i, (msg) ->
    index = msg.match[1]
    if removeTodo(index)
      msg.send "TODOを削除したよ！"
    else
      msg.send "TODOの削除に失敗しました！"
