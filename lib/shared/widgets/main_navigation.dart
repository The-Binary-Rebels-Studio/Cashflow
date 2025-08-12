import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/features/home/presentation/pages/home_page.dart';
import 'package:cashflow/features/transaction/presentation/pages/transaction_page.dart';
import 'package:cashflow/features/profile/presentation/pages/profile_page.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
    
    // Notify pages about tab change for potential refresh
    if (index == 1 && _previousIndex != 1) { // Transaction tab and coming from different tab
      // Trigger refresh for transaction page only when switching TO transaction tab
      _triggerTransactionRefresh();
    }
  }
  
  void _triggerTransactionRefresh() {
    // This will be called when transaction tab becomes active
    // Refresh transactions via bloc
    if (mounted) {
      context.read<TransactionBloc>().add(const TransactionDataRequested());
    }
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomePage(),
      const TransactionPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            label: AppLocalizations.of(context)!.transactions,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}