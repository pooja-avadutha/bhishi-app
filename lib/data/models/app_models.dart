import 'dart:convert';

class GroupModel {
  final String id;
  final String groupName;
  final double monthlyAmount;
  final int totalMembers;
  final DateTime startDate;
  final double winnerInterest;
  final double agentCommission;
  final List<MemberModel> members;
  final List<String> winners; // List of member IDs who have won

  GroupModel({
    required this.id,
    required this.groupName,
    required this.monthlyAmount,
    required this.totalMembers,
    required this.startDate,
    required this.winnerInterest,
    required this.agentCommission,
    required this.members,
    required this.winners,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'monthlyAmount': monthlyAmount,
      'totalMembers': totalMembers,
      'startDate': startDate.toIso8601String(),
      'winnerInterest': winnerInterest,
      'agentCommission': agentCommission,
      'members': members.map((x) => x.toMap()).toList(),
      'winners': winners,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'],
      groupName: map['groupName'],
      monthlyAmount: map['monthlyAmount']?.toDouble() ?? 0.0,
      totalMembers: map['totalMembers']?.toInt() ?? 0,
      startDate: DateTime.parse(map['startDate']),
      winnerInterest: map['winnerInterest']?.toDouble() ?? 0.0,
      agentCommission: map['agentCommission']?.toDouble() ?? 0.0,
      members: List<MemberModel>.from(map['members']?.map((x) => MemberModel.fromMap(x))),
      winners: List<String>.from(map['winners']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) => GroupModel.fromMap(json.decode(source));
}

class MemberModel {
  final String id;
  final String memberName;
  final String phoneNumber;
  final String paymentStatus; // 'Paid', 'Pending'
  final bool hasTakenBhishi;

  MemberModel({
    required this.id,
    required this.memberName,
    required this.phoneNumber,
    required this.paymentStatus,
    required this.hasTakenBhishi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberName': memberName,
      'phoneNumber': phoneNumber,
      'paymentStatus': paymentStatus,
      'hasTakenBhishi': hasTakenBhishi,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
      memberName: map['memberName'],
      phoneNumber: map['phoneNumber'],
      paymentStatus: map['paymentStatus'],
      hasTakenBhishi: map['hasTakenBhishi'] ?? false,
    );
  }
}

class PaymentModel {
  final String memberName;
  final double amountPaid;
  final DateTime paymentDate;
  final String paymentStatus;

  PaymentModel({
    required this.memberName,
    required this.amountPaid,
    required this.paymentDate,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberName': memberName,
      'amountPaid': amountPaid,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentStatus': paymentStatus,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      memberName: map['memberName'] ?? '',
      amountPaid: map['amountPaid']?.toDouble() ?? 0.0,
      paymentDate: DateTime.parse(map['paymentDate']),
      paymentStatus: map['paymentStatus'] ?? '',
    );
  }
}
