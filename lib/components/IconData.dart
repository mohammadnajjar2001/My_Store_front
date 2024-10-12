import 'package:flutter/material.dart';

IconData getCategoryIcon(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'freezers':
      return Icons.ac_unit;
    case 'kitchen appliances':
      return Icons.kitchen;
    case 'electric appliances':
      return Icons.fireplace;
    case 'heating':
      return Icons.ac_unit;
    case 'washing machines':
      return Icons.local_laundry_service;
    case 'laptop':
      return Icons.laptop;
    case 'camera':
      return Icons.camera_alt;
    case 'mobile':
      return Icons.phone_android;
    case 'shoes':
      return Icons.shower_sharp;
    case 'dress':
      return Icons.wallet_giftcard;
    case 'tablet':
      return Icons.tablet;
    case 'accessories':
      return Icons.headset;
    case 'tv':
      return Icons.tv_off;
    default:
      return Icons.category;
  }
}
