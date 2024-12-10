import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartPage(scrollController: ScrollController()),
    );
  }
}

class CartItem {
  final String title;
  final String description;
  final double price;
  int quantity;

  CartItem({
    required this.title,
    required this.description,
    required this.price,
    this.quantity = 1,
  });
}

class CartPage extends StatefulWidget {
  final ScrollController scrollController;

  const CartPage({Key? key, required this.scrollController}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      title: "Product 1",
      description: "This is product 1",
      price: 30.0,
    ),
    CartItem(
      title: "Product 2",
      description: "This is product 2",
      price: 20.0,
    ),
    CartItem(
      title: "Product 3",
      description: "This is product 3",
      price: 50.0,
    ),
  ];

  void _increaseQuantity(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void _decreaseQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  double get _totalPrice {
    return cartItems.fold(0.0, (total, item) => total + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final cartItem = cartItems[index];
                return CartItemWidget(
                  cartItem: cartItem,
                  onIncrease: () => _increaseQuantity(cartItem),
                  onDecrease: () => _decreaseQuantity(cartItem),
                  onRemove: () => _removeItem(cartItem),
                );
              },
              childCount: cartItems.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: \$${_totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Proceed to checkout
                },
                child: Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemWidget({
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      leading: Icon(Icons.shopping_cart),
      title: Text(cartItem.title),
      subtitle: Text(cartItem.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("\$${cartItem.price.toStringAsFixed(2)}"),
          // Wrap Row with a Flexible widget
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: onDecrease,
                ),
                Text(cartItem.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: onIncrease,
                ),
              ],
            ),
          ),
        ],
      ),
      onLongPress: onRemove,
    );
  }
}

