import crypto from 'crypto';
import express from 'express';
import { exec } from 'child_process';

const app = express()
const port = 6969

try {
	process.loadEnvFile('.env');
} catch (err) {
	if (err.code !== 'ENOENT' && err.code !== 'ERR_ENOENT') {
		throw err;
	}
}
const secret = process.env.WEBHOOK_SECRET || '';
if (!secret) {
	console.warn('WEBHOOK_SECRET is not set, so every webhook request will be rejected');
}

function isSignedByGitHub(req) {
	if (!secret || !Buffer.isBuffer(req.body)) {
		return false;
	}
	const expected = Buffer.from('sha256=' + crypto.createHmac('sha256', secret).update(req.body).digest('hex'));
	const received = Buffer.from(req.get('X-Hub-Signature-256') || '');
	return received.length === expected.length && crypto.timingSafeEqual(received, expected);
}

app.post('/webhook', express.raw({ type: '*/*', limit: '1mb' }), (req, res) => {
	if (!isSignedByGitHub(req)) {
		return res.sendStatus(401);
	}
	if (req.get('X-GitHub-Event') !== 'push' || JSON.parse(req.body).ref !== 'refs/heads/main') {
		return res.sendStatus(204);
	}
	exec('./redeploy_script.sh start >> output.log 2>&1', (err, stdout, stderr) => { console.log(stdout); });
	res.sendStatus(200);
})

app.listen(port, () => console.log(`Redeploy script listening on port ${port}!`))
