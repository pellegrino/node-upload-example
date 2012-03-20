vows = require('vows')
assert = require('assert')

Upload = require('../lib/models').Upload

vows
  .describe("Upload")
  .addBatch
    "when starting a new upload":
      topic: new Upload(1, 2, false)

      "assigns a bytesReceived": (topic) ->
        assert.equal topic.bytesReceived , 1

      "assigns a bytesExpected": (topic) ->
        assert.equal topic.bytesExpected , 2

      "assigns a completed flag": (topic) ->
        assert.equal topic.completed , false

      "it should be 50 percent done": (topic) ->
        assert.equal topic.progress(), 0.5

    "when completing a upload":
      topic: ->
        upload = new Upload(1,2,false)
        upload.complete()
        upload

      "marks it as completed": (topic) ->
        assert.equal topic.completed, true

    "when adding progress to a upload": 
      topic: ->
        upload = new Upload()
        upload.addProgress(100, 200)
        upload 

      "should be 50 percent done": (topic) ->
        assert.equal topic.progress() , 0.5
  
  .export(module)
