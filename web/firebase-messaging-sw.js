importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyD-fcj3ugK87dwtPxwS3eyWY_jHrny4SNY",
  authDomain: "gymweb-1e348.firebaseapp.com",
  projectId: "gymweb-1e348",
  storageBucket: "gymweb-1e348.firebasestorage.app",
  messagingSenderId: "967139721516",
  appId: "1:967139721516:web:af467b01447107adbe2c89",
  measurementId: "G-E8T8MHG9HN"
});

// تعريف مرة واحدة فقط
const messaging = firebase.messaging();

// استقبال الإشعارات في الخلفية
messaging.onBackgroundMessage(function(payload) {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: 'icons/notification.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
