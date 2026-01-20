// lib/core/firebase_messaging/platform_notifications/notificator_stub.dart

import 'notificator.dart';

Notificator getNotificator() => throw UnsupportedError(
    'Cannot create a notificator without dart:html or dart:io');
