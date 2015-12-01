{ exec } = require 'child_process'

execHandle = (after) ->
  (err, stdout, stderr) ->
    console.log stdout + stderr
    after( ( if err then 1 else 0 ) )

run = (command) ->
  (after) ->
    console.log 'RUNNING #{command}'
    exec command, execHandle after

test = (callback) ->
  woof = '''
                          ___                       ___ __ 
   .--.--.--.-----.-----.'  _.--.--.--.-----.-----.'  _|  |
   |  |  |  |  _  |  _  |   _|  |  |  |  _  |  _  |   _|__|
   |________|_____|_____|__| |________|_____|_____|__| |__|
                                                         
  '''
  console.log woof
  run( 'coffee --nodejs --harmony ./test/test.coffee' ) (code) ->
    process.exit code

task 'test', 'Run all tests', ->
  test()
            
