import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldfarm/models/loan_model.dart';
import 'package:goldfarm/utils/firestore_services.dart';
import 'package:goldfarm/utils/path.dart';
import 'package:meta/meta.dart';

class FarmerDetailService{
  static final _service = FirestoreService.instance;

  Stream<Map> getCropAndAcers({@required String cropname}) => _service.documentStream(
    path: FirestorePath.crop(cropname),
    builder: (data, documentId) {
      print(data);
      return data;
    },
  );

  Future generateLoan(Loan loan) async {
    return Firestore.instance
        .collection('Loan')
        .document()
        .setData(loan.toJson());
  }

}