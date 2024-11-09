enum CommitteeRole {
  organisingCommittee('Organising Committee'),
  scientificLead('Scientific Lead'),
  scientificCommitteeMember('Scientific Committee Member');

  final String value;
  const CommitteeRole(this.value);

  static CommitteeRole fromJson(String json) {
    return CommitteeRole.values.firstWhere(
      (role) => role.value == json,
      orElse: () => CommitteeRole.organisingCommittee,
    );
  }
}