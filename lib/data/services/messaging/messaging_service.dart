import 'package:cv_builder/config/theme/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      await _firebaseMessaging.requestPermission();

      await _flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
          iOS: DarwinInitializationSettings(),
        ),
      );

      // final token = await _firebaseMessaging.getToken();
      // print("FCM Token: $token");

      FirebaseMessaging.onMessage.listen((message) {
        showSimpleNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // print("Usuário clicou na notificação");
      });
    } catch (e) {
      // print("Erro ao inicializar o serviço de mensagens: $e");
    }
  }

  Future<void> showSimpleNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Notificações Simples',
      channelDescription: 'Canal padrão de notificações',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
      color: CbColors.primary,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}
