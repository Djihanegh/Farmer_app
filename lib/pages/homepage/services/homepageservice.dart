import 'package:goldfarm/utils/firestore_services.dart';
import 'package:goldfarm/utils/path.dart';
import 'package:meta/meta.dart';

class HomePageService {

  final _service = FirestoreService.instance;

  Stream<Map> jobStream({@required String uid}) => _service.documentStream(
    path: FirestorePath.user(uid),
    builder: (data, documentId){
      print(data);
     return data;
    },
  );
}
