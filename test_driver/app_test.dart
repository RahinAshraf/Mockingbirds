import 'login_test.dart' as login;
import 'navbar_test.dart' as navbar;
import 'profile_test.dart' as profile;
import 'signup_test.dart' as signup;

void main() async {
  await signup.main();
  await login.main();
  await navbar.main();
  await profile.main();
}
