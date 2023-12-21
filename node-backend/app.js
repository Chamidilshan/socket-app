const express = require('express');

const app = express(); 

const PORT = process.env.PORT || 4000; 

const server = app.listen(PORT, () => {
  console.log(`Server is running on`, PORT);
});
 
const io = require('socket.io')(server, {cors: { origin: "*"}});
 
io.on('connection', (socket) => {  
  console.log('connected', socket.id);
  socket.on('disconnect', () => {    
    console.log('disconnected', socket.id);
  });
 
  socket.on('message', (data) => { 
    console.log(data);  
    socket.broadcast.emit('message-receive', data); 
  }); 

  
});     