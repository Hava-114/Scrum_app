import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class DefaultFirebaseOptions {
    // Return web options only when running on web, otherwise null so
    // platform-specific configuration (google-services.json / GoogleService-Info.plist)
    // can be used by native platforms.
    static FirebaseOptions? get currentPlatform => kIsWeb ? web : null;

    static const FirebaseOptions web = FirebaseOptions(
apiKey: "AIzaSyDOziJBDah1NhpU2z-jcuJiKHyjT71HRHE",
    authDomain: "scrum-8fef0.firebaseapp.com",
    projectId: "scrum-8fef0",
    storageBucket: "scrum-8fef0.firebasestorage.app",
    messagingSenderId: "274313549496",
    appId: "1:274313549496:web:896302e02da98470d9464d",
    measurementId: "G-M7ZLSCC2TK"
);
}