
{spawn} = require "child_process"

echo = (child) ->
  child.stderr.pipe process.stderr
  child.stdout.pipe process.stdout

split = (string) -> string.split " "
filled = (string) -> string.length > 0

tasks = {}

exports.do = (_, queue...) ->
  queue.map(split).forEach (array, index) ->
    console.log '➤➤', queue[index]
    echo (spawn array[0], array[1..])

exports.add = (name, queue...) ->
  tasks[name] = ->
    queue.map(split).forEach (array, index) ->
      console.log '➤➤', queue[index]
      echo (spawn array[0], array[1..])

exports.go = ->
  query = process.argv[2]
  # console.log 'go', query, tasks
  if query?
    for name, task of tasks
      if name.indexOf(query) >= 0
        do task