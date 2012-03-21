vows = require('vows')
assert = require('assert')

Upload = require('../lib/models').Upload

vows
  .describe("Upload")
  .addBatch
    "when starting a new upload":
      topic: Upload.start('1')

      "it should be 0 percent done": (topic) ->
        assert.equal topic.progress(), 0

      "it should not be marked as complete": (topic) ->
        assert.equal topic.complete(), false

      "it should not have any description": (topic) ->
        assert.equal topic.getDescription() , ''


    "when setting description":
      topic: new Upload()

      "it should set this description": (topic) ->
        topic.setDescription('updated description')
        assert.equal topic.getDescription() , 'updated description'

    "when adding progress":
      topic: Upload.new

      "it should calculate the percentage done": (topic) ->
        upload = Upload.start('42')
        upload.addProgress(10, 100)
        assert.equal upload.progress(), 10

        upload.addProgress(50, 100)
        assert.equal upload.progress(), 50

        upload.addProgress(62, 100)
        assert.equal upload.progress(), 62


      "when it is 100 percent done it should be complete": (topic) ->
        upload = Upload.start('43')
        upload.addProgress(2400,2400)
        assert.equal upload.complete(), true

    "when assgining it a incoming file":
      topic: ->
        upload = Upload.start('100')
        upload.setFile({ path: '/foo', name: 'bar.mp3'})
        upload

      'it should set this upload path': (topic) -> 
        assert.equal topic.getPath(), '/foo/bar.mp3'

    "when fetching for a upload": ->

      "it should return the correct upload": ->
        upload1 = Upload.start('1')
        upload2 = Upload.start('2')
        upload3 = Upload.start('3')

        assert.equal    Upload.fetch('1'), upload1
        assert.notEqual Upload.fetch('2'), upload1

    "when coverting to JSON": ->
      topic: ->
        upload = Upload.start('101')
        upload.addProgress(100, 200)
        upload.setDescription('great song')
   
  
  .export(module)
