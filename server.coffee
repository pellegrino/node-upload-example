Formidable = require 'formidable'
http       = require 'http'
fs         = require 'fs'
url        = require 'url'
Mustache   = require 'mustache'
util       = require 'util'

uploads = []

PORT = if process.env.NODE_ENV == 'production' then '80' else '8000'

# handle static resolving
# if there is not a static with the given pathname, will resolve it as a 404
# if there is an error loading the asset, will resolve it as 500
resolveStatic = (res, staticPathName, contentType="text/html") ->
  # if static pathname is not null
  if staticPathName?
    pathName = staticPathName.toLowerCase()

    contentType = "text/css"               if pathName.indexOf(".css") != -1
    contentType = "application/javascript" if pathName.indexOf(".js")  != -1

    # finds the requested static   
    fs.readFile "./public/#{pathName}", (error, content) ->
      if error
        res.writeHead 500
        res.end()
      else
        res.writeHead 200, { "Content-Type" : contentType }
        res.end(content, 'utf-8')


http.createServer (req, res) ->
  pathname = url.parse(req.url).pathname

  # GET / upload form 
  if pathname == '/' && req.method.toLowerCase() == 'get'
    resolveStatic res, 'index.html'

  # POST /uploads process upload
  else if pathname == '/uploads' && req.method.toLowerCase() == 'post'
    form = new Formidable.IncomingForm()

    # start a new upload using the provided uploadId 
    uploadId = url.parse(req.url, true).query['uploadId']

    # track progress 
    form.on 'progress', (bytesReceived, bytesExpected) ->
      uploads[uploadId] = (bytesReceived / bytesExpected) * 100
      
    # process upload 
    form.parse req, (err, fields, files) ->
      fs.readFile "./public/uploadResult.html", 'utf-8', (error, content) ->
        res.writeHead 200, { "Content-Type" : 'text/html' }
        output = Mustache.to_html content, { upload: files['upload'], id: uploadId }
        res.end output

  else if pathname == '/progress' && req.method.toLowerCase() == 'get'
    res.writeHead 200, { "Content-Type" : 'application/json' }
    # start a new upload using the provided uploadId 
    uploadId = url.parse(req.url, true).query['uploadId']
    res.end JSON.stringify { 'progress': uploads[uploadId] }

  # its not a recognized route try to resolve as a static or throw 404
  else
    resolveStatic res, req.url

.listen(PORT)

