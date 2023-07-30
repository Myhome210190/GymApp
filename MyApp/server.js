const express = require('express');
const path = require('path');

const app = express();
app.use(express.static(__dirname + '/views'));
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname + '/views/MuscleMintHomePage.html'));
});
app.get('/about.html', (req, res) => {
  res.sendFile(path.join(__dirname + '/views/LinkWalletPage.html'));
});
app.get('/register.html', (req, res) => {
  res.sendFile(path.join(__dirname + '/views/ShopPage.html'));
});

// serving the index.html file

const server = app.listen(process.env.PORT || 5000);
const portNumber = server.address().port;
console.log(`port: ${portNumber}`);
// can see the port number in terminal - you can dictate the port number
