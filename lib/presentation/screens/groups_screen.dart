import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bhishi_provider.dart';
import '../../core/app_theme.dart';
import 'create_group_flow.dart';
import 'group_details_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BhishiProvider>();

    return Scaffold(
      body: provider.groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No groups available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateGroupFlow()),
                    ),
                    child: const Text('Create Your First Group'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.groups.length,
              itemBuilder: (context, index) {
                final group = provider.groups[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      group.groupName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Monthly: ₹${group.monthlyAmount}'),
                        Text('Members: ${group.members.length}/${group.totalMembers}'),
                        Text('Status: Active'),
                      ],
                    ),
                    trailing: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GroupDetailsScreen(group: group)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateGroupFlow()),
        ),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
