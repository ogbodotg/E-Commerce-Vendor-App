import 'package:ahia_vendor/Pages/AddEditCoupon.dart';
import 'package:ahia_vendor/Pages/CouponScreen.dart';
import 'package:ahia_vendor/Pages/DashBoard.dart';
import 'package:ahia_vendor/Pages/OrderPage.dart';
import 'package:ahia_vendor/Pages/ProductScreen.dart';
import 'package:ahia_vendor/Pages/VendorBanner.dart';
import 'package:flutter/material.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainDashBoard();
    }

    if (title == 'Product') {
      return ProductScreen();
    }

    if (title == 'Banner') {
      return VendorBanner();
    }

    if (title == 'Coupons') {
      return CouponScreen();
    }

    if (title == 'Orders') {
      return OrderPage();
    }
    return MainDashBoard();
  }
}
