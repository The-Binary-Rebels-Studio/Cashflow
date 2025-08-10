import 'package:flutter/material.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_header.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_fab.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String _selectedPeriod = 'This Month';
  String _selectedCategory = 'All';
  String _sortBy = 'Date';
  String _searchQuery = '';
  bool _isSearching = false;
  
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year'];
  final List<String> _categories = ['All', 'Food', 'Transport', 'Shopping', 'Bills', 'Income'];
  final List<String> _sortOptions = ['Date', 'Amount', 'Category'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TransactionHeader(
              isSearching: _isSearching,
              searchQuery: _searchQuery,
              selectedPeriod: _selectedPeriod,
              selectedCategory: _selectedCategory,
              sortBy: _sortBy,
              periods: _periods,
              categories: _categories,
              sortOptions: _sortOptions,
              onSearchToggle: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) _searchQuery = '';
                });
              },
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onPeriodChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              onSortChanged: (sort) {
                setState(() {
                  _sortBy = sort;
                });
              },
            ),
            Expanded(
              child: TransactionList(
                searchQuery: _searchQuery,
                selectedPeriod: _selectedPeriod,
                selectedCategory: _selectedCategory,
                sortBy: _sortBy,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const TransactionFAB(),
    );
  }
}