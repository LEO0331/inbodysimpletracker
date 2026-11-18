import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { test } from 'node:test';

// Run using firebase emulators:exec --only auth,firestore --project demo-inbody-rules.
const project = process.env.GCLOUD_PROJECT;
assert.equal(project, 'demo-inbody-rules', 'Use the demo project for rules tests');

function emulatorOrigin(variable) {
  const host = process.env[variable];
  assert.match(host ?? '', /^(?:127\.0\.0\.1|localhost):\d+$/, `${variable} must be a local emulator`);
  return `http://${host}`;
}

const auth = `${emulatorOrigin('FIREBASE_AUTH_EMULATOR_HOST')}/identitytoolkit.googleapis.com/v1`;
const database = `projects/${project}/databases/(default)/documents`;
const firestore = `${emulatorOrigin('FIRESTORE_EMULATOR_HOST')}/v1/${database}`;
const authKey = '?key=emulator-key';

async function request(expected, url, { method = 'GET', body, token } = {}) {
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers.Authorization = `Bearer ${token}`;
  const response = await fetch(url, { method, headers, body: JSON.stringify(body) });
  const payload = await response.json();
  assert.equal(response.status, expected, `${method} ${url}: ${payload.error?.message ?? ''}`);
  return payload;
}

async function createUser(role) {
  const email = `${randomUUID()}@example.test`;
  const credentials = { email, password: randomUUID(), returnSecureToken: true };
  const user = await request(200, `${auth}/accounts:signUp${authKey}`, {
    method: 'POST', body: credentials,
  });
  if (role) {
    await request(200, `${auth}/projects/${project}/accounts:update`, {
      method: 'POST', token: 'owner',
      body: { localId: user.localId, customAttributes: JSON.stringify({ role }) },
    });
    const session = await request(200, `${auth}/accounts:signInWithPassword${authKey}`, {
      method: 'POST', body: credentials,
    });
    user.idToken = session.idToken;
  }
  return { email, profile: `users/${user.localId}`, token: user.idToken };
}

function read(expected, path, token) {
  return request(expected, `${firestore}/${path}`, { token });
}

function patch(expected, path, token, fields) {
  return request(expected, `${firestore}/${path}`, { method: 'PATCH', token, body: { fields } });
}

function remove(expected, path, token) {
  return request(expected, `${firestore}/${path}`, { method: 'DELETE', token });
}

function readWeek(expected, profile, token, collection, fieldPath) {
  const filters = [
    ['GREATER_THAN_OR_EQUAL', '2026-11-16T00:00:00Z'],
    ['LESS_THAN', '2026-11-23T00:00:00Z'],
  ].map(([op, timestampValue]) => ({ fieldFilter: {
    field: { fieldPath }, op, value: { timestampValue },
  } }));
  return request(expected, `${firestore}/${profile}:runQuery`, {
    method: 'POST', token,
    body: { structuredQuery: {
      from: [{ collectionId: collection }],
      where: { compositeFilter: { op: 'AND', filters } },
      orderBy: [{ field: { fieldPath }, direction: 'DESCENDING' }],
      limit: 21,
    } },
  });
}

function setProfile(expected, { profile, token, email }, role = 'user', extraFields = {}) {
  return request(expected, `${firestore}:commit`, {
    method: 'POST', token,
    body: { writes: [{
      update: { name: `${database}/${profile}`, fields: {
        email: { stringValue: email },
        role: { stringValue: role },
        ...extraFields,
      } },
      updateTransforms: [{ fieldPath: 'createdAt', setToServerValue: 'REQUEST_TIME' }],
    }] },
  });
}

test('Firestore keeps signup, owner data and admin operations within their access boundaries', async () => {
  const owner = await createUser();
  const other = await createUser();
  const admin = await createUser('admin');
  const report = `${owner.profile}/reports/sample`;
  const checkpoint = `${owner.profile}/checkpoints/sample`;

  await setProfile(403, owner, 'admin');
  await setProfile(403, { ...owner, email: other.email });
  await setProfile(403, owner, 'user', { extra: { booleanValue: true } });
  await setProfile(200, owner);
  await setProfile(200, owner); // The app may follow a profile write from the signup trigger.
  await setProfile(403, owner, 'admin');
  await remove(403, owner.profile, owner.token);
  await read(200, owner.profile, owner.token);
  await read(403, owner.profile, other.token);
  await read(403, owner.profile);
  await read(403, 'users', owner.token);
  await read(200, 'users', admin.token);

  // Test a preexisting privileged-looking document without an admin token.
  await patch(200, other.profile, 'owner', {
    email: { stringValue: other.email }, role: { stringValue: 'admin' },
  });
  await read(403, 'users', other.token);

  const date = { timestampValue: '2026-11-17T08:00:00Z' };
  await patch(200, report, owner.token, { reportDate: date, weight: { doubleValue: 70 } });
  await patch(200, `${report}-owner`, owner.token, { reportDate: date });
  await patch(200, checkpoint, owner.token, { checkpointDate: date, exerciseName: { stringValue: 'Squat' } });
  await patch(200, checkpoint, owner.token, { checkpointDate: date, exerciseName: { stringValue: 'Bench press' } });

  for (const collection of ['reports', 'checkpoints']) {
    await read(200, `${owner.profile}/${collection}`, owner.token);
    await read(403, `${owner.profile}/${collection}`, other.token);
    await read(403, `${owner.profile}/${collection}`);
  }

  const weeklyReports = await readWeek(200, owner.profile, owner.token, 'reports', 'reportDate');
  const weeklyCheckpoints = await readWeek(200, owner.profile, owner.token, 'checkpoints', 'checkpointDate');
  assert.equal(weeklyReports.filter((result) => result.document).length, 2);
  assert.equal(weeklyCheckpoints.filter((result) => result.document).length, 1);
  await readWeek(403, owner.profile, other.token, 'reports', 'reportDate');

  await read(200, `${owner.profile}/reports`, admin.token);
  await read(403, `${owner.profile}/checkpoints`, admin.token);
  await patch(403, report, other.token, { weight: { doubleValue: 10 } });
  await patch(403, `${owner.profile}/reports/admin`, admin.token, { reportDate: date });
  await remove(403, report, other.token);
  await remove(403, checkpoint, other.token);
  await remove(403, checkpoint, admin.token);
  await remove(200, report, admin.token);
  await remove(200, `${report}-owner`, owner.token);
  await remove(200, checkpoint, owner.token);
});
