# app.coffee

logToConsole = ( msg ) ->
  console.log 'Triggered ' + msg
  console.log this
  return

object = {}

_.extend object, Backbone.Events

object.on 'console:log', logToConsole

object.trigger 'console:log', 'a log event'

object.off()

object.trigger 'console:log', 'a log event'
