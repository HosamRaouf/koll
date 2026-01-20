importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyBHirLhke-mtgAAceYlOpTkOvq1asudDks',
    appId: '1:335102829731:web:0c35f8d5dcb73469dd4b16',
    messagingSenderId: '335102829731',
    projectId: 'koll-8ca48',
    authDomain: 'koll-8ca48.firebaseapp.com',
    databaseURL: 'https://koll-8ca48-default-rtdb.firebaseio.com',
    storageBucket: 'koll-8ca48.appspot.com',
    measurementId: 'G-SSMYP7SEGV',
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
    console.log('Handling background message ', payload);

    const notificationTitle = payload.notification.title || payload.data.title || 'تنبيه جديد';
    const notificationOptions = {
        body: payload.notification.body || payload.data.body || 'لديك طلب جديد',
        icon: '/icons/Icon-192.png', // Ensure this path is correct
        data: payload.data
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});
