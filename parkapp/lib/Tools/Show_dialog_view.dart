import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> show_dialog_view({
  required BuildContext context,
  String? title,
  String? content,
  String confirmText = "Ja",
  String cancelText = "Avbryt",
  bool showCancelButton = true,
  required Function(bool) onResult,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title != null ? Center(child: Text(title,)) : null,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            if(content != null)
            Text(content, textScaler: TextScaler.linear(1.sp),),

            SizedBox(height: 10.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showCancelButton)
                  ElevatedButton(
                    child: Text(cancelText, textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onResult(false); // Callback with false (cancel)
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                  ),
                ElevatedButton(
                  child: Text(confirmText, textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onResult(true); // Callback with true (confirmed)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                ),
              ],
            ),
          ],
        ),
       
      );
    },
  );
}