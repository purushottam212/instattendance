import 'package:instattendance/models/practical_batch.dart';
import 'package:instattendance/repository/practical_batch_repository.dart';
import 'package:instattendance/widgets/toast.dart';

class PracticalBatchService {
  final PracticalBatchRepository _practicalBatchRepository =
      PracticalBatchRepository();

  Future<List<PracticalBatch>?> getBatches(
      String className, String divName) async {
    try {
      List<PracticalBatch>? pList = await _practicalBatchRepository
          .getBatchesByClassAndDiv(className, divName);
      if (pList != null) {
        return pList;
      } else {
        DisplayMessage.showMsg('Batches Not Found');
      }
    } catch (e) {
      DisplayMessage.showMsg(e.toString());
    }
  }
}
