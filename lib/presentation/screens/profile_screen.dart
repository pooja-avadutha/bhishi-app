import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bhishi_provider.dart';
import '../../core/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BhishiProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Agent Admin',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 8),
          const Text(
            '+91 98765 43210',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 32),
          _buildProfileItem(Icons.group, 'Total Groups Managed', provider.groups.length.toString()),
          _buildProfileItem(Icons.trending_up, 'Total Profit Earned', '₹${provider.getAgentTotalProfit()}'),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
              child: const Text('Edit Profile'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => provider.logout(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[50], foregroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
