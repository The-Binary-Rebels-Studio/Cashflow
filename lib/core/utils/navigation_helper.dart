import 'package:flutter/material.dart';
import 'package:cashflow/shared/widgets/main_navigation.dart';

class NavigationHelper {
  static void navigateToTab(BuildContext context, int tabIndex) {
    
    final mainNavigationState = context.findAncestorStateOfType<State<MainNavigation>>();
    
    if (mainNavigationState != null) {
      
      (mainNavigationState as dynamic)._onItemTapped(tabIndex);
    } else {
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigation(initialIndex: tabIndex),
        ),
      );
    }
  }
  
  static void navigateToTransactions(BuildContext context) {
    navigateToTab(context, 1); 
  }
  
  static void navigateToProfile(BuildContext context) {
    navigateToTab(context, 2); 
  }
  
  static void navigateToHome(BuildContext context) {
    navigateToTab(context, 0); 
  }
}