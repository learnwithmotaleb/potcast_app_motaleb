import 'package:get/get.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';

void checkApi({required Response response}) async {
  if (response.statusCode == 401) {
    DBHelper dbHelper = DBHelper();
    await dbHelper.logOut();
  } else if (response.statusCode == 503) {
    toastMessage(
        message:
            response.body?['message'].toString() ?? "No internet connection");
  } else {
    toastMessage(
        message:
            response.body?['message'].toString() ?? "something want wrong");
  }
}
