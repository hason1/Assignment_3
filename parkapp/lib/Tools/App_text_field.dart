import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class App_text_field extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool isPassword;

  const App_text_field({
    Key? key,
    required this.title,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _App_text_fieldState createState() => _App_text_fieldState();
}

class _App_text_fieldState extends State<App_text_field> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(widget.title != null && widget.title.isNotEmpty)
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.isPassword ? 'Skriv lösenord...' : 'Skriv ...',
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}