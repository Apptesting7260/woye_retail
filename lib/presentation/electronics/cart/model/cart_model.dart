class CartProduct {
  final String image;
  final String title;
  final String category;
  final double price;
  final double oldPrice;
  final int discount;
  final int quantity;
  final double savings;

  CartProduct({
    required this.image,
    required this.title,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.quantity,
    required this.savings,
  });
}

class CartStore {
  final String storeName;
  final int itemCount;
  final String shippingInfo;
  final bool isFreeShipping;
  final List<CartProduct> products;

  CartStore({
    required this.storeName,
    required this.itemCount,
    required this.shippingInfo,
    required this.isFreeShipping,
    required this.products,
  });
}
