// lib/core/firebase_messaging/platform_notifications/notificator.dart

import 'notificator_stub.dart'
    if (dart.library.html) 'notificator_web.dart'
    if (dart.library.io) 'notificator_mobile.dart';

abstract class Notificator {
  static final Notificator instance = getNotificator();

  Future<void> initialize();
  Future<void> createNotification({
    required int id,
    required String channelKey,
    required String title,
    required String body,
  });
  Future<bool> isAllowed();
  Future<void> requestPermission();
}
