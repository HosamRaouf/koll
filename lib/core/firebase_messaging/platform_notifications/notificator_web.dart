// lib/core/firebase_messaging/platform_notifications/notificator_web.dart

import 'dart:html' as html;
import 'notificator.dart';

Notificator getNotificator() => WebNotificator();

class WebNotificator implements Notificator {
  @override
  Future<void> initialize() async {
    // Web notifications don't need explicit initialization like AwesomeNotifications
  }

  @override
  Future<void> createNotification({
    required int id,
    required String channelKey,
    required String title,
    required String body,
  }) async {
    if (html.Notification.permission == 'granted') {
      html.Notification(title, body: body, icon: '/icons/Icon-192.png');
    }
  }

  @override
  Future<bool> isAllowed() async {
    return html.Notification.permission == 'granted';
  }

  @override
  Future<void> requestPermission() async {
    await html.Notification.requestPermission();
  }
}
