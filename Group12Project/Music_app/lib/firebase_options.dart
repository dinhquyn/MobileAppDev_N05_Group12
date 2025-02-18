import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Thay thế các giá trị bên dưới bằng thông tin từ Firebase Console
    return const FirebaseOptions(
      apiKey: "AIzaSyB13ewSNElzbk0G_E-gVWWYPAhU0slFkVo",
      appId: "1:477558246365:web:your_web_app_id",
      messagingSenderId: "477558246365",
      projectId: "mussicsapp",
      storageBucket: "mussicsapp.firebasestorage.app",
    );
  }
} 