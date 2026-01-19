const { onCall } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { setGlobalOptions } = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Set global options
setGlobalOptions({ region: "us-east4", maxInstances: 10 });

/**
 * Scheduled function to reset orderIndex for all restaurants
 * Runs every day at 12:00 AM (00:00)
 */
exports.scheduledResetOrderIndex = onSchedule("0 0 * * *", async (event) => {
  const restaurantsCol = admin.firestore().collection("restaurants");
  
  try {
    const snapshot = await restaurantsCol.get();
    const batch = admin.firestore().batch();
    
    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { orderIndex: 0 });
    });
    
    await batch.commit();
    console.log(`Successfully reset orderIndex for ${snapshot.size} restaurants.`);
  } catch (error) {
    console.error("Error in scheduled reset orderIndex:", error);
  }
});

exports.resetRestaurantsOrderIndex = onCall(async (request) => {
  const restaurantsCol = admin.firestore().collection("restaurants");
  
  try {
    const snapshot = await restaurantsCol.get();
    const batch = admin.firestore().batch();
    
    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { orderIndex: 0 });
    });
    
    await batch.commit();
    return { success: true, message: `Reset orderIndex for ${snapshot.size} restaurants.` };
  } catch (error) {
    console.error("Error resetting orderIndex:", error);
    return { success: false, error: error.message };
  }
});

exports.sendFCMNotification = onCall(async (request) => {
  const { token, title, body, data } = request.data;

  if (!token) {
    return { success: false, error: "Missing receiver token" };
  }

  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: data ? { payload: String(data.payload) } : {},
    token: token,
  };

  try {
    const response = await admin.messaging().send(message);
    return { success: true, messageId: response };
  } catch (error) {
    console.error("Error sending FCM notification:", error);
    return { success: false, error: error.message };
  }
});
