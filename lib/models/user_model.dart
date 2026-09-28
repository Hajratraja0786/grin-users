class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    avatar: json['avatar'],
  );
}

class UserListResponse {
  final int page;
  final int totalPages;
  final List<UserModel> users;

  UserListResponse({
    required this.page,
    required this.totalPages,
    required this.users,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      UserListResponse(
        page: json['page'],
        totalPages: json['total_pages'],
        users: (json['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList(),
      );
}