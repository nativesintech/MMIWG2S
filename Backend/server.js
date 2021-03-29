console.log('May Node be with you');

const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.listen(3000, function() {
    console.log('listening on 3000');
});

// app.get('/', (request, response) => {
//     response.send('Hello World')
// });

app.get('/', (request, response) => {
  response.sendFile(__dirname + '/index.html');
});

app.post('/userinfo', (request, response) => {
  console.log('Give me your userinfo, please.');
  console.log(request.body);
});
