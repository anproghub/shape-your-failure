class UserApi {
  UserApi._privateConstructor();

  static final UserApi _instance = UserApi._privateConstructor();
  static UserApi get instance => _instance;

  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? username;
  String? image;
  String? bio;
  String? token;

  UserApi({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.image,
    this.bio,
    this.token,
  });

  static setData(
      {id, email, firstName, lastName, username, image, bio, token}) {
    UserApi.instance.id = id;
    UserApi.instance.email = email;
    UserApi.instance.firstName = firstName;
    UserApi.instance.lastName = lastName;
    UserApi.instance.username = username;
    UserApi.instance.image = image;
    UserApi.instance.bio = bio;
    UserApi.instance.token = token;
  }
}
