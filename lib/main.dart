import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/page/Navbar/HomeNav.dart';
import 'package:testprojectbc/page/Navbar/ProfileNav.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';
import 'package:testprojectbc/page/Reservation/cashCheer.dart';
import 'package:testprojectbc/page/Reservation/debitCard.dart';
import 'package:testprojectbc/page/Reservation/detailAgency.dart';
import 'package:testprojectbc/page/Reservation/detailCur.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:testprojectbc/page/Reservation/getBalance.dart';
import 'package:testprojectbc/page/Reservation/qrCode.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:testprojectbc/page/Setting/Theme.dart';
import 'package:testprojectbc/page/Setting/detailNotify.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:testprojectbc/page/Setting/notifyAwesome.dart';
import 'package:testprojectbc/page/Setting/verifyKYC.dart';
import 'package:testprojectbc/page/addPost.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/confirm.dart';
import 'package:testprojectbc/page/curTest.dart';
import 'package:testprojectbc/page/curinfo.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/emailFA.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/page/otpsuccess.dart';
import 'package:testprojectbc/page/register.dart';
import 'package:testprojectbc/page/smsFA.dart';

import 'package:testprojectbc/role/admin/nav/homeAdmin.dart';
import 'package:testprojectbc/role/admin/nav/navHelperAdmin.dart';
import 'package:testprojectbc/role/agency/checkReservation/completedPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/qrCodeScanPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/upComingPage.dart';

import 'package:testprojectbc/role/agency/nav/homeAgency.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import 'package:testprojectbc/role/agency/nav/statusReservation.dart';
import 'package:testprojectbc/screen/detailBlockchain.dart';
import 'package:testprojectbc/screen/testBlockchain.dart';
import 'page/selectCurency.dart';
import 'page/Setting/makePin.dart';

double previousPrice = 0.0; // ราคาก่อนหน้า
double thresholdPercentage = 1.0; // เปอร์เซ็นต์ที่กำหนด
String keepCur = "";
String keepRate = "";
String keepResevaProviRateUpdate = "";
final user = FirebaseAuth.instance.currentUser!.uid;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //print('Handling a background message ${message.messageId}');
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: message.hashCode,
      channelKey: "high_importance_channel",
      title: message.data['title'],
      body: message.data['body'],
      bigPicture: message.data['image'],
      notificationLayout: NotificationLayout.BigPicture,
      largeIcon: message.data['image'],
      payload: Map<String, String>.from(message.data),
      hideLargeIconOnExpand: true,
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  AwesomeNotifications().initialize(
    //'resource://drawable/res_notification_app_icon',
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        locked: true,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/res_custom_notification',
      ),
      NotificationChannel(
        channelKey: 'high_importance_channel',
        channelName: 'high_importance_channel',
        channelDescription: 'High_importance_channel',
        ledColor: Colors.white,
        defaultColor: Color.fromARGB(255, 157, 181, 207),
        enableVibration: true,
        playSound: true,
        enableLights: true,
        importance: NotificationImportance.High,
      ),
    ],
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().actionStream.listen(
    (event) {
      print(event.payload!);
    },
  );

  // try {
  //   // if (Platform.isAndroid) {
  //     final RemoteMessage? remoteMessage =
  //         await FirebaseMessaging.instance.getInitialMessage();
  //     if (remoteMessage != null) {

  //       print('A new onMessageOpenedApp event was published!');
  //     }
  //     await HelperNotification.initialize(FlutterLocalNotificationsPlugin);
  //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   // }
  // } catch (e) {}

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ReservationData>(
      create: (context) =>
          ReservationData(), //id: 0, title: '', description: ''
    ),
    ChangeNotifierProvider<NotesServices>(
      create: (context) => NotesServices(),
    ),
  ], child: MyApp()));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  // final NotificationModel notification;
  // const notify({required this.notification});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    // createReservationPositiveNotification(context);
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: LoginPage(),
            routes: {
              "/login-page": (context) => LoginPage(),
              "/register-page": (context) => RegisterPage(),
              "/confirm-page": (context) => ConfirmPage(),
              "/authenticator-page": (context) => AuthenticatorPage(),
              "/loginsuccess-page": (context) => LoginSuccessPage(),
              "/smsfa-page": (context) => SmsPage(),
              "/emailfa-page": (context) => EmailFAPage(),
              "googlefa-page": (context) => GooglefaPage(),
              "otpsuccess-page": (context) => OtpSuccessPage(),
              "addpost-page": (context) => AddpostPage(),
              "currency-page1": (context) => CurrencyPage(),
              "currinfo-page2": (context) => CurInfo(),
              "currinfo-test": (context) => CurTest(),
              "selectCurency-page": (context) => SelectCur(),
              "makePing-page": (context) => CreatePinPage(),
              // "notify-page": (context) => notify(
              //       notification:
              //           NotificationModel(amount: '', fromCurrency: ''),
              //     ),
              "notify-page": (context) => notify(),
              "detailNotify-page": (context) => DetailNotifyPage(),
              "reservaionsNav-page": (context) => ReservationNav(),
              "HomeNav": (context) => HomeNav(),
              "ProfileNav": (context) => ProfileNav(),
              "DetailCur": (context) => DetailCur(),
              "DetailAgency": (context) => DetailAgency(),
              "QRCode-Page": (context) => QRCodePage(
                    user: '',
                  ),
              "testBC-Page": (context) => testBC(),
              "NavHelper-Page": (context) => NavHleperAgencyPage(),
              "HomeAgency-Page": (context) => HomeAgencyPage(),
              "NavHelperAdmin-Page": (context) => NavHleperAdminPage(),
              "HomeAdmin-Page": (context) => HomeAdminPage(),
              "PayDebitCard-Page": (context) => PayDebitCardPage(),
              "PayQrCode-Page": (context) => PayQRCodePage(),
              "PayCashCheer-Page": (context) => PayCashCheerPage(),
              "BookingStatus-Page": (context) => BookingStatusPage(),
              "QRScan-Page": (context) => QRScanPage(
                    uidQR: '',
                  ),
              "UpComing-Page": (context) => UpComingPage(),
              "Completed-Page": (context) => CompletedPage(),
              "GetBalance-Page": (context) => GetBalancePage(),
              "DetailBC-Page": (context) => DetailBCPage(
                    firstnameBC: '',
                    lastnameBC: '',
                    genderBC: '',
                    agencyBC: '',
                    rateBC: '',
                    currencyBC: '',
                    totalBC: '',
                    dateBC: '',
                    amountBC: '',
                  ),
              "Verification-Page": (context) => VerificationPage()
            },
          );
        },
      ),
    );
  }
}
