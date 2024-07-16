import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_bus/components/color.dart';
import 'package:my_bus/components/onboarding_data.dart';
import 'package:my_bus/home.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

bool isLastPage = false;

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          body(),
          buildDots(),
          button(),
        ],
      ),
    );
  }

  //Body
  Widget body() {
    return Expanded(
      child: Center(
        child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Images
                    Image.asset('assets/images/LOGO.png'),
                    Stack(
                      children: [
                      Positioned(
                          child: Image.asset(
                              controller.items[currentIndex].image)),
                      Positioned(
                        left: 125,
                        top: 70,
                        child: Image.asset(
                          'assets/images/unilogo.png',
                          height: 130,
                          width: 130,
                        ),
                      )
                    ]),
                    Stack(
                      children: [
                        Image.asset('assets/images/Vector 3.png'),
                        Positioned(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 150,
                              ),
                              Text(
                                controller.items[currentIndex].title,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w800),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  controller.items[currentIndex].description,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  //Dots
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          controller.items.length,
          (index) => AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: primaryColor,
              ),
              height: 7,
              width: currentIndex == index ? 30 : 7,
              duration: const Duration(milliseconds: 500))),
    );
  }

  //Button
  Widget button() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: primaryColor),
      child: TextButton(
        onPressed: () async {
          if (currentIndex != controller.items.length - 1) {
            setState(() {
              currentIndex++;
            });
          } else {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Started()));
          }
        },
        child: Text(
          currentIndex == controller.items.length - 1
              ? AppLocalizations.of(context)!.getstarted
              : AppLocalizations.of(context)!.continuet,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
