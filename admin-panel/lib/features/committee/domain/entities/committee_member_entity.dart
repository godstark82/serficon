import 'package:conference_admin/core/const/committee_role.dart';

class CommitteeMemberEntity {
  final String id;
  final String image;
  final String name;
  final String designation;
  final CommitteeRole role;
  final String position;

  CommitteeMemberEntity(
      {required this.designation,
      required this.position,
      required this.id,
      required this.image,
      required this.name,
      required this.role});
}
