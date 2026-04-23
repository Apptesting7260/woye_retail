import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RequestTimeOut extends StatefulWidget {
  final VoidCallback onPress;

  const RequestTimeOut({super.key, required this.onPress});

  @override
  State<RequestTimeOut> createState() => _RequestTimeOutState();
}

class _RequestTimeOutState extends State<RequestTimeOut> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: height * .15,
          ),
          Icon(
            Icons.access_time,
            color: Colors.orange, // You can choose any color that represents a timeout error
            size: Get.height * 0.18,
          ),
          Padding(
            padding: REdgeInsets.only(top: 30),
            child: const Center(
              child: Text(
                "Oops!\nYour request took too long to process.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RammettoOne',
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * .06,
          ),
          InkWell(
            onTap: widget.onPress,  // Retry logic will be passed from the parent widget
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.orange,  // Retry button color
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  "Retry",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'RammettoOne',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
