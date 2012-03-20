formidable = require 'formidable'
http = require 'http'
fs   = require 'fs'

resolveStatic = (res, static) ->
  fs.readFile "./public/#{static}", (error, content) ->
    if error
      res.writeHead 500
      res.end() 
    else 
      res.writeHead 200, { "Content-Type" : "text/html" } 
      res.end(content, 'utf-8')
  

http.createServer (req, res) ->

  # upload form 
  if req.url == '/' && req.method.toLowerCase() == 'get'
    resolveStatic res, 'index.html'

  # its not a recognized route 
  else
    resolveStatic res, '404.html'

.listen(8000)

