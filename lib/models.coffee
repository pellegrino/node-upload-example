class Upload
  @uploads = []

  @start: (uploadId) ->
    @uploads[uploadId] = new Upload()
    @uploads[uploadId].uploadId = uploadId

    @uploads[uploadId]

  @fetch: (uploadId) ->
    return @uploads[uploadId]

  constructor: (@bytesReceived=0,@bytesExpected=0,@completed=false,@description="") ->

  progress: ->
    return 0 if @bytesReceived == 0 and @bytesExpected == 0 
    @bytesReceived / @bytesExpected  * 100
  
  complete: ->
    @progress() == 100 
  
  updateProgress: (bytesReceived, bytesExpected) ->
    @bytesReceived = bytesReceived
    @bytesExpected = bytesExpected

  updateFile: (file) ->
    @path = "#{file['path']}/#{file['name']}"

  getPath: ->
    @path

  getDescription: ->
    @description
  
  setDescription: (description) ->
    @description = description

  toJSON: ->
    JSON.stringify {
      uploadId: @uploadId,
      progress: @progress(),
      description: @getDescription(),
      path: @getPath()
    }


    

module.exports.Upload = Upload
