class Upload
  constructor: (@bytesReceived=0,@bytesExpected=0,@completed=false) ->

  progress: ->
    @bytesReceived / @bytesExpected 

  complete: ->
    @completed = true
  
  addProgress: (bytesReceived, bytesExpected) ->
    @bytesReceived = bytesReceived
    @bytesExpected = bytesExpected

module.exports.Upload = Upload
