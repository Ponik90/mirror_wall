import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall/screen/home/provider/home_provider.dart';
import 'package:mirror_wall/screen/no_internet/view/no_internet_screen.dart';

import 'package:mirror_wall/utils/internet_provider.dart';
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
    context.read<HomeProvider>().getBookMarkData();
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
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomSheet(
                                onClosing: () {},
                                builder: (context) {
                                  return providerW!.bookMark.isEmpty
                                      ? Container(
                                          height: 500,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          color: Colors.white,
                                          alignment: Alignment.center,
                                          child:
                                              const Text("No book mark here"),
                                        )
                                      : Container(
                                          height: 500,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: providerW!
                                                      .bookMark.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      onTap: () {
                                                        inAppWebViewController!
                                                            .loadUrl(
                                                          urlRequest:
                                                              URLRequest(
                                                            url: WebUri(providerW!
                                                                    .bookMark[
                                                                index]),
                                                          ),
                                                        );
                                                      },
                                                      title: Text(providerW!
                                                          .bookMark[index]),
                                                      trailing: IconButton(
                                                        onPressed: () {
                                                          providerW!
                                                              .deleteBookMark(
                                                                  index);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete),
                                                      ),
                                                    );
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
                        child: const Row(
                          children: [
                            Icon(Icons.bookmark),
                            SizedBox(
                              width: 10,
                            ),
                            Text("All Bookmarks"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
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
                                            Uri.parse("https://www.google.com"),
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
                                            Uri.parse("https://www.yahoo.com"),
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
                        child: const Row(
                          children: [
                            Icon(Icons.screen_search_desktop_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Search Engine"),
                          ],
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
                      onPressed: () async {
                        var url = await inAppWebViewController!.getUrl();
                        await providerR!.addBookMark(url.toString());
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
