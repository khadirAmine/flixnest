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

  Future<List<Map<String, dynamic>>> getShareLinks() async {
    List<Map<String, dynamic>> data = [];
    QuerySnapshot<Object?>? querySnapshot = await _instance.storeLinks?.get();
    for (QueryDocumentSnapshot<Object?> doc in querySnapshot!.docs) {
      data.add(doc.data() as Map<String, dynamic>);
    }
    return data;
  }

  static Future<String> getShareableLink() async {
    List<Map<String, dynamic>> links = await _instance.getShareLinks();
    String link = links.where((el) => el['shareable']).toList()[0]['link'];
    return link;
  }
}
