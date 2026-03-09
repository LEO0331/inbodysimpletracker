const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Trigger when a new user signs up
exports.setUserRoleOnSignup = functions.auth.user().onCreate(async (user) => {
  const userId = user.uid;
  const email = user.email;

  // Create a Firestore document for the new user
  await admin.firestore().collection("users").doc(userId).set({
    email: email,
    role: "user",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Optionally, also set a custom claim for security rules
  await admin.auth().setCustomUserClaims(userId, {role: "user"});

  console.log(`User ${email} created with role=user`);
});
