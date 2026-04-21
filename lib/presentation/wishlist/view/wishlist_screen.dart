import 'package:flutter/material.dart';
import 'package:gyaawa/presentation/common/home_address/view/home_address_screen.dart';
import 'package:gyaawa/presentation/common/tab_bar/common_tab_bar.dart';
import '../../../shared/widgets/Custom_edits_card.dart';
import '../../../shared/widgets/Custom_kitchen_word_card.dart';
import '../../../shared/widgets/Custom_viral_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HomeAddressScreen(),
              CustomCategoryBar(),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ViralProductCard(
                      image: "https://i.pravatar.cc/300?img=${index + 1}",
                      title: "Nail Art Kit - Professional 50-Piece Set",
                      socialCount: "716+",
                      searchCount: "4317+",
                      growth: "185%",
                      viral: "#1 VIRAL ",
                      onFavTap: () {},
                      onTap: () {},
                    );
                  },
                ),
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return CustomEditsCard(
                      onFavTap: () {},
                      image: "https://i.pravatar.cc/300?img=${index + 5}",
                      title: "Premium Wireless Laptop - 15 inch Display, 16GB RAM, 512GB SSD",
                      socialCount: "716+",
                      searchCount: "4317+",
                      expert: "Expert: 9.5/10",
                      subTitle: "Editor's Pick of the Week",
                      editor: "Editor's Pick",
                      description: "Exceptional build quality, outstanding performance, and incredible value for money. This laptop has revolutionized",
                      salePrize: 'GHS 3899.99',
                      regularPrize: 'GHS 4599.99',
                      rating: 4.9,
                      totalReviews: 1247,
                      onTap: () {},
                    );
                  },
                ),
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return PopularProductCard(
                      image: "https://i.pravatar.cc/300?img=${index + 8}",
                      title:
                          "Tennis Racket Set - Professional Grade, 2 Rackets",
                      socialCount: "716+",
                      searchCount: "4317+",
                      popular: "Populars",
                      trending: "#1",
                      trade: "208%",
                      regularPrize: "GHS 599.99",
                      salePrize: "GHS 799.99",
                      searchLabel: "Searches",
                      socialLabel: "Trend Score",
                      subTitle: "SportsPro",
                      rating: 4.9,
                      totalReviews: 1247,
                      onFavTap: () {},
                      onTap: () {},
                    );
                  },
                ),
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder:(context, index,){
                      return CustomKitchenWordCard(
                        onFavTap: () {},
                        image: "https://i.pravatar.cc/300?img=${index + 11}",
                        subTitle: "Kitchen World",
                        socialCount: "716+",
                        searchCount: "4317+",
                        dayLeft: "1 day left",
                        title: "Non-Stick Cookware Set - 12 Pieces, Dishwasher Safe",
                        percentage: "-33%",
                        salePrize: 'GHS 3899.99',
                        regularPrize: 'GHS 4599.99',
                        rating: 4.9,
                        totalReviews: 1247,
                        onTap: () {},
                        save: ()
                        {print('save tapped!');},
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
