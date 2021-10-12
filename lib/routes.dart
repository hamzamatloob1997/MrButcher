
import 'package:flutter/widgets.dart';
import 'package:mr_butcher/models/verify_email.dart';
import 'package:mr_butcher/screens/butcher_home/pages/home_page.dart';
import 'package:mr_butcher/screens/butcher_home/pages/user_profile/user_profile.dart';
import 'package:mr_butcher/screens/complete_profile/vcomplete_profile_screen.dart';
import 'package:mr_butcher/screens/butcher_home/b_bottom_navigation.dart';
import 'package:mr_butcher/screens/edit_profiles/butcher_edit_profile.dart';
import 'package:mr_butcher/screens/edit_profiles/vendor_edit_profile.dart';
import 'package:mr_butcher/screens/forgot_password/forgot_password_screen.dart';
import 'package:mr_butcher/screens/otp/otp_screen.dart';
// import 'package:mr_butcher/screens/vendor_home/pages/user_profile/components/body.dart';
import 'package:mr_butcher/screens/vendor_home/v_bottom_navigation.dart';
import 'package:mr_butcher/screens/registration_success/registration_success_screen.dart';
import 'package:mr_butcher/screens/sign_in/sign_in_screen.dart';
import 'package:mr_butcher/screens/sign_up/verificationts.dart';
import 'package:mr_butcher/screens/splash/splash_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'package:mr_butcher/screens/vendor_home/pages/aboutUs.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  VCompleteProfileScreen.routeName: (context) => VCompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  VendorBottomNavigation.routeName: (context) => VendorBottomNavigation(),
  VerifyEmail.routeName: (context) => VerifyEmail(),
  RegistrationSuccessScreen.routeName: (context) => RegistrationSuccessScreen(),
  ButcherBottomNavigation.routeName: (context) => ButcherBottomNavigation(),
  Verifications.routeName: (context) => Verifications(),
  DriverEditProfile.routeName: (context) => DriverEditProfile(),
  ParentEditProfile.routeName: (context) => ParentEditProfile(),
  ButcherHomePage.routeName: (context) => ButcherHomePage(),
  ButcherUserPage.routeName: (context) => ButcherUserPage(),
  AboutUs.routeName: (context) => AboutUs()
};
