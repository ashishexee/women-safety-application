import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';
import 'package:woman_safety_app/db/db_helper.dart';
import 'package:woman_safety_app/models/contacts.dart';

Position? clocation;

sendMessage(String messageBody) async {
  List<TContact> contactList = await DbHelper().getContactList();
  if (contactList.isEmpty) {
    Fluttertoast.showToast(msg: "no number exist please add a number");
  } else {
    for (var i = 0; i < contactList.length; i++) {
      Telephony.backgroundInstance
          .sendSms(to: contactList[i].number, message: messageBody)
          .then((value) {
            Fluttertoast.showToast(msg: "message send");
          });
    }
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    "script academy",
    "foreground service",
    description: "used for imp notification",
    importance: Importance.low,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: "script academy",
      initialNotificationTitle: "foreground service",
      initialNotificationContent: "initializing",
      foregroundServiceNotificationId: 888,
    ),
  );
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20,
  );

  Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
  clocation = position;
  
  flutterLocalNotificationsPlugin.show(
    888,
    "women safety app",
    "Location updated: ${position.latitude}, ${position.longitude}",
    NotificationDetails(
      android: AndroidNotificationDetails(
        "script academy",
        "foreground service",
        channelDescription: "used for imp notification",
        icon: 'ic_bg_service_small',
        ongoing: true,
      ),
    ),
  );
});

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      ShakeDetector.autoStart(
        shakeThresholdGravity: 7,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        minimumShakeCount: 1,
        onPhoneShake: (ShakeEvent event) async {
          if (await Vibration.hasVibrator()) {
            if (await Vibration.hasCustomVibrationsSupport()) {
              Vibration.vibrate(duration: 1000);
            } else {
              Vibration.vibrate();
              await Future.delayed(Duration(milliseconds: 500));
              Vibration.vibrate();
            }
          }
          if (clocation != null) {
            String messageBody =
                "https://www.google.com/maps/search/?api=1&query=${clocation!.latitude}%2C${clocation!.longitude}";
            sendMessage(messageBody);
          }
        },
      );

      flutterLocalNotificationsPlugin.show(
        888,
        "women safety app",
        clocation == null
            ? "please enable location to use app"
            : "shake feature enabled at ${clocation!.latitude}, ${clocation!.longitude}",
        NotificationDetails(
          android: AndroidNotificationDetails(
            "script academy",
            "foreground service",
            channelDescription: "used for imp notification",
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    }
  }
}
