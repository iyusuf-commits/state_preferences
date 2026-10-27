// import 'package:flutter/material.dart';

// import '../providers/user_provider.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   bool _controllersInitialized = false;
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_controllersInitialized) return;
//     final provider = UserProvider.of(context);
//     _nameController = TextEditingController(text: provider.user.name);
//     _emailController = TextEditingController(text: provider.user.email);
//     _controllersInitialized = true;
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       final provider = UserProvider.of(context);
//       final updatedUser = provider.user.copyWith(
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         isLoggedIn: true,
//       );
//       provider.updateUser(updatedUser);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Profil berhasil disimpan'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Apakah Anda yakin ingin logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               UserProvider.of(context).logout();
//               Navigator.pop(context);
//             },
//             child: const Text('Logout', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = UserProvider.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           if (provider.user.isLoggedIn)
//             IconButton(
//               icon: const Icon(Icons.logout),
//               onPressed: _logout,
//               tooltip: 'Logout',
//             ),
//         ],
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const SizedBox(height: 16),
//                       const CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.deepPurple,
//                         child: Icon(
//                           Icons.person,
//                           size: 60,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Nama',
//                           prefixIcon: Icon(Icons.person),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Nama tidak boleh kosong';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           prefixIcon: Icon(Icons.email),
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Email tidak boleh kosong';
//                           }
//                           final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//                           if (!emailRegex.hasMatch(value.trim())) {
//                             return 'Format email tidak valid';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton.icon(
//                         onPressed: _saveProfile,
//                         icon: const Icon(Icons.save),
//                         label: const Text('Simpan Profil'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Card(
//                         color: Colors.amber[50],
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.info, color: Colors.amber[800]),
//                                   const SizedBox(width: 8),
//                                   const Text(
//                                     'Catatan Keamanan',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 'Data disimpan di SharedPreferences (plaintext). '
//                                 'Jangan simpan password atau data sensitif di sini. '
//                                 'Gunakan secure storage untuk data sensitif.',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  // Controller untuk Latihan 3 (Favorit)
  final TextEditingController _favController = TextEditingController();
  
  bool _controllersInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllersInitialized) return;
    
    // Latihan 4: Menggunakan context.read untuk inisialisasi awal
    final provider = context.read<UserProvider>();
    _nameController = TextEditingController(text: provider.user.name);
    _emailController = TextEditingController(text: provider.user.email);
    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _favController.dispose();
    super.dispose();
  }

  // Latihan 5: Modifikasi Validasi Keamanan pada _saveProfile
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<UserProvider>();
      final nameInput = _nameController.text.trim();
      final emailInput = _emailController.text.trim();

      // a) Cek apakah nama mengandung karakter berbahaya
      final dangerRegex = RegExp(r'[<>]');
      if (dangerRegex.hasMatch(nameInput)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama mengandung karakter berbahaya seperti < atau >!'),
            backgroundColor: Colors.red,
          ),
        );
        return; 
      }

      // b) Cek apakah email sudah digunakan (simulasi via SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('user_email');
      
      if (savedEmail != null && savedEmail != emailInput && savedEmail.isNotEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email telah terdaftar sebelumnya. Gunakan email lain.'),
            backgroundColor: Colors.red,
          ),
        );
        return; 
      }

      final updatedUser = provider.user.copyWith(
        name: nameInput,
        email: emailInput,
        isLoggedIn: true,
      );

      await provider.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserProvider>().logout();
              Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Latihan 4: Mengakses state dengan provider
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (provider.user.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _saveProfile,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Profil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // LATIHAN 3: Menambahkan Daftar Favorit
                      const Text(
                        'Daftar Favorit (Contoh: Hobi):', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _favController,
                              decoration: const InputDecoration(
                                labelText: 'Tambah Favorit', 
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_favController.text.trim().isNotEmpty) {
                                provider.addFavorite(_favController.text.trim());
                                _favController.clear();
                              }
                            },
                            child: const Text('Tambah'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true, 
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.favorites.length,
                        itemBuilder: (context, index) {
                          final fav = provider.favorites[index];
                          return Card(
                            child: ListTile(
                              title: Text(fav),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => provider.removeFavorite(fav),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Kartu Catatan Keamanan Bawaan
                      Card(
                        color: Colors.amber[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info, color: Colors.amber[800]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Catatan Keamanan',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Data disimpan di SharedPreferences (plaintext). '
                                'Jangan simpan password atau data sensitif di sini. '
                                'Gunakan secure storage untuk data sensitif.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}