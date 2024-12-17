import 'package:pks_10/api/product_api.dart';
import 'package:pks_10/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../favorite_bloc/favorite_bloc.dart';
import '../favorite_bloc/favorite_state.dart';
import '../favorite_bloc/favorite_event.dart';
import '../models/product.dart';
import 'product_related/product_page.dart';

class FavoritePage extends StatelessWidget {
  final ProductApi productApi;

  const FavoritePage({
    Key? key,
    required this.productApi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return _buildScaffold(context, state.favorites);
      },
    );
  }

  Future<Product?> getProduct(int productId) async {
    try {
      return await productApi.getProduct(productId);
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Widget _buildScaffold(BuildContext context, List<Favorite> favorites) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("Избранных товаров нет"))
          : BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          final favoriteList = state.favorites;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteList.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<Product?>(
                future: getProduct(state.favorites[index].productId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading product'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final product = snapshot.data!;
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
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text('Product not found'));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
