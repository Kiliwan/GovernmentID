const express = require('express');
const app = express()
app.use(express.json()); //Used to parse JSON bodies
var exec = require('child_process').exec;

app.get("/", function(request, response) {
  response.send("OK 1")
})

app.get("/get-info", function (request, response) {

  function puts(error, stdout, stderr) { sys.puts (stdout) }
  exec('multichain-cli chain2 getinfo', function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.post("/new-asset", function (request, response) {
  var first_name = request.body.first_name
  var last_name = request.body.last_name
  var date_of_birth = request.body.date_of_birth
  var documents = request.body.documents
  var hash = request.body.hash
  var stream_hash = request.body.stream_hash

  function puts(error, stdout, stderr) { sys.puts (stdout) }

  var id = ""
  var param = `'{"name":"${hash}", "open":true,"restrict":"send,receive"}'`
  var custom = `'{"first_name":"${first_name}","last_name":"${last_name}","dob":"${date_of_birth}","documents":${documents},"stream":"${stream_hash}"}'`

  var command = `multichain-cli chain2 issue ${id} ${param} 1 1 0 ${custom}`

  exec(command, function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.get("/list-assets", function (request, response) {

  function puts(error, stdout, stderr) { sys.puts (stdout) }
  exec('multichain-cli chain2 listassets', function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.post("/new-stream", function (request, response) {
  var stream_hash = request.body.stream_hash

  function puts(error, stdout, stderr) { sys.puts (stdout) }

  command = `multichain-cli chain2 create stream ${stream_hash} true`

  exec(command, function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.get("/list-streams", function (request, response) {

  function puts(error, stdout, stderr) { sys.puts (stdout) }
  exec('multichain-cli chain2 liststreams', function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.post("/new-publication", function (request, response) {
  var stream_hash = request.body.stream_hash
  var key = request.body.key
  var data = request.body.data

  function puts(error, stdout, stderr) { sys.puts (stdout) }

  command = `multichain-cli chain2 publish ${stream_hash} ${key} '${data}'`

  exec(command, function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.get("/list-publications", function (request, response) {
  var stream_hash = request.query.stream_hash

  function puts(error, stdout, stderr) { sys.puts (stdout) }

  command = `multichain-cli chain2 liststreamitems ${stream_hash}`

  exec(command, function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

app.get("/list-publishers", function (request, response) {

  function puts(error, stdout, stderr) { sys.puts (stdout) }

  command = `multichain-cli chain2 liststreamitems root`

  exec(command, function(error, stdout, stderr) {
    if (!error) {
      // It worked!
      console.log(stdout)
      response.header("Content-Type", "application/json");
      const result = JSON.stringify(stdout);
      response.send(JSON.parse(result));
    } else {
      // Didn't worked
      console.log(error)
      response.send({message: "There was an error"})
    }
  });
});

const server = app.listen(3001, () => console.log('Server is up and running'))
