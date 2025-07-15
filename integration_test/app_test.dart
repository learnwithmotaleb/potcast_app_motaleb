import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:podcast/core/dependency/path.dart';
import 'package:podcast/helper/local_db/local_db.dart';
import 'package:podcast/main.dart' as app;

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final DBHelper dbHelper = serviceLocator();

  setUp(() async {
    await dbHelper.clear();
  });

  group("SplashScreen Navigation Test", (){
    setUp((){
      dbHelper.saveUserdata(
          token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3OWEyMGU5ZTk5OTE2OTU1MzUxMDYwZCIsImlhdCI6MTc0NTE2MjU2NywiZXhwIjoxNzQ1NTA4MTY3fQ.m878lXUPi_SHiYfcEiNMbwsNm3hkCQ6laglAB-7XHAQ",
          id: "",
          profileId: "creator@gmail.com",
          role: "creator",
        refreshToken: '',
      );
    });

    tearDown(() async{
      await dbHelper.clear();
    });

    testWidgets("navigates to userNavScreen if token is valid and role is USER", (WidgetTester tester) async{
      app.main();
      await tester.pumpAndSettle();


    });


  });
}