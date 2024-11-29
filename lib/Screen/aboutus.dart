import 'package:flutter/material.dart';
import 'package:my_bus/components/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  String? _url;
  final List names = [
    "Professor Dr. Hasan Demirel",
    "Mohamed Ali Idris Abubaker",
    "Mohammed Elfadil Rabie Hassan Elkhidir",
    "Mohamed Amin Osman Yousif",
    "Mohammad Mubark Abdullah Mohamedahmed",
  ];
  final List linkedin = [
    "",
    "https://www.linkedin.com/in/mohamed-abubaker-baa87916a/",
    "https://www.linkedin.com/in/mohammed-elfadil-rabie-18003b141/",
    "https://www.linkedin.com/in/mohamed-yousif-122450316?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app",
    ""
  ];

  final List github = [
    "",
    "https://github.com/Ki11ay",
    "https://github.com/Moealfadil",
    "https://github.com/jeecsh",
    "",
  ];

  Future<void> _launchUrl(String url) async {
    _url = url;
    if (_url != null) {
      await launchUrl(Uri.parse(_url!), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(AppLocalizations.of(context)!.abtus,
              style: const TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Center(
                child: Text(
              "Our Team",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: primaryColor),
            )),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: Image.asset('assets/images/team.png', height: 300.0),
            ),
            const SizedBox(height: 8.0),
            // prof dr hasan demirel
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/H.Demiral.png',
                    height: 250.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    names[0],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'SuperVisor',
                    style: TextStyle(fontSize: 16.0,
                    color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            // mohamed a. i. abubaker
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: sw * 0.45,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/klay.png',
                      height: 150.0,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Mohamed Ali',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const Text(
                      'Idris Abubaker',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _launchUrl(
                              'https://www.linkedin.com/in/mohamed-abubaker-baa87916a/'),
                          icon: const Image(
                            image: AssetImage('assets/images/linkedin.png'),
                            height: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _launchUrl(github[1]),
                          icon: const Image(
                            image: AssetImage('assets/images/github.png'),
                            height: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
    
              // mohammed elfadil r. h. elkhidir
              Container(
                width: sw * 0.45,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/f.jpeg',
                      height: 150.0,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Mohammed Elfadil",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const Text(
                      "Rabie Hassan Elkhid",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _launchUrl(linkedin[2]),
                          icon: const Image(
                            image: AssetImage('assets/images/linkedin.png'),
                            height: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _launchUrl(github[2]),
                          icon: const Image(
                            image: AssetImage('assets/images/github.png'),
                            height: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 8.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // mohamed amin o. yousif
              Container(
                width: sw * 0.45,
                // margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/j.jpeg',
                      height: 150.0,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Mohamed Amin",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const Text(
                      "Osman Yousif",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _launchUrl(linkedin[3]),
                          icon: const Image(
                            image: AssetImage('assets/images/linkedin.png'),
                            height: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _launchUrl(github[3]),
                          icon: const Image(
                            image: AssetImage('assets/images/github.png'),
                            height: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
    
              // mohammad m. a. mohamedahmed
              Container(
                width: sw * 0.45,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/klay.png',
                      height: 150.0,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Mohammad Mubark",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const Text(
                      "A. Mohamedahmed",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Image(
                            image: AssetImage('assets/images/linkedin.png'),
                            height: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Image(
                            image: AssetImage('assets/images/github.png'),
                            height: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ])
    
            // mohamed amin o. yousif
    
            // mohammad m. a. mohamedahmed
          ],
        ));
  }
}
