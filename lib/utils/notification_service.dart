import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_helper.dart';
import 'shared_prefs.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;
  int _notificationCount = 0;
  bool _hasShown75PercentWarning = false; // Flag untuk notifikasi 75%
  bool _hasShown100PercentWarning = false; // Flag untuk notifikasi 100%

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      if (granted != true) {
        print("Izin notifikasi tidak diberikan");
        return;
      }
    }

    _notificationCount = 0;
    _hasShown75PercentWarning = false;
    _hasShown100PercentWarning = false;
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkSpendingWarning();
    });
  }

  void stopPeriodicCheck() {
    _timer?.cancel();
  }

  Future<void> _checkSpendingWarning() async {
    try {
      final user = await SharedPrefs.getUserData();
      final summary = await NotificationHelper.getSummary();

      if (user == null) return;

      double percentage =
          (summary.totalPengeluaran / user.pengeluaranBulanan) * 100;

      // Notifikasi saat mencapai 75%
      if (percentage >= 75 && !_hasShown75PercentWarning) {
        await _showNotification(
          title: 'Peringatan Pengeluaran 75%',
          body:
              'Pengeluaran Anda telah mencapai ${percentage.toStringAsFixed(0)}% dari batas bulanan!',
        );
        _hasShown75PercentWarning = true;
        _notificationCount++;
      }

      // Notifikasi saat mencapai 100%
      if (percentage >= 100 && !_hasShown100PercentWarning) {
        await _showNotification(
          title: 'Peringatan Pengeluaran 100%',
          body:
              'Pengeluaran Anda telah melebihi batas bulanan! (${percentage.toStringAsFixed(0)}%)',
        );
        _hasShown100PercentWarning = true;
        _notificationCount++;
      }

      // Hentikan pengecekan jika kedua notifikasi sudah ditampilkan
      if (_hasShown75PercentWarning && _hasShown100PercentWarning) {
        stopPeriodicCheck();
      }
    } catch (e) {
      print("Error in periodic check: $e");
    }
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'spending_warning_channel',
      'Spending Warnings',
      channelDescription: 'Notifikasi untuk peringatan pengeluaran berlebih',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      _notificationCount,
      title,
      body,
      platformChannelSpecifics,
      payload: 'spending_warning',
    );
  }
}
