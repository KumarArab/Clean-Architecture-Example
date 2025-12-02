import 'dart:developer';

import 'package:flutter/material.dart';

class KittyNavigationObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    log("Popped: ${previousRoute?.settings.name}");
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    log("Pushed: ${route.settings.name}");
    super.didPush(route, previousRoute);
  }
}
