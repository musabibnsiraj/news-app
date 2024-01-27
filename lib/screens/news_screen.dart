import 'dart:async';
import 'package:news_app/app_config.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/providers/article_provider.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import '../../widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Article> allArticles = [];
  TextEditingController searchController = TextEditingController();
  bool loading = false;
  String selectedCategory = 'all';
  String selectedSortBy = 'all';
  String searchText = '';

  List<Map<String, String>> sortBy = [
    {'all': 'All'},
    {'relevancy': 'Relevancy'},
    {'popularity': 'Popularity'},
    {'publishedAt': 'Latest'},
  ];

  List<Map<String, String>> categories = [
    {'all': 'All'},
    {'business': 'Business'},
    {'entertainment': 'Entertainment'},
    {'general': 'General'},
    {'health': 'Health'},
    {'science': 'Science'},
    {'sports': 'Sports'},
    {'technology': 'Technology'}
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getAllNews();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  Future<void> getAllNews({String? text, String? sort}) async {
    if (sort == null) {
      setState(() {
        selectedSortBy = 'all';
      });
    }
    ArticleProvider articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);

    await articleProvider.getAllArticles(searchText: text, sortBy: sort);
  }

  Future<void> getTopHeadingsByCategory(
      {String? category, String? searchText}) async {
    if (category == null) {
      setState(() {
        selectedCategory = 'all';
      });
    }
    ArticleProvider articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);

    await articleProvider.getTopHeadingsByCategory(
        category: category, searchText: searchText);
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context, listen: true);
    final isLoading = articleProvider.isLoading;
    allArticles = articleProvider.getAllArticle;

    return Scaffold(
      appBar: appBar('Global News Articles'),
      body: SafeArea(
          child: Stack(
        children: [
          const Divider(color: Colors.white),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Sort By',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Category',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Theme(
                            data: ThemeData.dark(),
                            child: Center(
                              child: DropdownButton<String>(
                                value: selectedSortBy,
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    selectedSortBy = newValue!;
                                    selectedCategory = 'all';
                                    searchText = searchController.text;
                                  });
                                  if (selectedSortBy == 'all') {
                                    await getAllNews(text: searchText);
                                  } else {
                                    await getAllNews(
                                        sort: selectedSortBy, text: searchText);
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                items: sortBy.map<DropdownMenuItem<String>>(
                                  (Map<String, String> item) {
                                    return DropdownMenuItem<String>(
                                      value: item.keys.first,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.values.first,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Theme(
                            data: ThemeData.dark(),
                            child: Center(
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    selectedCategory = newValue!;
                                    selectedSortBy = 'all';
                                    searchText = searchController.text;
                                  });
                                  if (selectedCategory == 'all') {
                                    await getAllNews(text: searchText);
                                  } else {
                                    await getTopHeadingsByCategory(
                                        category: selectedCategory,
                                        searchText: searchText);
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                items: categories.map<DropdownMenuItem<String>>(
                                    (Map<String, String> item) {
                                  return DropdownMenuItem<String>(
                                    value: item.keys.first,
                                    child: Text(
                                      item.values.first,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 10,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Articles',
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                // Clear the search field
                                searchController.clear();
                                setState(() {
                                  searchText = '';
                                });
                                await getAllNews();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: appTextColor,
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                // Handle search button press
                                searchText = searchController.text;
                                await getAllNews(text: searchText);
                              },
                              icon: Icon(
                                Icons.search,
                                color: appTextColor,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: appGrey)),
                ),
              ),
              if (!isLoading && !loading && allArticles.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text('Don’t have any articles!'),
                ),
              Expanded(
                  child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: allArticles.length,
                        itemBuilder: (ctx, i) {
                          Article c = allArticles.elementAt(i);
                          var content = c.content ?? '';
                          return Column(children: [
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 4, right: 4),
                                child: ListTile(
                                  onTap: () {
                                    // Navigate to article detail screen
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return ArticleDetailScreen(article: c);
                                    }));
                                  },
                                  title: Text(
                                    c.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                  subtitle: Text(
                                    content.length > 50
                                        ? '${content.substring(0, 50)}...'
                                        : content,
                                    style: TextStyle(color: appTextColor),
                                  ),
                                  trailing: c.urlToImage != null
                                      ? SizedBox(
                                          width:
                                              50, // Specify the desired width
                                          height: 50,
                                          child: Image.network(
                                            Uri.parse(c.urlToImage!).isAbsolute
                                                ? c.urlToImage!
                                                : 'https://${c.urlToImage!}', // Add the correct scheme
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              // Handle the error by returning a placeholder image
                                              return Image.network(
                                                AppConfig.noImage,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const Divider(color: Colors.white),
                          ]);
                        },
                      )))
            ],
          ),
          if (loading || isLoading) const Spinner()
        ],
      )),
    );
  }
}
