import express from 'express';
const app = express()
const port = 6969
import { exec } from 'child_process';

app.post('/webhook', (req, res) => {
	exec('./redeploy_script.sh start >> output.log 2>&1', (err, stdout, stderr) => { console.log(stdout); });
	res.sendStatus(200);
})

app.listen(port, () => console.log(`Redeploy script listening on port ${port}!`))
