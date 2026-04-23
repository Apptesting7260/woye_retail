import 'package:get/get.dart';

import '../model/cart_model.dart';

class CartController extends GetxController {


  final List<CartStore> cartStores = [
    CartStore(
      storeName: "StyleHub",
      itemCount: 2,
      shippingInfo: "Free Shipping",
      isFreeShipping: true,
      products: [
        CartProduct(
          image: "https://picsum.photos/id/300/300",
          title: "Casual Summer Dress - Floral Print, Multiple Sizes",
          category: "Fashion",
          price: 199.99,
          oldPrice: 329.99,
          discount: 39,
          quantity: 1,
          savings: 130,
        ),
        CartProduct(
          image: "https://picsum.photos/id/301/300",
          title: "Designer Sunglasses - Polarized, UV Protection",
          category: "Fashion",
          price: 399.99,
          oldPrice: 604.99,
          discount: 33,
          quantity: 1,
          savings: 200,
        ),CartProduct(
          image: "https://picsum.photos/id/300/300",
          title: "Casual Summer Dress - Floral Print, Multiple Sizes",
          category: "Fashion",
          price: 199.99,
          oldPrice: 329.99,
          discount: 39,
          quantity: 1,
          savings: 130,
        ),
        CartProduct(
          image: "https://picsum.photos/id/301/300",
          title: "Designer Sunglasses - Polarized, UV Protection",
          category: "Fashion",
          price: 399.99,
          oldPrice: 604.99,
          discount: 33,
          quantity: 1,
          savings: 200,
        ),
      ],
    ),
    CartStore(
      storeName: "MensWear Plus",
      itemCount: 1,
      shippingInfo: "Add GHS 351.01 for free shipping",
      isFreeShipping: false,
      products: [
        CartProduct(
          image: "https://picsum.photos/id/302/300",
          title: "Men's Casual Cotton Shirt - Breathable, Regular Fit",
          category: "Fashion",
          price: 149.99,
          oldPrice: 199.99,
          discount: 26,
          quantity: 1,
          savings: 50,
        ),
      ],
    ),
    CartStore(
      storeName: "SmartHome Plus",
      itemCount: 1,
      shippingInfo: "Add GHS 260.01 for free shipping",
      isFreeShipping: false,
      products: [
        CartProduct(
          image: "https://picsum.photos/id/300/300",
          title: "AI Smart Speaker - Voice Assistant, Smart Home",
          category: "Electronics",
          price: 199.99,
          oldPrice: 240.00,
          discount: 20,
          quantity: 1,
          savings: 46,
        ),
      ],
    ), CartStore(
      storeName: "SmartHome Plus",
      itemCount: 1,
      shippingInfo: "Add GHS 260.01 for free shipping",
      isFreeShipping: false,
      products: [
        CartProduct(
          image: "https://picsum.photos/id/300/300",
          title: "AI Smart Speaker - Voice Assistant, Smart Home",
          category: "Electronics",
          price: 199.99,
          oldPrice: 240.00,
          discount: 20,
          quantity: 1,
          savings: 46,
        ),
      ],
    ),
  ];
}