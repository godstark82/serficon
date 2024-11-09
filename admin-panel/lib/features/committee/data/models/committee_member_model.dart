import 'package:conference_admin/core/const/committee_role.dart';
import 'package:conference_admin/features/committee/domain/entities/committee_member_entity.dart';

class CommitteeMemberModel extends CommitteeMemberEntity {
  CommitteeMemberModel({
    required super.id,
    required super.position,
    required super.designation,
    required super.image,
    required super.role,
    required super.name,
  });

  factory CommitteeMemberModel.fromJson(Map<String, dynamic> json) {
    return CommitteeMemberModel(
        id: json['id'],
        position: json['position'],
        designation: json['designation'],
        image: json['image'],
        role: CommitteeRole.fromJson(json['role']),
        name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'designation': designation,
      'role': role.value,
      'position': position,
    };
  }

  CommitteeMemberModel copyWith(
      {String? id,
      String? name,
      String? image,
      String? designation,
      String? position,
      CommitteeRole? role}) {
    return CommitteeMemberModel(
      id: id ?? this.id,
      designation: designation ?? this.designation,
      image: image ?? this.image,
      name: name ?? this.name,
      role: role ?? this.role,
      position: position ?? this.position,
    );
  }
}
