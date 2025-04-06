import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkapp/Profile/Profile_view.dart';
import 'package:parkapp/Tools/Style_class.dart';

class app_bar_class{

  static AppBar app_bar_widget({required BuildContext context, required String title, bool show_back_btn = true,  Widget? extra_widgets,  }){

    return AppBar(
      backgroundColor: style_class.App_bar_color,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Flexible(child: Padding(
            padding:  EdgeInsets.only(right: 10.0.w),
            child: Text(title ?? '', textScaler: TextScaler.linear(0.9.sp), style: const TextStyle(color: Colors.white), textAlign:  TextAlign.left,),
          )),

          if(extra_widgets != null)
            extra_widgets,

        ],
      ),
      leading: show_back_btn ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 25,),
          onPressed: () {
            if(Navigator.canPop(context)){ // om det går att backa
              Navigator.pop(context);
            }
            else {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => profile_view()), (Route<dynamic> route) => false);
            }
          }
      ) : null, // tillbaka knap finns men drawer kan användas också
      iconTheme: const IconThemeData(
        size: 30,//change size on your need
        color: Colors.white,//change color on your need
      ),

    );
  }
}
