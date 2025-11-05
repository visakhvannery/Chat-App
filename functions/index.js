const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendChatNotification = functions.database
  .ref("/chats/{chatId}/messages/{messageId}")
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.val();
    const senderId = messageData.senderId;
    const text = messageData.text;

    // Get receiver ID from chatId (assuming chatId = userA_userB sorted alphabetically)
    const [userA, userB] = context.params.chatId.split("_");
    const receiverId = senderId === userA ? userB : userA;

    // Get receiver’s FCM token
    const userSnap = await admin.database().ref(`/users/${receiverId}`).once("value");
    const receiver = userSnap.val();

    if (!receiver || !receiver.fcmToken) {
      console.log("Receiver has no FCM token.");
      return null;
    }

    const payload = {
      notification: {
        title: "New message",
        body: text,
      },
      data: {
        senderId: senderId,
        chatId: context.params.chatId,
      },
    };

    // Send notification
    await admin.messaging().sendToDevice(receiver.fcmToken, payload);
    console.log(`Notification sent to ${receiverId}`);

    return null;
  });
