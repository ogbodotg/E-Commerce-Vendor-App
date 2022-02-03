import 'package:ahia_vendor/Auth/Login_Screen.dart';
import 'package:ahia_vendor/Auth/Register_Screen.dart';
import 'package:ahia_vendor/Pages/AddEditCoupon.dart';
import 'package:ahia_vendor/Pages/AddNewProduct.dart';
import 'package:ahia_vendor/Pages/HomeScreen.dart';
import 'package:ahia_vendor/Pages/SplashScreen.dart';
import 'package:ahia_vendor/Pages/VendorBanner.dart';
import 'package:ahia_vendor/Providers/AuthProvider.dart';
import 'package:ahia_vendor/Providers/DeliveryProvider.dart';
import 'package:ahia_vendor/Providers/OrderProvider.dart';
import 'package:ahia_vendor/Providers/ProductProvider.dart';
import 'package:ahia_vendor/Widgets/ResetPassword.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (_) => AuthProvider(),
      ),
      Provider(
        create: (_) => ProductProvider(),
      ),
      Provider(
        create: (_) => OrderProvider(),
      ),
      Provider(
        create: (_) => DeliveryProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(primaryColor: Colors.green, fontFamily: 'Lato'),

      theme: ThemeData(primaryColor: Color(0xFF84c225), fontFamily: 'Lato'),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      // home: SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        AddNewProduct.id: (context) => AddNewProduct(),
        VendorBanner.id: (context) => VendorBanner(),
        AddEditCoupon.id: (context) => AddEditCoupon(),

        // WelcomeScreen.id: (context) => WelcomeScreen(),
        // MapScreen.id: (context) => MapScreen(),
        // // SetDeliveryAddress.id: (context) => SetDeliveryAddress(),
      },
    );
  }
}
