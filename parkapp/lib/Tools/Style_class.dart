import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkapp/Profile/Profile_view.dart';

class style_class {
  static Color App_bar_color = Colors.black87;
  static Color Bottom_bar_color = Colors.black87;
  static Color? Body_color = Colors.grey[200];

  static showSnackBar(String msg, BuildContext context, {int duration_count = 2}) {  // duration_count i början är det 2 sekunder om man inte skickar annat nummer till den variable
    //
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      duration: Duration(seconds: duration_count),
      backgroundColor:  Colors.grey[800],
      content: Column(
        mainAxisAlignment:  MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(msg, textScaler: TextScaler.linear(1.sp),),


          // LinearProgressIndicator(backgroundColor: Colors.blueAccent,),
        ],
      ),
    ));
  }

  // används för att visa en tom sida med appbar, istället  att visa en hel tom vit sida
  static Widget scaffold_loading(BuildContext context, String titleTxt){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App_bar_color,
        automaticallyImplyLeading: false, // tillbaka knapp visas inte
        title: Text(titleTxt, textScaler: TextScaler.linear(1.sp), style: const TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );

  }

  static return_user_on_error(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => profile_view()), (Route<dynamic> route) => false);
  }
}