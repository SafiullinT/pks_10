import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import 'product_related/add_product_page.dart';
import '../product_bloc/product_bloc.dart';
import '../product_bloc/product_state.dart';
import '../../cart_bloc/cart_bloc.dart';
import '../../cart_bloc/cart_event.dart';
import '../../cart_bloc/cart_state.dart';
import '../../favorite_bloc/favorite_bloc.dart';
import '../../favorite_bloc/favorite_event.dart';
import '../../favorite_bloc/favorite_state.dart';
import 'product_related/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин товаров'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.products.isEmpty) {
            return const Center(child: Text('Нет товаров в магазине'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(productId: product.productId),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Цена товара
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<FavoriteBloc, FavoriteState>(
                              builder: (context, favoriteState) {
                                final isFavorite = favoriteState.favorites
                                    .any((f) => f.productId == product.productId);
                                return IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () {
                                    context.read<FavoriteBloc>().add(
                                        ToggleFavoriteEvent(userId: 0, productId: product.productId));
                                  },
                                );
                              },
                            ),
                            BlocBuilder<CartBloc, CartState>(
                              builder: (context, cartState) {
                                final isAddedToCart = cartState.carts
                                    .any((c) => c.productId == product.productId);
                                return IconButton(
                                  icon: Icon(
                                    isAddedToCart
                                        ? Icons.shopping_cart
                                        : Icons.add_shopping_cart,
                                    color: isAddedToCart ? Colors.green : Colors.black,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<CartBloc>()
                                        .add(AddCartEvent(0, product.productId, 1));
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        backgroundColor: const Color(0xFF504BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
