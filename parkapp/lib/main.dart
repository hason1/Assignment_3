import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkapp/Tools/Shared_preferences.dart';

import 'Login/Login_view.dart';

void main() async{
  ScreenUtil.ensureScreenSize();
  WidgetsFlutterBinding.ensureInitialized();

  Widget user_view = await shared_preferences_helper.set_user_view();

  runApp(ScreenUtilInit(child: MyApp(user_view: user_view,)));
}

class MyApp extends StatelessWidget {
  Widget user_view;
   MyApp({super.key, required this.user_view});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: user_view ?? login_view(),
    );
  }
}

