import 'package:flutter/material.dart';
import 'package:tb_aufa/src/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Selamat Datang
              Text("Hai,", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (authProvider.isAuthenticated)
                Text(
                  "${authProvider.currentUser?.name}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 24),

              // Card Informasi User
              if (authProvider.isAuthenticated)
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 10),
                            Text(
                              "Nama: ${authProvider.currentUser?.name ?? '-'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined),
                            const SizedBox(width: 10),
                            Text(
                              "Email: ${authProvider.currentUser?.email ?? '-'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined),
                            const SizedBox(width: 10),
                            Text(
                              "ID Pengguna: ${authProvider.currentUser?.id ?? '-'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.work_outline),
                            const SizedBox(width: 10),
                            Text(
                              "Title: ${authProvider.currentUser?.title ?? '-'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.image_outlined),
                            const SizedBox(width: 10),
                            Text(
                              "Avatar: ${authProvider.currentUser?.avatar != null ? 'Tersedia' : 'Tidak ada'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Text(
                  "Anda belum login.",
                  style: TextStyle(color: Colors.red),
                ),

              const Spacer(),

              // Tombol Logout
              ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text("Ya, Keluar"),
          ),
        ],
      ),
    );
  }
}
