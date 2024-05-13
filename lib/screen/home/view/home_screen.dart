import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall/screen/home/provider/home_provider.dart';
import 'package:mirror_wall/screen/no_internet/view/no_internet_screen.dart';

import 'package:mirror_wall/utils/internet_provider.dart';
import 'package:mirror_wall/utils/shared_preference.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? providerR;
  HomeProvider? providerW;

  InternetProvider? providerIR;
  InternetProvider? providerIW;
  TextEditingController txtSearch = TextEditingController();
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController pullToRefreshController = PullToRefreshController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        inAppWebViewController!.reload();
        pullToRefreshController.endRefreshing();
      },
    );

    context.read<InternetProvider>().checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    providerW = context.watch<HomeProvider>();
    providerR = context.read<HomeProvider>();
    providerIR = context.read<InternetProvider>();
    providerIW = context.watch<InternetProvider>();
    return providerIW!.isInternetOn
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Browser App"),
              centerTitle: true,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return BottomSheet(
                                  onClosing: () {},
                                  builder: (context) {
                                    return Container(
                                      height: 500,
                                      width: MediaQuery.sizeOf(context).width,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  providerW!.bookMark.length,
                                              itemBuilder: (context, index) {
                                                return Text(Uri.parse(providerW!
                                                        .bookMark[index])
                                                    .toString());
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.bookmark),
                          label: const Text("All Bookmarks"),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    RadioListTile(
                                      value: "google",
                                      groupValue: providerW!.searchEngine,
                                      onChanged: (value) {
                                        providerR!.changeSearchEngine(value);
                                        Navigator.pop(context);
                                        inAppWebViewController!.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri.uri(
                                              Uri.parse(
                                                  "https://www.google.com"),
                                            ),
                                          ),
                                        );
                                      },
                                      title: const Text("Google"),
                                    ),
                                    RadioListTile(
                                      value: "yahoo",
                                      groupValue: providerW!.searchEngine,
                                      onChanged: (value) {
                                        providerR!.changeSearchEngine(value);
                                        Navigator.pop(context);

                                        inAppWebViewController!.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri.uri(
                                              Uri.parse(
                                                  "https://www.yahoo.com"),
                                            ),
                                          ),
                                        );
                                      },
                                      title: const Text("Yahoo"),
                                    ),
                                    RadioListTile(
                                      value: "bing",
                                      groupValue: providerW!.searchEngine,
                                      onChanged: (value) {
                                        providerR!.changeSearchEngine(value);
                                        Navigator.pop(context);

                                        inAppWebViewController!.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri.uri(
                                              Uri.parse("https://www.bing.com"),
                                            ),
                                          ),
                                        );
                                      },
                                      title: const Text("Bing"),
                                    ),
                                    RadioListTile(
                                      value: "duckduckgo",
                                      groupValue: providerW!.searchEngine,
                                      onChanged: (value) {
                                        providerR!.changeSearchEngine(value);
                                        Navigator.pop(context);

                                        inAppWebViewController!.loadUrl(
                                          urlRequest: URLRequest(
                                            url: WebUri.uri(
                                              Uri.parse(
                                                  "https://www.duckduckgo.com"),
                                            ),
                                          ),
                                        );
                                      },
                                      title: const Text("Duck Duck Go"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon:
                              const Icon(Icons.screen_search_desktop_outlined),
                          label: const Text("Search Engine"),
                        ),
                      ),
                    ];
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(
                        Uri.parse("https://www.${providerW!.searchEngine}.com"),
                      ),
                    ),
                    onWebViewCreated: (controller) {
                      inAppWebViewController = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      providerW!.check(progress / 100);
                    },
                    pullToRefreshController: pullToRefreshController,
                  ),
                ),
                Visibility(
                  visible: providerW!.progress == 1 ? false : true,
                  child: LinearProgressIndicator(
                    value: providerW!.progress,
                  ),
                ),
                TextField(
                  controller: txtSearch,
                  decoration: InputDecoration(
                    hintText: "Search or type web address",
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        inAppWebViewController!.loadUrl(
                          urlRequest: URLRequest(
                            url: WebUri.uri(
                              Uri.parse(
                                  "https://www.${providerW!.searchEngine}.com/search?q=${txtSearch.text}"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        inAppWebViewController!.loadUrl(
                          urlRequest: URLRequest(
                            url: WebUri.uri(
                              Uri.parse(
                                  "https://www.${providerW!.searchEngine}.com"),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {
                        String url =
                            inAppWebViewController!.getUrl().toString();

                        //read

                        //check null
                        //add

                        providerR!.addBookMark(url);
                      },
                      icon: const Icon(Icons.bookmark),
                    ),
                    IconButton(
                      onPressed: () {
                        inAppWebViewController!.goBack();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    IconButton(
                      onPressed: () {
                        inAppWebViewController!.reload();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () {
                        inAppWebViewController!.goForward();
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                )
              ],
            ),
          )
        : const NoInternetScreen();
  }
}
