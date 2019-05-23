const express = require('express')
const app = express()
const port = 6969
const { exec } = require('child_process');

app.post('/webhook', (req, res) => {
		exec('./redeploy_script.sh start', (err, stdout, stderr) => {console.log(stdout);});
	}
)

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
