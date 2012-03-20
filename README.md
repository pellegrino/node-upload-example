# Upload

It is a small project created to demonstrate non blocking uploads with a minimum set of dependencies. 

## Techonology stack 

* node.js
* node-formidable - to handle multipart uploads 
* mustache.js - Logic less template engine
* jquery 
* vows - to write tests 

## Installation 

_TODO_ 

## Running

_TODO_ 

## Demo 
 
_TODO_ 

## Considerations in a real world scenario

Polling is definitely not well suited for real world scenario. In a production environment i would probably opt for a web socket kind of solution to avoid polling the application server.
