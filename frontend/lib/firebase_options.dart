// Masukkan Firebase config dari project Firebase kamu di sini.
// Cara dapat:
// 1. Buka Firebase Console → Project Settings → General → Your apps → Web
// 2. Copy object firebaseConfig
// 3. Paste di bawah

import 'package:firebase_core/firebase_core.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  authDomain: 'YOUR_PROJECT.firebaseapp.com',
  databaseURL: 'https://YOUR_PROJECT.firebaseio.com',
  storageBucket: 'YOUR_PROJECT.appspot.com',
  measurementId: 'YOUR_MEASUREMENT_ID',
);
