import 'package:flutter/cupertino.dart';
import 'package:kol/screens/users_screen/user_widget.dart';

import 'package:kol/map.dart';

List<Widget> userWidgets = [];
List<Widget> searchedUserWidgets = [];

buildUsers() {
  userWidgets.clear();
  for (var user in users) {
    userWidgets.add(UserWidget(user: user));
  }
}

searchUsers(String text) {
  text != ""
      ? {
          userWidgets.clear(),
          searchedUserWidgets.clear(),
          for (var element in users)
            {
              element.name.startsWith(text)
                  ? {
                      searchedUserWidgets.add(UserWidget(user: element)),
                      print(element.name)
                    }
                  : false
            }
        }
      : {searchedUserWidgets.clear()};
}
