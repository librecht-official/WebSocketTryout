"use strict";

const WebSocketServer = require('websocket').server;
const http = require('http');
const { v4: uuid } = require('uuid');

const server = http.createServer(function(request, response) {});
server.listen(80, function() { });

const wsServer = new WebSocketServer({
  httpServer: server
});

var clients = [];
var history = [];

wsServer.on('request', function(request) {
  var connection = request.accept(null, request.origin);
  var index = clients.push(connection) - 1;
  var userName = false;

  console.log('new connection ' + connection.remoteAddress)

  // send back history
  if (history.length > 0) {
    connection.sendUTF(JSON.stringify({ type: 'history', data: history } ));
  }

  connection.on('message', function(message) {
    if (message.type === 'utf8') {
      // first message must be username
      if (userName === false) {
        userName = message.utf8Data

        console.log((new Date()) + ' new user: ' + userName)
      } else {
        console.log((new Date()) + ' new message ' + userName + ': ' + message.utf8Data)
        
        // save message
        var obj = {
          id: uuid(),
          timestamp: (new Date()).getTime(),
          sender: userName,
          text: message.utf8Data
        };
        history.push(obj);
  
        // broadcast message to all connected clients
        var json = JSON.stringify({ type: 'message', data: obj });
        for (var i = 0; i < clients.length; i++) {
          clients[i].sendUTF(json);
        }
      }
    }
  });

  connection.on('close', function(connection) {
    console.log(userName + ' disconnected')

    clients.splice(index, 1);
  });
});