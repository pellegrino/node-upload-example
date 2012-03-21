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
      topic: Upload.start('42')

      "it should calculate the percentage done": (topic) ->
        topic.updateProgress(10, 100)
        assert.equal topic.progress(), 10

        topic.updateProgress(50, 100)
        assert.equal topic.progress(), 50

        topic.updateProgress(62, 100)
        assert.equal topic.progress(), 62

      "changes should be persistent": (topic) ->
        topic.updateProgress(48, 100)
        retrieved_upload = Upload.fetch '42'
        assert.equal retrieved_upload.progress(), 48

      "when 100 percent done":

        "it should be complete": ->
          upload = new Upload()
          upload.updateProgress(2400,2400)
          assert.equal upload.complete(), true

    "when assgining it a incoming file":
      topic: ->
        upload = Upload.start('100')
        upload.updateFile({ path: '/foo', name: 'bar.mp3'})
        upload

      'it should set this upload path': (topic) -> 
        assert.equal topic.getPath(), '/foo/bar.mp3'

      'it should persist this change back to the current uploads': ->
        upload = Upload.start('200')
        upload.updateFile({ path: '/foo', name: 'bar.mp3'})

        retrievedUpload = Upload.fetch('200')
        assert.equal retrievedUpload.getPath() , '/foo/bar.mp3'

    "when fetching for a upload": 

      "it should return the correct upload": (topic) ->
        upload1 = Upload.start('1')
        upload2 = Upload.start('2')
        upload3 = Upload.start('3')

        assert.equal    Upload.fetch('1'), upload1
        assert.notEqual Upload.fetch('2'), upload1
    
    "when converting to JSON":
      topic: ->
        upload = Upload.start('123') 
        upload.updateProgress 10, 100
        upload.updateFile({ path: '/foo', name: 'bar.mp3'})
        upload.setDescription 'great song, i must say'

        JSON.parse upload.toJSON()

      "it should parse uploadId": (topic) ->
        assert.equal topic['uploadId'], '123'

      "it should parse file path": (topic) ->
        assert.equal topic['path'], '/foo/bar.mp3'

      "it should parse description": (topic) ->
        assert.equal topic['description'], 'great song, i must say'

      "it should parse progress": (topic) ->
        assert.equal topic['progress'],  10


  .export(module)
