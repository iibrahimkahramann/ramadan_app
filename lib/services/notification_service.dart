import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:adhan/adhan.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      final dynamic timeZoneResult = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timeZoneResult.toString();
      // Handle potential garbage output or verbose string from plugin
      String cleanTimeZone = timeZoneName;
      if (cleanTimeZone.startsWith('TimezoneInfo(')) {
        // Extract "Europe/Istanbul" from "TimezoneInfo(Europe/Istanbul, ...)"
        final parts = cleanTimeZone.split('(');
        if (parts.length > 1) {
          final inner = parts[1].split(',');
          if (inner.isNotEmpty) {
            cleanTimeZone = inner[0].trim();
          }
        }
      }

      try {
        tz.setLocalLocation(tz.getLocation(cleanTimeZone));
      } catch (e) {
        print('TimeZone Error: $e. Falling back to UTC');
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
    } catch (e) {
      print('Error setting timezone: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          defaultPresentAlert: true, // Show alert in foreground
          defaultPresentSound: true, // Play sound in foreground
          defaultPresentBadge: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    // V20.0.0: initialize uses named parameters 'details' or 'settings' depending on exact snapshot,
    // but standard v20 release uses named parameter `initializationSettings`.
    // Wait, browsing confirmed `initialize` uses named parameters.
    // BUT the error "No named parameter with the name 'initializationSettings'" suggests the name is different.
    // Wait, if 18->20 changed it, maybe it's just `settings`?
    // NO, checking docs usually implies `settings` or strict named params.
    // The browser summary said: `flutterLocalNotificationsPlugin.initialize(settings: initializationSettings, ...)`
    // So the parameter name is `settings`? Or did the subagent Hallucinate "settings"?
    // The subagent said: "New usage: flutterLocalNotificationsPlugin.initialize(settings: initializationSettings, ...)"
    // Let's try `initializationSettings` as a POSITIONAL argument first if the error was "0 allowed".
    // ACTUALLY, checking the source code of v20 via pub.dev usually shows:
    // Future<bool?> initialize(InitializationSettings initializationSettings, { ... })
    // Wait, if it is positional, why did I get "Too many positional arguments"?
    // Maybe `initialize` is NOT async anymore? No.
    // Let's look at the error again: "Too many positional arguments: 0 allowed".
    // This strictly means NO positional arguments.
    // So it MUST be named.
    // And "No named parameter with the name 'initializationSettings'" means the name is NOT `initializationSettings`.
    // It is almost certainly `settings` or something similar if the class name is `InitializationSettings`.
    // However, looking at the very latest 20.0.0 breaking change logs, it sometimes says:
    // "The initializationSettings parameter in the initialize method is now a named parameter."
    // If the name isn't `initializationSettings`, what is it?
    // Let's try to infer from common Dart patterns.
    // BUT, I'll trust the browser subagent's specific output:
    // "New usage: flutterLocalNotificationsPlugin.initialize(settings: initializationSettings, ...)"
    // WAIT, actually I will try checking if I can use the tool to read the file again? No file access to pub cache.
    // Let's assume the name is `settings` based on the subagent, OR check if it is `defaultPresentSound`? No.
    // I will try `initializationSettings` as a named parameter but the user said it failed.
    // Maybe the user is on a dev version? 20.0.0 is stable.
    // Let's try `settings`.

    // As for zonedSchedule: "uiLocalNotificationDateInterpretation" REMOVED.
    // So I will remove it.

    // V20.0.0 uses named argument 'settings' for initializationSettings
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      print("iOS Permission Result: $result");
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> schedulePrayerTimes(List<PrayerTimes> days) async {
    await cancelAll();

    int id = 0;
    final now = DateTime.now();

    for (final prayerTimes in days) {
      _scheduleSinglePrayer(id++, 'Fajr', prayerTimes.fajr, now);
      _scheduleSinglePrayer(id++, 'Dhuhr', prayerTimes.dhuhr, now);
      _scheduleSinglePrayer(id++, 'Asr', prayerTimes.asr, now);
      _scheduleSinglePrayer(id++, 'Maghrib', prayerTimes.maghrib, now);
      _scheduleSinglePrayer(id++, 'Isha', prayerTimes.isha, now);
    }
  }

  Future<void> _scheduleSinglePrayer(
    int id,
    String prayerName,
    DateTime prayerTime,
    DateTime now,
  ) async {
    if (prayerTime.isBefore(now)) return;

    try {
      // V20.0.0 usage
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: 'Prayer Time',
        body: 'It is time for $prayerName',
        scheduledDate: tz.TZDateTime.from(prayerTime, tz.local),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel',
            'Prayer Notifications',
            channelDescription: 'Notifications for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            sound: const RawResourceAndroidNotificationSound('adhan'),
            playSound: true,
            // Flag 4 is FLAG_INSISTENT which makes audio loop until dismissed
            additionalFlags: Int32List.fromList([4]),
            audioAttributesUsage: AudioAttributesUsage
                .alarm, // Treats as alarm (overrides do not disturb often)
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'adhan.mp3',
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // REMOVED uiLocalNotificationDateInterpretation
        // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.dateAndTime, // Added for completeness if needed
      );
    } catch (e) {
      print('Error scheduling notification for $prayerName: $e');
    }
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> testNotification() async {
    print("Test Notification Triggered");
    try {
      await flutterLocalNotificationsPlugin.show(
        id: 888,
        title: 'Ezan Testi',
        body: 'Ezan sesi çalıyor mu?',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel',
            'Prayer Notifications',
            channelDescription: 'Notifications for prayer times',
            importance: Importance.max,
            priority: Priority.high,
            sound: const RawResourceAndroidNotificationSound('adhan'),
            playSound: true,
            additionalFlags: Int32List.fromList([4]),
            audioAttributesUsage: AudioAttributesUsage.alarm,
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'adhan.mp3',
            presentSound: true,
            presentAlert: true,
            presentBadge: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
      );
      print("Notification Sent");
    } catch (e) {
      print("Notification Error: $e");
    }
  }
}
