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
          padding: EdgeInsets.all(sw * 0.035),
          children: [
            Center(
                child: Text(
              "Our Team",
              style: TextStyle(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            )),
            SizedBox(height: sw * 0.0350),
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
                  TextButton(
                      onPressed: () => _launchUrl(
                          "https://scholar.google.com/citations?user=HADY_hcAAAAJ&hl=en"),
                      child: Text(
                        "Professor Dr. Hasan Demirel",
                        style: TextStyle(
                            fontSize: sw * 0.05,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      )),
                  const SizedBox(height: 8.0),
                  Text(
                    'SuperVisor',
                    style: TextStyle(fontSize: sw * 0.035, color: primaryColor),
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
                      height: sw * 0.33,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Mohamed Ali',
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Text(
                      'Idris Abubaker',
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _launchUrl(
                              'https://www.linkedin.com/in/mohamed-abubaker-baa87916a/'),
                          icon: Image(
                            image:
                                const AssetImage('assets/images/linkedin.png'),
                            height: sw * 0.07,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _launchUrl(github[1]),
                          icon: Image(
                            image: const AssetImage('assets/images/github.png'),
                            height: sw * 0.07,
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
                      height: sw * 0.33,
                    ),
                    SizedBox(height: sw * 0.035),
                    Text(
                      "Mohammed Elfadil",
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Text(
                      "Rabie Hassan Elkhid",
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _launchUrl(linkedin[2]),
                          icon: Image(
                            image:
                                const AssetImage('assets/images/linkedin.png'),
                            height: sw * 0.07,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _launchUrl(github[2]),
                          icon: Image(
                            image: const AssetImage('assets/images/github.png'),
                            height: sw * 0.07,
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
                      height: sw * 0.33,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Mohamed Amin",
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Text(
                      "Osman Yousif",
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _launchUrl(linkedin[3]),
                          icon: Image(
                            image:
                                const AssetImage('assets/images/linkedin.png'),
                            height: sw * 0.07,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _launchUrl(github[3]),
                          icon: Image(
                            image: const AssetImage('assets/images/github.png'),
                            height: sw * 0.07,
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
                      'assets/images/mubark.jpeg',
                      height: sw * 0.33,
                    ),
                    SizedBox(height: sw * 0.035),
                    Text(
                      "Mohamad Mubarak",
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Text(
                      "A. Mohamedahmed",
                      style: TextStyle(
                          fontSize: sw * 0.035,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Image(
                            image:
                                const AssetImage('assets/images/linkedin.png'),
                            height: sw * 0.07,
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Image(
                            image: const AssetImage('assets/images/github.png'),
                            height: sw * 0.07,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(height: sw * 0.018),
            Center(
              child: Text(
                "Special Thanks to",
                style: TextStyle(
                    fontSize: sw * 0.035,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
            SizedBox(height: sw * 0.018),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Amjed Mohamed Babiker",
                    style: TextStyle(
                        fontSize: sw * 0.04,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
                IconButton(
                  onPressed: () => _launchUrl(
                      'https://www.linkedin.com/in/amjed-mohamed-0b1b3b1b1/'),
                  icon: Image(
                    image: const AssetImage('assets/images/linkedin.png'),
                    height: sw * 0.07,
                  ),
                ),
                IconButton(
                  onPressed: () => _launchUrl('https://github.com/Amjed201'),
                  icon: Image(
                    image: const AssetImage('assets/images/github.png'),
                    height: sw * 0.07,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
