import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:lcss_mobile_app/Util/layout/letter_spacing.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/screen/reply/adaptive_nav.dart';
import 'package:lcss_mobile_app/screen/reply/colors.dart';
import 'package:lcss_mobile_app/screen/reply/model/email_model.dart';
import 'package:lcss_mobile_app/screen/reply/model/email_store.dart';
import 'package:lcss_mobile_app/screen/reply/routes.dart' as routes;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final rootNavKey = GlobalKey<NavigatorState>();

class ReplyApp extends StatefulWidget {
  const ReplyApp({Key key, this.listNotification, this.loadingData})
      : super(key: key);

  static const String homeRoute = routes.homeRoute;
  static const String composeRoute = routes.composeRoute;
  final List<NotificationModel> listNotification;
  final bool loadingData;

  @override
  _ReplyAppState createState() => _ReplyAppState();
}

class _ReplyAppState extends State<ReplyApp> with RestorationMixin {
  final _RestorableEmailState _appState = _RestorableEmailState();
  bool loadingData;
  String username;

  Future<NotificationResponseModel> notificationDataFuture;
  List<NotificationModel> listNotification;

  Future<NotificationResponseModel> notificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    print("Preference working username: " + username);
    APIService apiService = new APIService();
    notificationDataFuture =
        apiService.getAllNotificationOfStudent(1, 1000, username);
    return notificationDataFuture;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingData = widget.loadingData;
    listNotification = widget.listNotification;

    if (widget.loadingData) {
      notificationData().then((notificationData) {
        listNotification = notificationData.listNotification;
        setState(() {
          loadingData = false;
        });
      });
    }
  }

  @override
  String get restorationId => 'replyState';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_appState, 'state');
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final replyTheme = _buildReplyLightTheme(context);

    return loadingData
        ? Intro7(Colors.white)
        : MultiProvider(
            providers: [
              ChangeNotifierProvider<EmailStore>.value(
                value: _appState.value,
              ),
            ],
            child: MaterialApp(
              navigatorKey: rootNavKey,
              restorationScopeId: 'appNavigator',
              title: 'Reply',
              debugShowCheckedModeBanner: false,
              theme: replyTheme,
              localizationsDelegates:
                  GalleryLocalizations.localizationsDelegates,
              supportedLocales: GalleryLocalizations.supportedLocales,
              initialRoute: ReplyApp.homeRoute,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case ReplyApp.homeRoute:
                    return MaterialPageRoute<void>(
                      builder: (context) => new AdaptiveNav(
                        listNotification: listNotification,
                      ),
                      settings: settings,
                    );
                    break;
                }
                return null;
              },
            ),
          );
  }
}

class _RestorableEmailState extends RestorableListenable<EmailStore> {
  @override
  EmailStore createDefaultValue() {
    return EmailStore();
  }

  @override
  EmailStore fromPrimitives(Object data) {
    final appState = EmailStore();
    final appData = Map<String, dynamic>.from(data as Map);
    appState.selectedEmailId = appData['selectedEmailId'] as int;
    appState.onSearchPage = appData['onSearchPage'] as bool;

    // The index of the MailboxPageType enum is restored.
    final mailboxPageIndex = appData['selectedMailboxPage'] as int;
    appState.selectedMailboxPage = MailboxPageType.values[mailboxPageIndex];

    final starredEmailIdsList = appData['starredEmailIds'] as List<dynamic>;
    appState.starredEmailIds = {
      ...starredEmailIdsList.map<int>((dynamic id) => id as int),
    };
    final trashEmailIdsList = appData['trashEmailIds'] as List<dynamic>;
    appState.trashEmailIds = {
      ...trashEmailIdsList.map<int>((dynamic id) => id as int),
    };
    return appState;
  }

  @override
  Object toPrimitives() {
    return <String, dynamic>{
      'selectedEmailId': value.selectedEmailId,
      // The index of the MailboxPageType enum is stored, since the value
      // has to be serializable.
      'selectedMailboxPage': value.selectedMailboxPage.index,
      'onSearchPage': value.onSearchPage,
      'starredEmailIds': value.starredEmailIds.toList(),
      'trashEmailIds': value.trashEmailIds.toList(),
    };
  }
}

ThemeData _buildReplyLightTheme(BuildContext context) {
  final base = ThemeData.light();
  return base.copyWith(
    bottomAppBarColor: ReplyColors.blue700,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ReplyColors.blue700,
      modalBackgroundColor: Colors.white.withOpacity(0.7),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ReplyColors.blue700,
      selectedIconTheme: const IconThemeData(color: ReplyColors.orange500),
      selectedLabelTextStyle:
          GoogleFonts.quicksandTextTheme().headline5.copyWith(
                color: ReplyColors.orange500,
              ),
      unselectedIconTheme: const IconThemeData(color: ReplyColors.blue200),
      unselectedLabelTextStyle:
          GoogleFonts.quicksandTextTheme().headline5.copyWith(
                color: ReplyColors.blue200,
              ),
    ),
    canvasColor: ReplyColors.white50,
    cardColor: ReplyColors.white50,
    chipTheme: _buildChipTheme(
      ReplyColors.blue700,
      ReplyColors.lightChipBackground,
      Brightness.light,
    ),
    colorScheme: const ColorScheme.light(
      primary: ReplyColors.blue700,
      primaryVariant: ReplyColors.blue800,
      secondary: ReplyColors.orange500,
      secondaryVariant: ReplyColors.orange400,
      surface: ReplyColors.white50,
      error: ReplyColors.red400,
      onPrimary: ReplyColors.white50,
      onSecondary: ReplyColors.black900,
      onBackground: ReplyColors.black900,
      onSurface: ReplyColors.black900,
      onError: ReplyColors.black900,
      background: ReplyColors.blue50,
    ),
    textTheme: _buildReplyLightTextTheme(base.textTheme),
    scaffoldBackgroundColor: ReplyColors.blue50,
  );
}

