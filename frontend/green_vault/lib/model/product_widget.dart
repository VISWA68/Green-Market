import 'package:flutter/material.dart';
import 'package:green_vault/model/product_list_model.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  final Function onAdd;
  final Function onRemove;
  final int quantity;

  const ProductWidget({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onRemove,
    required this.quantity,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(widget.product.imageUrl,
                fit: BoxFit.cover, height: 120.0, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.product.name,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${widget.product.price} credits',
              style: const TextStyle(fontSize: 16.0, color: Colors.green),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => widget.onRemove(),
                child: Container(
                  color: Colors.green.shade200,
                  child: const Icon(Icons.remove),
                ),
              ),
              Text(widget.quantity.toString()),
              GestureDetector(
                onTap: () => widget.onAdd(),
                child: Container(
                  color: Colors.green.shade200,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
