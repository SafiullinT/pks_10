import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../product_bloc/product_bloc.dart';
import '../../product_bloc/product_event.dart';
import '../../product_bloc/product_state.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerImage = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerStock = TextEditingController();

  bool _isLoading = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context.read<ProductBloc>().add(
        AddProductEvent(
          productId: DateTime.now().millisecondsSinceEpoch,
          name: _controllerName.text,
          imageUrl: _controllerImage.text,
          description: _controllerDescription.text,
          price: int.parse(_controllerPrice.text),
          stock: int.parse(_controllerStock.text),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавьте новый товар"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(labelText: 'Название'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerImage,
                  decoration: const InputDecoration(labelText: 'Изображение в формате URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите URL изображения';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerDescription,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите описание';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  controller: _controllerPrice,
                  decoration: const InputDecoration(labelText: 'Стоимость'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите стоимость';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  controller: _controllerStock,
                  decoration: const InputDecoration(labelText: 'Количество'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите количество';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
