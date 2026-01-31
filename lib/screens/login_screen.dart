import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import '../home_screen.dart';


class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});


@override
State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
final TextEditingController _email = TextEditingController();
final TextEditingController _password = TextEditingController();
bool _loading = false;


Future<void> _login() async {
setState(() => _loading = true);
try {
await FirebaseAuth.instance.signInWithEmailAndPassword(
email: _email.text.trim(),
password: _password.text.trim(),
);
if (!mounted) return;
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
} on FirebaseAuthException catch (e) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
} finally {
if (mounted) setState(() => _loading = false);
}
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Login')),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
const SizedBox(height: 20),
ElevatedButton(onPressed: _loading ? null : _login, child: _loading ? const CircularProgressIndicator() : const Text('Login')),
TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Create account')),
],
),
),
);
}
}