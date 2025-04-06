import 'package:flutter/material.dart';
import 'package:parkapp/Profile/Profile_view.dart';
import 'package:parkapp/Tools/Style_class.dart';
class bottom_bar{

  static Widget bottom_bar_widget(BuildContext context, String page){

    return  Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [

        BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Viktig för mer än tre items
          backgroundColor: style_class.Bottom_bar_color,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,

          items: <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon:  Icon(page == 'Lobby' ? Icons.home : Icons.home_outlined, color: page == 'Lobby' ? Colors.yellow : Colors.white,),
              label: 'Lobby',
            ),

            BottomNavigationBarItem(
              icon:  Icon(page == 'Lobby' ? Icons.home : Icons.home_outlined, color: page == 'Lobby' ? Colors.yellow : Colors.white,),
              label: 'Lobby',
            ),

            BottomNavigationBarItem(
              icon:  Icon(page == 'profile' ? Icons.person : Icons.person_outline_outlined, color: page == 'profile' ? Colors.yellow : Colors.white,),
              label: 'Profil',
            ),
          ],


          onTap: (int x) async {
            //  page hjälper att man användaren inte kan trycka igen på samma sida hen är i redan

            if(x==0 && page != 'Lobby'){ // Lobby
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => profile_view()), (Route<dynamic> route) => false); // man kan inte gå tillbaka
            }

          }, // För att ta reda på icon index användaren trycker på
        ),
      ],
    );
  }
}
