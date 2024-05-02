const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const firestore = admin.firestore();

exports.onUserStateChange = functions.firestore
    .document("users/{uid}/active")
    .onUpdate(async (change, context) => {
        const isActive = change.after.data().active;
        const uid = context.params.uid; // استخراج معرف المستخدم من السياق
        const firestoreRef = firestore.collection("users").doc(uid); // استخدام collection() بدلاً من doc() لمرجع مجموعة

        return firestoreRef.update({
            active: isActive,
            lastSeen: Date.now(),
        });
    });
