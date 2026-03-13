import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bhishi_provider.dart';
import '../../data/models/app_models.dart';
import '../../core/app_theme.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CreateGroupFlow extends StatefulWidget {
  const CreateGroupFlow({super.key});

  @override
  State<CreateGroupFlow> createState() => _CreateGroupFlowState();
}

class _CreateGroupFlowState extends State<CreateGroupFlow> {
  int _currentStep = 0;
  
  // Step 1: Details
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _startDate = DateTime.now();

  // Step 2: Members
  final List<MemberModel> _members = [];
  final _memberNameController = TextEditingController();
  final _memberPhoneController = TextEditingController();

  void _addMember() {
    if (_members.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maximum 10 members allowed.')));
      return;
    }
    if (_memberNameController.text.isNotEmpty) {
      setState(() {
        _members.add(MemberModel(
          id: const Uuid().v4(),
          memberName: _memberNameController.text,
          phoneNumber: _memberPhoneController.text,
          paymentStatus: 'Pending',
          hasTakenBhishi: false,
        ));
      });
      _memberNameController.clear();
      _memberPhoneController.clear();
    }
  }

  void _saveGroup() async {
    final newGroup = GroupModel(
      id: const Uuid().v4(),
      groupName: _nameController.text,
      monthlyAmount: double.parse(_amountController.text),
      totalMembers: 10,
      startDate: _startDate,
      winnerInterest: 1.0, // 1%
      agentCommission: 0.02, // 2%
      members: _members,
      winners: [],
    );

    await context.read<BhishiProvider>().addGroup(newGroup);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Group Creation')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_formKey.currentState!.validate()) {
              setState(() => _currentStep++);
            }
          } else if (_currentStep == 1) {
            if (_members.length < 2) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('At least 2 members required.')));
            } else {
              setState(() => _currentStep++);
            }
          } else {
            _saveGroup();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: const Text('Details'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Group Name'),
                    validator: (v) => v!.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Monthly Amount', prefixText: '₹'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Enter amount' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Start Date'),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _startDate = picked);
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Members'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Members (Max 10)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(controller: _memberNameController, decoration: const InputDecoration(labelText: 'Member Name')),
                TextField(controller: _memberPhoneController, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _addMember, child: const Text('Add Member')),
                const Divider(height: 32),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _members.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_members[index].memberName),
                    subtitle: Text(_members[index].phoneNumber),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _members.removeAt(index)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Finish'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                const Icon(Icons.check_circle_outline, size: 64, color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                Text('Save "${_nameController.text}"?', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Total Members: ${_members.length}'),
                Text('Monthly Amount: ₹${_amountController.text}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
