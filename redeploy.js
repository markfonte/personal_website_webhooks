const express = require('express')
const app = express()
const port = 6969
const { exec } = require('child_process');

app.post('/webhook', (req, res) => {
	exec('./redeploy_script.sh start', (err, stdout, stderr) => {console.log(stdout);});
	res.sendStatus(200);
})

app.listen(port, () => console.log(`Redeploy script listening on port ${port}!`))
