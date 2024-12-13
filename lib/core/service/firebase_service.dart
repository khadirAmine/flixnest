import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../utils/methodes.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService _instance = FirebaseService._();
  CollectionReference? storeLinks;

  static Future init() async {
    logger('init Firebase');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _instance.storeLinks = FirebaseFirestore.instance.collection('storeLinks');
  }

  static Future<Map<String, dynamic>> getShareLink() async {
    Map<String, dynamic> data = {};
    QuerySnapshot<Object?>? querySnapshot = await _instance.storeLinks?.get();
    for (QueryDocumentSnapshot<Object?> doc in querySnapshot!.docs) {
      data.addAll(doc.data() as Map<String, dynamic>);
    }
    return data;
  }
}
