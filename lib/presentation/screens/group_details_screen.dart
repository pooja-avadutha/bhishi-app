import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bhishi_provider.dart';
import '../../data/models/app_models.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class GroupDetailsScreen extends StatefulWidget {
  final GroupModel group;
  const GroupDetailsScreen({super.key, required this.group});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  void _drawWinner() {
    final availableMembers = widget.group.members.where((m) => !widget.group.winners.contains(m.id)).toList();
    if (availableMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All members have already won!')));
      return;
    }

    final random = Random();
    final winner = availableMembers[random.nextInt(availableMembers.length)];
    
    setState(() {
      widget.group.winners.add(winner.id);
    });
    context.read<BhishiProvider>().updateGroup(widget.group);
  }

  @override
  Widget build(BuildContext context) {
    final totalCollection = widget.group.monthlyAmount * widget.group.members.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.group.groupName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupSummary(totalCollection),
            const SizedBox(height: 24),
            Text('Members (${widget.group.members.length}/10)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.group.members.length,
              itemBuilder: (context, index) {
                final member = widget.group.members[index];
                final isWinner = widget.group.winners.contains(member.id);
                return _buildMemberCard(member, isWinner);
              },
            ),
            const SizedBox(height: 32),
            if (widget.group.members.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _drawWinner,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Draw Random Winner'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ),
            const SizedBox(height: 16),
            Text('Winners History', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (widget.group.winners.isEmpty)
              const Text('No winners declared yet.')
            else
              ...widget.group.winners.asMap().entries.map((entry) {
                final index = entry.key;
                final winnerId = entry.value;
                final winner = widget.group.members.firstWhere((m) => m.id == winnerId);
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(winner.memberName),
                  subtitle: Text('Month ${index + 1}'),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSummary(double totalCollection) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Monthly Amount', '₹${widget.group.monthlyAmount}'),
            const Divider(),
            _buildSummaryRow('Total Members', '${widget.group.members.length}'),
            const Divider(),
            _buildSummaryRow('Total Collection', '₹$totalCollection'),
            const Divider(),
            _buildSummaryRow('Interest Rate', '${widget.group.winnerInterest}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberModel member, bool isWinner) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(member.memberName),
        subtitle: Text('Status: ${member.paymentStatus}'),
        trailing: Wrap(
          spacing: 8,
          children: [
             if (isWinner) const Chip(label: Text('Winner'), backgroundColor: Colors.amber),
             const Icon(Icons.payment, color: Colors.grey),
          ],
        ),
        onTap: () => _showPaymentSheet(member),
      ),
    );
  }

  void _showPaymentSheet(MemberModel member) {
    final amountController = TextEditingController(text: widget.group.monthlyAmount.toString());
    String? tempImagePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Payment Proof - ${member.memberName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Temporary preview only. No data stored.', style: TextStyle(color: Colors.orange, fontSize: 12)),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount Paid', prefixText: '₹'),
              ),
              const SizedBox(height: 16),
              if (tempImagePath != null)
                const Column(
                  children: [
                    Text('Preview Mode Active ✅', style: TextStyle(color: Colors.green)),
                    Icon(Icons.image, size: 50, color: Colors.grey),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) setSheetState(() => tempImagePath = image.path);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture for Preview'),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final record = PaymentModel(
                    memberName: member.memberName,
                    amountPaid: double.parse(amountController.text),
                    paymentDate: DateTime.now(),
                    paymentStatus: 'Paid',
                  );
                  
                  final navigator = Navigator.of(context);
                  await context.read<BhishiProvider>().addPayment(record);
                  if (mounted) navigator.pop();
                },
                child: const Text('Confirm Payment'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
