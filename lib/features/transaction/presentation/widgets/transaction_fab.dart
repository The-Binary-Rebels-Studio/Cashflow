import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class TransactionFAB extends StatefulWidget {
  const TransactionFAB({super.key});

  @override
  State<TransactionFAB> createState() => _TransactionFABState();
}

class _TransactionFABState extends State<TransactionFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _buttonAnimatedIcon;
  late Animation<double> _translateButton;
  bool _isOpened = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _buttonAnimatedIcon = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _translateButton = Tween<double>(
      begin: 56.0,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
  }

  Widget _buildFABItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        _translateButton.value * 3.0,
        0.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              mini: true,
              onPressed: onPressed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              heroTag: label,
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4.0,
            0.0,
          ),
          child: _buildFABItem(
            icon: Icons.swap_horiz,
            label: l10n.dashboardTransfer,
            color: Colors.blue,
            onPressed: () {
              _animate();
              // TODO: Navigate to transfer screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transfer feature coming soon!')),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: _buildFABItem(
            icon: Icons.remove_circle_outline,
            label: l10n.dashboardAddExpense,
            color: Colors.red,
            onPressed: () {
              _animate();
              // TODO: Navigate to add expense screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add expense feature coming soon!')),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: _buildFABItem(
            icon: Icons.add_circle_outline,
            label: l10n.dashboardAddIncome,
            color: Colors.green,
            onPressed: () {
              _animate();
              // TODO: Navigate to add income screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add income feature coming soon!')),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _animate,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _buttonAnimatedIcon,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}