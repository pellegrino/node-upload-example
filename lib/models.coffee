class Upload
  @uploads = []

  @start: (uploadId) ->
    @uploads[uploadId] = new Upload()

  @fetch: (uploadId) ->
    return @uploads[uploadId]

  constructor: (@bytesReceived=0,@bytesExpected=0,@completed=false,@description="") ->

  progress: ->
    return 0 if @bytesReceived == 0 and @bytesExpected == 0 
    @bytesReceived / @bytesExpected  * 100
  
  complete: ->
    @progress() == 100 
  
  addProgress: (bytesReceived, bytesExpected) ->
    @bytesReceived = bytesReceived
    @bytesExpected = bytesExpected

  setFile: (file) ->
    @path = "#{file['path']}/#{file['name']}"

  getPath: ->
    @path

  getDescription: ->
    @description
  
  setDescription: (description) ->
    @description = description
    

module.exports.Upload = Upload
