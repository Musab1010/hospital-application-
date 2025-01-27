// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hospital/main.dart';
// import 'package:hospital/model/AddHospitalProvider.dart';
// import 'package:hospital/model/AuthProvider.dart';
// import 'package:hospital/model/BookingModel.dart';
// import 'package:hospital/model/RegetoProvider.dart';
// import 'package:hospital/model/ResetPasswordProvider.dart';
// import 'package:hospital/model/SuperUserPanel.dart';
// import 'package:hospital/model/Super_Admin_RequestProvider.dart';
// import 'package:hospital/model/Themedarkandlightmode.dart';
// import 'package:hospital/model/balance_provider.dart';
// import 'package:hospital/model/updateuser.dart';
// import 'package:provider/provider.dart';
// // تعديل المسار

// void main() {
//   testWidgets('Counter increments smoke test', (tester) async {
//     // إضافة MultiProvider هنا
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => ThemeProvider()),
//           ChangeNotifierProvider(create: (context) => RegetoProvider()),
//           ChangeNotifierProvider(create: (context) => AuthProvider()),
//           ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),
//           ChangeNotifierProvider(create: (context) => BookingModel()),
//           ChangeNotifierProvider(create: (context) => RequestsProvider()),
//           ChangeNotifierProvider(create: (context) => SuperUserPanelProvider()),
//           ChangeNotifierProvider(create: (context) => SearchProvider()),
//           ChangeNotifierProvider(create: (context) => HospitalProvider()),
//           ChangeNotifierProvider(create: (context) => BalanceProvider()),
//         ],
//         child: const MyApp(),
//       ),
//     );

//     // تحقق من وجود النص "0"
//     expect(find.text('0'), findsOneWidget);

//     // التفاعل مع زر الزيادة
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // تحقق من أن النص قد تغير
//     expect(find.text('1'), findsOneWidget);
//   });
// }
