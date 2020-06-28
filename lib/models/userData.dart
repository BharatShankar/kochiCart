class UserData {
  String displayName;
  String profileUrl;
  String email;
  String providerId;
  String phoneNum;

  UserData(
      {this.displayName,
      this.profileUrl,
      this.email,
      this.providerId,
      this.phoneNum});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        displayName: json['displayName'] ?? 'N/A',
        profileUrl: json['photoUrl'],
        email: json['email'] ?? 'N/A',
        providerId: json['providerId'],
        phoneNum: json['phoneNumber']);
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'photoUrl': profileUrl,
        'email': email,
        'providerId': providerId,
        'phoneNumber': phoneNum,
      };
}
