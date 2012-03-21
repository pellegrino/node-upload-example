# Node Upload Example 

It is a small project created to demonstrate non blocking uploads with a minimum set of dependencies. 

## Solution

In order to conform with the requirements, my solution was to create a small web server which is responsible to handled file uploads and progress polling in an asynchronous fashion, so it can support concurrent uploads from different users. 

For the sake of simplicity and also due the restriction of only the port 80 being allowed, i didn't use websockets or socket.io, so my solution was to implement polling. 

At the clients, i've used custom triggers to create a publisher subscriber pattern, so i could handle those events separately from where they were triggered.

### Points of interest 

To make easier to fast scan the application, i've highlighted here the main points of interest of the solution. 

For client side functions, check [public/js/upload.js](https://github.com/pellegrino/node-upload-example/blob/master/public/js/upload.js). In this file i handle the ids creation and most of the client side scripting. 

The trigger that informs that a given upload was finished is created at [/public/uploadResult.html](https://github.com/pellegrino/node-upload-example/blob/master/public/uploadResult.html). 

The server is implemented at [server.coffee](https://github.com/pellegrino/node-upload-example/blob/master/server.coffee).

There is also a quite simple model [lib/models.coffee](https://github.com/pellegrino/node-upload-example/blob/master/lib/models.coffee) to represent uploads. That deals with storing, fetching and creating new upload's information. 

## Techonology stack 

### Coffeescript

Being coffeescript is a powerful language that compiles to (really nice) Javascript code, it was my weapon of choice for this project, since it made the code much more concise and also made sure that it was 

###  Node.js

Given the requirement for the solution to handle simultaneous download, node.js was a quite happy choice, given the event oriented aspect of the platform. Using it i could make the file uploads async, so the project.

I also didn't have much experience with both Node.js and Coffescript, so my curiosity to get something written with those tools was also a big plus for this choice. :)


## Dependencies

### Node-formidable

I've opt for using it since it made handling file uploads easier. I could have rolled the multipart binary parsing on my own, but i thought it would increase the amount of code at a point that it could get distracting for the purpose of this example. 

### Mustache.js

I've used it also very lightly, only at the upload response view i needed to make it dynamic. I also could have rolled my own here, but i thought it would be *okay* to use it. But after finishing, i'm starting to think i should have implemented a simple regex substitution to get rid of this additional dependency. :cry:


### jQuery & jQuery-UI 

Used it to write the client side javascript and used jQuery-UI to create the progress bar. 

### Vows

I normally use tests to drive the design of my solotuins. In this case, i've used vows to drive the implementation of my Upload model. I have never used Vows at the past but it ended up being a pleasant experience to write tests using it. 

## Installation 

The dependencies are listed using node's package.json file. Assuming you have both node and npm installed and available at your path, running the command below will get everything ready to use. 

      npm install 

This project was developed using the following versions

      ➜  upload git:(master) ✗ node -v 
      v0.6.13-pre
      ➜  upload git:(master) ✗ npm -v 
      1.1.4


### Running

Run the command below to get your server started. You might have to add coffescript to your path.

      ➜  upload git:(master) ✗ coffee server.coffee

No output is expected from the server, but you can access the application at [http://localhost:8000](http://localhost:8000/)


#### Testing suite

Assuming you have all the dependencies installed and vows Run the following command to run the specs. 

      vows --spec

## Demo 

This application is deployed at [http://node-upload-example.herokuapp.com/](http://node-upload-example.herokuapp.com/), using the Heroku cedar stack. 
 
## What was left out

There are a few things that were not covered in this example.

### Acceptance & Integration tests  

(:cry:)

### Persistence 

Also, no sort of database or persistence layer were used. The upload's informations are stored at memory, and the actual uploaded file is being persisted at the Heroku Cedar's ephemeral filesystem.

This example relies on the ephemeral filesystem provided by the Heroku Cedar stack, which means that persistent storage can not be taken by granted. For more information regarding to this, check the [heroku docs](http://devcenter.heroku.com/articles/dyno-isolation#ephemeral_filesystem)

###  Download of the uploaded file

Also, i assumed downloading the file was outside the scope of this demo project.

## Considerations in a real world scenario

Polling is definitely not well suited for real world scenario. In a production environment i would probably opt for a web socket kind of solution to avoid polling the application server.

Also some form of accessing the uploaded file is something that should be taken care at a production app. 

## Credits

Vitor Pellegrino <vitorp@gmail.com> , March, 2012
@pellegrino