ThemeData _buildReplyDarkTheme(BuildContext context) {
  final base = ThemeData.dark();
  return base.copyWith(
    bottomAppBarColor: ReplyColors.darkBottomAppBarBackground,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ReplyColors.darkDrawerBackground,
      modalBackgroundColor: Colors.black.withOpacity(0.7),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ReplyColors.darkBottomAppBarBackground,
      selectedIconTheme: const IconThemeData(color: ReplyColors.orange300),
      selectedLabelTextStyle:
          GoogleFonts.quicksandTextTheme().headline5.copyWith(
                color: ReplyColors.orange300,
              ),
      unselectedIconTheme: const IconThemeData(color: ReplyColors.greyLabel),
      unselectedLabelTextStyle:
          GoogleFonts.quicksandTextTheme().headline5.copyWith(
                color: ReplyColors.greyLabel,
              ),
    ),
    canvasColor: ReplyColors.black900,
    cardColor: ReplyColors.darkCardBackground,
    chipTheme: _buildChipTheme(
      ReplyColors.blue200,
      ReplyColors.darkChipBackground,
      Brightness.dark,
    ),
    colorScheme: const ColorScheme.dark(
      primary: ReplyColors.blue200,
      primaryVariant: ReplyColors.blue300,
      secondary: ReplyColors.orange300,
      secondaryVariant: ReplyColors.orange300,
      surface: ReplyColors.black800,
      error: ReplyColors.red200,
      onPrimary: ReplyColors.black900,
      onSecondary: ReplyColors.black900,
      onBackground: ReplyColors.white50,
      onSurface: ReplyColors.white50,
      onError: ReplyColors.black900,
      background: ReplyColors.black900Alpha087,
    ),
    textTheme: _buildReplyDarkTextTheme(base.textTheme),
    scaffoldBackgroundColor: ReplyColors.black900,
  );
}

ChipThemeData _buildChipTheme(
  Color primaryColor,
  Color chipBackground,
  Brightness brightness,
) {
  return ChipThemeData(
    backgroundColor: primaryColor.withOpacity(0.12),
    disabledColor: primaryColor.withOpacity(0.87),
    selectedColor: primaryColor.withOpacity(0.05),
    secondarySelectedColor: chipBackground,
    padding: const EdgeInsets.all(4),
    shape: const StadiumBorder(),
    labelStyle: GoogleFonts.quicksandTextTheme().bodyText2.copyWith(
          color: brightness == Brightness.dark
              ? ReplyColors.white50
              : ReplyColors.black900,
        ),
    secondaryLabelStyle: GoogleFonts.quicksandTextTheme().bodyText2,
    brightness: brightness,
  );
}

TextTheme _buildReplyLightTextTheme(TextTheme base) {
  return base.copyWith(
    headline4: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 34,
      letterSpacing: letterSpacingOrNone(0.4),
      height: 0.9,
      color: ReplyColors.black900,
    ),
    headline5: GoogleFonts.quicksand(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: letterSpacingOrNone(0.27),
      color: ReplyColors.black900,
    ),
    headline6: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: letterSpacingOrNone(0.18),
      color: ReplyColors.black900,
    ),
    subtitle2: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(-0.04),
      color: ReplyColors.black900,
    ),
    bodyText1: GoogleFonts.quicksand(
      fontWeight: FontWeight.normal,
      fontSize: 18,
      letterSpacing: letterSpacingOrNone(0.2),
      color: ReplyColors.black900,
    ),
    bodyText2: GoogleFonts.quicksand(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(-0.05),
      color: ReplyColors.black900,
    ),
    caption: GoogleFonts.quicksand(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: letterSpacingOrNone(0.2),
      color: ReplyColors.black900,
    ),
  );
}

TextTheme _buildReplyDarkTextTheme(TextTheme base) {
  return base.copyWith(
    headline4: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 34,
      letterSpacing: letterSpacingOrNone(0.4),
      height: 0.9,
      color: ReplyColors.white50,
    ),
    headline5: GoogleFonts.quicksand(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: letterSpacingOrNone(0.27),
      color: ReplyColors.white50,
    ),
    headline6: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: letterSpacingOrNone(0.18),
      color: ReplyColors.white50,
    ),
    subtitle2: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(-0.04),
      color: ReplyColors.white50,
    ),
    bodyText1: GoogleFonts.quicksand(
      fontWeight: FontWeight.normal,
      fontSize: 18,
      letterSpacing: letterSpacingOrNone(0.2),
      color: ReplyColors.white50,
    ),
    bodyText2: GoogleFonts.quicksand(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(-0.05),
      color: ReplyColors.white50,
    ),
    caption: GoogleFonts.quicksand(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      letterSpacing: letterSpacingOrNone(0.2),
      color: ReplyColors.white50,
    ),
  );
}
