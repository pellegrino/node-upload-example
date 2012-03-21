Formidable = require 'formidable'
http       = require 'http'
fs         = require 'fs'
url        = require 'url'
Mustache   = require 'mustache'

uploads = []

PORT = process.env.PORT || '8000'

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

  # GET / displayes the static upload form 
  if pathname == '/' && req.method.toLowerCase() == 'get'
    resolveStatic res, 'index.html'

  # POST /uploads processes uploads
  else if pathname == '/uploads' && req.method.toLowerCase() == 'post'
    form = new Formidable.IncomingForm()

    # start a new upload using the provided uploadId 
    uploadId = url.parse(req.url, true).query['uploadId']
    uploads[uploadId] =  { 'progress': 0, 'description': '' , 'path': '', 'id': uploadId}

    # track progress 
    form.on 'progress', (bytesReceived, bytesExpected) ->
      uploads[uploadId]['progress'] = (bytesReceived / bytesExpected) * 100
      
    # process upload 
    form.parse req, (err, fields, files) ->
      fs.readFile "./public/uploadResult.html", 'utf-8', (error, content) ->
        res.writeHead 200, { "Content-Type" : 'text/html' }
        uploads[uploadId]['path'] = "#{files['upload']['path']}/#{files['upload']['name']}"
        output = Mustache.to_html content, { upload: uploads[uploadId] }
        res.end output

  # POST /uploads/description
  else if pathname == '/uploads/description' && req.method.toLowerCase() == 'post'
    # updates given upload with the provided description
    form = new Formidable.IncomingForm()

    form.parse req, (err, fields, files) ->
      uploadId = fields['uploadId']
      uploads[uploadId]['description'] = fields['description']
      res.writeHead 200, { "Content-Type" : "application/json" } 
      res.end JSON.stringify(uploads[uploadId])

  # GET /progress?uploadId=42 
  else if pathname == '/progress' && req.method.toLowerCase() == 'get'
    res.writeHead 200, { "Content-Type" : 'application/json' }
    # start a new upload using the provided uploadId 
    uploadId = url.parse(req.url, true).query['uploadId']
    # If the file didn't even start to get uploaded, mark it as 0 percent done
    if uploads[uploadId]?
      res.end JSON.stringify { 'progress': uploads[uploadId]['progress'] }
    else
      res.end JSON.stringify { 'progress': 0 }

  # its not a recognized route try to resolve as a static or throw 404
  else
    resolveStatic res, req.url

.listen(PORT)
