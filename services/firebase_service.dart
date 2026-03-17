import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {

  static Future<Map<String, dynamic>> getTodayTask() async {
    final doc = await FirebaseFirestore.instance
        .collection('daily_tasks')
        .doc('today')
        .get();

    return doc.data() ?? {};
  }
}
