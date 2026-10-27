// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../models/user.dart';

// class UserProvider extends InheritedWidget {
//   final User user;
//   final Function(User) updateUser;
//   final VoidCallback logout;
//   final bool isLoading;
//   const UserProvider({
//     super.key,
//     required this.user,
//     required this.updateUser,
//     required this.logout,
//     required this.isLoading,
//     required super.child,
//   });
//   static UserProvider of(BuildContext context) {
//     final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
//     assert(provider != null, 'UserProvider tidak ditemukan di context');
//     return provider!;
//   }

//   @override
//   bool updateShouldNotify(UserProvider oldWidget) {
//     return oldWidget.user != user || oldWidget.isLoading != isLoading;
//   }
// }

// // StatefulWidget yang membungkus InheritedWidget
// class UserProviderWrapper extends StatefulWidget {
//   final Widget child;
//   const UserProviderWrapper({super.key, required this.child});
//   @override
//   State<UserProviderWrapper> createState() => _UserProviderWrapperState();
// }

// class _UserProviderWrapperState extends State<UserProviderWrapper> {
//   User _user = User(name: '', email: '');
//   bool _isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     _loadUser();
//   }

//   // Memuat data user dari SharedPreferences
//   Future<void> _loadUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final name = prefs.getString('user_name') ?? '';
//     final email = prefs.getString('user_email') ?? '';
//     final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
//     setState(() {
//       _user = User(name: name, email: email, isLoggedIn: isLoggedIn);
//       _isLoading = false;
//     });
//   }

//   // Menyimpan data user ke SharedPreferences
//   Future<void> _updateUser(User newUser) async {
//     setState(() {
//       _isLoading = true;
//     });
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_name', newUser.name);
//     await prefs.setString('user_email', newUser.email);
//     await prefs.setBool('is_logged_in', newUser.isLoggedIn);
//     setState(() {
//       _user = newUser;
//       _isLoading = false;
//     });
//   }

//   // Logout: hapus data user (kecuali email)
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user_name');
//     await prefs.setBool('is_logged_in', false);
//     setState(() {
//       _user = _user.copyWith(name: '', isLoggedIn: false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return UserProvider(
//       user: _user,
//       updateUser: _updateUser,
//       logout: _logout,
//       isLoading: _isLoading,
//       child: widget.child,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  
  // State untuk Latihan 1, 2, dan 3
  bool _isDarkMode = false;
  int _visitCount = 0;
  List<String> _favorites = [];

  User get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get visitCount => _visitCount;
  List<String> get favorites => _favorites;

  UserProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load User
    final name = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _user = User(name: name, email: email, isLoggedIn: isLoggedIn);

    // Load Latihan 1: Tema (Dark Mode)
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;

    // Load Latihan 2: Counter Kunjungan
    _visitCount = (prefs.getInt('visit_count') ?? 0) + 1;
    await prefs.setInt('visit_count', _visitCount);

    // Load Latihan 3: Daftar Favorit
    _favorites = prefs.getStringList('favorites') ?? [];

    _isLoading = false;
    notifyListeners(); // Menggantikan setState dan updateShouldNotify
  }

  Future<void> updateUser(User newUser) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newUser.name);
    await prefs.setString('user_email', newUser.email);
    await prefs.setBool('is_logged_in', newUser.isLoggedIn);

    _user = newUser;
    _isLoading = false;
    notifyListeners();
  }

  // Fungsi Toggle Tema (Latihan 1)
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }

  // Fungsi Tambah Favorit (Latihan 3)
  Future<void> addFavorite(String item) async {
    _favorites.add(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  // Fungsi Hapus Favorit (Latihan 3)
  Future<void> removeFavorite(String item) async {
    _favorites.remove(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);
    _user = _user.copyWith(name: '', isLoggedIn: false);
    notifyListeners();
  }
}