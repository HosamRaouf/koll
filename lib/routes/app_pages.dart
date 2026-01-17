
class Routes {
  static const SPLASH_ROUTER = "SPLASH_ROUTER";
  static const LOGIN_PAGE_ROUTER = "LOGIN_PAGE_ROUTER";
  static const HOME_PAGE_ROUTER = "HOME_PAGE_ROUTER";
  static const ORDER_PAGE_ROUTER = "ORDER_PAGE_ROUTER";

}

abstract class NamedNavigator {
  Future push(String routeName,
      {dynamic arguments, bool replace = false, bool clean = false});

  void pop({dynamic result});
}