import 'package:flutter/material.dart';
import 'package:my_strore/auth/login.dart'; // تأكد من مسار الاستيراد الصحيح
import 'package:my_strore/wellcom/content_model.dart'; // تأكد من مسار الاستيراد الصحيح

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit
                            .cover, // استخدام BoxFit لتغطية الصورة بشكل مناسب
                      ),
                      const SizedBox(height: 30),
                      Text(
                        contents[i].title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // لون النص
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          contents[i].discription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54, // لون النص
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index, context),
            ),
          ),
          const SizedBox(height: 30), // تباعد بين النقاط والزر
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Login(),
                    ),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Theme.of(context).primaryColor, // لون النص عند التفاعل
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // حواف الزر
                ),
                elevation: 8, // تأثير الظل
                padding:
                    const EdgeInsets.symmetric(horizontal: 24), // padding حول النص
                minimumSize: const Size(double.infinity, 50), // الحجم الأدنى للزر
              ),
              child: Text(
                currentIndex == contents.length - 1 ? "Get Started" : "Next",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // لون النص في الزر
                ),
              ),
            ),
          ),
          const SizedBox(height: 30), // تباعد إضافي أسفل الشاشة
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 12,
      width: currentIndex == index ? 30 : 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: currentIndex == index
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
      ),
    );
  }
}
