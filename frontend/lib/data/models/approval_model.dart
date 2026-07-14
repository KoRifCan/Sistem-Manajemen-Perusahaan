import '../utils/firestore_helpers.dart';
class ApprovalRequestModel {
  final String id;
  final String type; // leave, overtime, permit, reimbursement, purchase, mutation, resignation
  final String referenceId;
  final String requesterId;
  final String requesterName;
  final String title;
  final String description;
  final String? attachmentUrl;
  final String status; // pending, approved, rejected, cancelled
  final int currentLevel;
  final int maxLevel;
  final List<ApprovalStepModel> steps;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApprovalRequestModel({
    required this.id,
    required this.type,
    required this.referenceId,
    required this.requesterId,
    required this.requesterName,
    required this.title,
    required this.description,
    this.attachmentUrl,
    this.status = 'pending',
    this.currentLevel = 1,
    this.maxLevel = 1,
    this.steps = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApprovalRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return ApprovalRequestModel(
      id: id,
      type: map['type'] ?? '',
      referenceId: map['referenceId'] ?? '',
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      attachmentUrl: map['attachmentUrl'],
      status: map['status'] ?? 'pending',
      currentLevel: map['currentLevel'] ?? 1,
      maxLevel: map['maxLevel'] ?? 1,
      steps: (map['steps'] as List<dynamic>?)
              ?.map((s) => ApprovalStepModel.fromMap(s as Map<String, dynamic>))
              .toList() ?? [],
      createdAt: toDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: toDateTime(map['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'referenceId': referenceId,
    'requesterId': requesterId,
    'requesterName': requesterName,
    'title': title,
    'description': description,
    'attachmentUrl': attachmentUrl,
    'status': status,
    'currentLevel': currentLevel,
    'maxLevel': maxLevel,
    'steps': steps.map((s) => s.toMap()).toList(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class ApprovalStepModel {
  final String approverId;
  final String approverName;
  final int level;
  final String status; // pending, approved, rejected
  final DateTime? actionAt;
  final String? note;

  ApprovalStepModel({
    required this.approverId,
    required this.approverName,
    required this.level,
    this.status = 'pending',
    this.actionAt,
    this.note,
  });

  factory ApprovalStepModel.fromMap(Map<String, dynamic> map) {
    return ApprovalStepModel(
      approverId: map['approverId'] ?? '',
      approverName: map['approverName'] ?? '',
      level: map['level'] ?? 1,
      status: map['status'] ?? 'pending',
      actionAt: toDateTime(map['actionAt']),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() => {
    'approverId': approverId,
    'approverName': approverName,
    'level': level,
    'status': status,
    'actionAt': actionAt,
    'note': note,
  };
}
