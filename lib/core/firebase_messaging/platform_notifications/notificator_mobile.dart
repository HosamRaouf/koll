// lib/core/firebase_messaging/platform_notifications/notificator_mobile.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:kol/styles.dart';
import 'notificator.dart';

Notificator getNotificator() => MobileNotificator();

class MobileNotificator implements Notificator {
  @override
  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'call_channel',
              channelName: 'Basic notifications',
              importance: NotificationImportance.Max,
              playSound: true,
              channelDescription: 'Notification channel for basic tests',
              enableVibration: true,
              enableLights: true,
              defaultColor: primaryColor,
              ledColor: primaryColor)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: false);
  }

  @override
  Future<void> createNotification({
    required int id,
    required String channelKey,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true,
        category: NotificationCategory.Message,
      ),
    );
  }

  @override
  Future<bool> isAllowed() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  @override
  Future<void> requestPermission() async {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
