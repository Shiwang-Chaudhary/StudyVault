import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class LottieSearchContainer extends StatelessWidget {
  const LottieSearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10),
          CustomText(
            maxLines: 3,
            text: 'Search notes by topic, subject, or keyword.',
            //  "Operating System", "Normalisation", "Constructors" etc..',
            size: FontSizes.xl,
          ),
          Lottie.asset('assets/Search.json', width: 280, height: 280),
          Lottie.asset('assets/uploading.json', width: 290, height: 290),
        ],
      ),
    );
  }
}
