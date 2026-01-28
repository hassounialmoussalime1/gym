const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

// إشعار للأدمن عند إنشاء Order جديد
exports.onNewOrder = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    try {
      const orderId = event.params.orderId;

      const db = getFirestore();

      const adminTokenDoc = await db
        .collection("adminTokens")
        .doc("main_admin")
        .get();

      if (!adminTokenDoc.exists) {
        console.log("Admin token doc not found.");
        return;
      }

      const adminToken = adminTokenDoc.data().token;

      if (!adminToken) {
        console.log("Admin FCM token not found.");
        return;
      }

      const message = {
        token: adminToken,
        notification: {
          title: "📦 New Order",
          body: `A new order (#${orderId}) has been created.`,
        },
      };

      await getMessaging().send(message);
      console.log("Admin notification sent:", orderId);
    } catch (err) {
      console.error("Error sending admin notification:", err);
    }
  }
);
