import 'package:flutter/material.dart';
import 'package:cashflow/shared/widgets/main_navigation.dart';

class NavigationHelper {
  static void navigateToTab(BuildContext context, int tabIndex) {
    // Try to find MainNavigation state in widget tree
    final mainNavigationState = context.findAncestorStateOfType<State<MainNavigation>>();
    
    if (mainNavigationState != null) {
      // Access the _onItemTapped method through the state
      (mainNavigationState as dynamic)._onItemTapped(tabIndex);
    } else {
      // Fallback: Navigate by replacing the current route
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigation(initialIndex: tabIndex),
        ),
      );
    }
  }
  
  static void navigateToTransactions(BuildContext context) {
    navigateToTab(context, 1); // Transactions tab index
  }
  
  static void navigateToProfile(BuildContext context) {
    navigateToTab(context, 2); // Profile tab index  
  }
  
  static void navigateToHome(BuildContext context) {
    navigateToTab(context, 0); // Home tab index
  }
}