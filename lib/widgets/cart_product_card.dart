import 'package:pks_10/widgets/cart_deletion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart_bloc/cart_bloc.dart';
import '../cart_bloc/cart_event.dart';
import '../cart_bloc/cart_state.dart';
import '../pages/product_related/product_page.dart';
import '../models/product.dart';


class CartProductCard extends StatelessWidget {
  final Product product;
  final int quantity;

  CartProductCard({
    required this.product,
    required this.quantity
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
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
                color: Colors.white,
                child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(product.imageUrl),
                        ),
                        const SizedBox(width: 40),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(color: Colors.black, fontSize: 17),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.price.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<CartBloc, CartState> (
                                builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (quantity > 1) {
                                              context.read<CartBloc>().add(AddCartEvent(0, product.productId, -1));
                                            }
                                          },
                                          icon: const Icon(Icons.remove_circle)
                                      ),
                                      Text('$quantity'),
                                      IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(AddCartEvent(0, product.productId, 1));
                                          },
                                          icon: const Icon(Icons.add_circle)
                                      ),
                                    ],
                                  );
                                }
                            ),
                            BlocBuilder<CartBloc, CartState> (
                                builder: (context, state) {
                                  return IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) => CartDeletionDialog(
                                            onConfirm: () {
                                              context.read<CartBloc>().add(RemoveCartEvent(0, product.productId));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete)
                                  );
                                }
                            ),
                          ],
                        )
                      ],
                    )
                ),
              ),
            ),
          ],
        )
    );
  }
}

/*

context.read<CartBloc>().add(RemoveCartEvent(0, product.productId));

showDialog(
                      context: context,
                      builder: (BuildContext context) => ProductDeletionDialog(
                        onConfirm: () {
                          context.read<ProductDeletionBloc>().add(DeleteProductEvent(productId: product.productId));
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context).pop(); // Close the product page
                        },
                      ),
                    );
 */

