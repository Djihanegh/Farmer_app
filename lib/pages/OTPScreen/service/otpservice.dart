import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldfarm/utils/firestore_services.dart';
import 'package:goldfarm/utils/path.dart';
import 'package:meta/meta.dart';

class OTPService {
  static String profile;

  static final _service = FirestoreService.instance;

  static Stream<Map> verifyUser({@required String uid}) => _service.documentStream(
        path: FirestorePath.user(uid),
        builder: (data, documentId) {
          print(data);
          return data;
        },
      );
}
