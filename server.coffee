Formidable = require 'formidable'
http       = require 'http'
fs         = require 'fs'
util       = require 'util'
Mustache   = require 'mustache'


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
  # GET / upload form 
  if req.url == '/' && req.method.toLowerCase() == 'get'
    resolveStatic res, 'index.html'

  # POST /uploads process upload
  else if req.url == '/uploads' && req.method.toLowerCase() == 'post'
    form = new Formidable.IncomingForm()
    form.parse req, (err, fields, files) ->
      fs.readFile "./public/uploadResult.html", 'utf-8', (error, content) ->
        res.writeHead 200, { "Content-Type" : 'text/html' }
        output = Mustache.to_html content, files['upload']
        res.end output 

  else if req.url == '/progress' && req.method.toLowerCase() == 'get'
    res.writeHead 200, { "Content-Type" : 'text/plain' }

  # its not a recognized route try to resolve as a static or throw 404
  else
    resolveStatic res, req.url 

.listen(8000)

