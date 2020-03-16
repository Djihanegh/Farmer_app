import 'dart:io';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/path.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:goldfarm/utils/firestore_services.dart';

class UploadKycService {
  static Future uploadFile(File image, String path) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("$path/profile");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print("File Uploaded");
    var url = await storageReference.getDownloadURL();
    return url;
  }

  static String addDoc({String image, String fid, String imagename,String meassage}) {
    Firestore.instance
        .collection("Farmer")
        .document(fid)
        .updateData({imagename: image,"detail":meassage});
    return "Uploaded";
  }

  final _service = FirestoreService.instance;

  Stream<Map> getFarmer({@required String uid}) => _service.documentStream(
    path: FirestorePath.farmer(uid),
    builder: (data, documentId){
      print(data);
      return data;
    },
  );
}
