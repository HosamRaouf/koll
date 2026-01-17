const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Cloud Function to send FCM notifications.
 * This avoids CORS issues on the web and keeps the Server Key/Service Account secure.
 */
exports.sendFCMNotification = functions.https.onCall(async (data, context) => {
    // Basic security check: Ensure the user is authenticated
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }

    const message = {
        token: data.token,
        notification: {
            title: data.title,
            body: data.body,
        },
        data: data.data || {},
        // Web-specific configuration
        webpush: {
            notification: {
                title: data.title,
                body: data.body,
                icon: "/icons/Icon-192.png", // Path to your app icon
            },
            fcmOptions: {
                link: "https://koll-8ca48.web.app", // Replace with your actual domain
            },
        },
    };

    try {
        const response = await admin.messaging().send(message);
        console.log("Successfully sent message:", response);
        return { success: true, messageId: response };
    } catch (error) {
        console.error("Error sending message:", error);
        return { success: false, error: error.message };
    }
});
