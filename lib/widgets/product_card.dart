import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../favorite_bloc/favorite_bloc.dart';
import '../favorite_bloc/favorite_event.dart';
import '../pages/product_related/product_page.dart';
import '../favorite_bloc/favorite_state.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 150,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ProductPage(productId: product.productId)
                  ),
                );
              },
              child: Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.network(product.imageUrl)
                      ),
                      Text(
                        product.name,
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.price.toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  final isFavorite = state.favorites.any((f) => f.productId == product.productId);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      context.read<FavoriteBloc>().add(ToggleFavoriteEvent(userId: 0, productId: product.productId));
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}
