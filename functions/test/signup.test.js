const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const vm = require("node:vm");
const functions = require("firebase-functions/v1");

test("signup preserves the v1 trigger and writes before granting claims",
    async (t) => {
      const previousProject = process.env.GCLOUD_PROJECT;
      process.env.GCLOUD_PROJECT = "demo-signup-test";
      t.after(() => {
        if (previousProject === undefined) {
          delete process.env.GCLOUD_PROJECT;
        } else {
          process.env.GCLOUD_PROJECT = previousProject;
        }
      });
      const calls = [];
      const timestamp = Symbol("server timestamp");
      const firestore = () => ({
        collection: (name) => ({
          doc: (uid) => ({
            set: async (data) => calls.push({name, uid, data}),
          }),
        }),
      });
      firestore.FieldValue = {serverTimestamp: () => timestamp};
      const admin = {
        initializeApp: () => calls.push("initialize"),
        firestore,
        auth: () => ({
          setCustomUserClaims: async (uid, claims) => calls.push({uid, claims}),
        }),
      };
      const context = {
        exports: {},
        require: (name) => {
          if (name === "firebase-admin") return admin;
          if (name === "firebase-functions/v1") {
            return functions;
          }
          throw new Error(`Unexpected dependency: ${name}`);
        },
      };
      vm.runInNewContext(
          fs.readFileSync(path.join(__dirname, "../index.js"), "utf8"),
          context);
      const signup = context.exports.setUserRoleOnSignup;
      assert.equal(signup.__endpoint.platform, "gcfv1");
      assert.equal(signup.__trigger.eventTrigger.eventType,
          "providers/firebase.auth/eventTypes/user.create");
      await signup.run({
        uid: "test-user", email: "user@example.com",
      });

      assert.equal(calls[0], "initialize");
      assert.equal(calls[1].name, "users");
      assert.equal(calls[1].uid, "test-user");
      assert.equal(calls[1].data.email, "user@example.com");
      assert.equal(calls[1].data.role, "user");
      assert.equal(calls[1].data.createdAt, timestamp);
      assert.equal(calls[2].uid, "test-user");
      assert.equal(calls[2].claims.role, "user");
      assert.equal(calls.length, 3);

      const writeError = new Error("Firestore unavailable");
      admin.firestore = () => ({
        collection: () => ({
          doc: () => ({set: async () => {
            throw writeError;
          }}),
        }),
      });
      admin.firestore.FieldValue = firestore.FieldValue;
      await assert.rejects(signup.run({uid: "test-user"}), writeError);
      assert.equal(calls.length, 3,
          "failed writes must not grant custom claims");
    });
