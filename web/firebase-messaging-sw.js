importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

const firebaseConfig = {
    apiKey: 'AIzaSyBHirLhke-mtgAAceYlOpTkOvq1asudDks',
    appId: '1:335102829731:web:0c35f8d5dcb73469dd4b16',
    messagingSenderId: '335102829731',
    projectId: 'koll-8ca48',
    authDomain: 'koll-8ca48.firebaseapp.com',
    storageBucket: 'koll-8ca48.appspot.com',
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Background message handler
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/icons/Icon-192.png',
        data: payload.data
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});
