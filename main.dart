import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu {
  const Menu(this.nama, this.harga);
  final String nama;
  final int harga;
}

const daftarMenu = [
  Menu('Es Kopi Susu', 12000),
  Menu('Nasi Goreng', 15000),
  Menu('Mie Ayam', 13000),
];

class CartNotifier extends Notifier<List<Menu>> {
  @override
  List<Menu> build() => [];

  void tambah(Menu menu) => state = [...state, menu];
}

final cartProvider = NotifierProvider<CartNotifier, List<Menu>>(
  CartNotifier.new,
);

// TODO 1: ubah provider ini agar menghitung total harga dari cartProvider.
// Langkah: watch cartProvider, lalu jumlahkan harga setiap menu.
final totalHargaProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, menu) => sum + menu.harga);
});

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(debugShowCheckedModeBanner: false, home: KantinPage()),
    ),
  );
}

class KantinPage extends ConsumerWidget {
  const KantinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 2: tampilkan total dari totalHargaProvider di judul AppBar
    final total = ref.watch(totalHargaProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Total: Rp $total')),
      body: ListView(
        children: [
          for (final m in daftarMenu)
            ListTile(
              title: Text(m.nama),
              subtitle: Text('Rp ${m.harga}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => ref.read(cartProvider.notifier).tambah(m),
              ),
            ),
        ],
      ),
    );
  }
}

