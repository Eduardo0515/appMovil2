class Login{
  String token;
  int user_id;
  String email;
  String name;

  Login(String token, int user_id, String email, String name){
    this.token = token;
    this.user_id = user_id;
    this.email = email;
    this.name = name;
  }
}