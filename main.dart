import 'package:flutter/material.dart'; //material 디자인 라이브러리 
import 'package:flutter_application_1/article_card.dart';
import 'articles.dart';
// 기본적인 드로잉 처리 
void main() {
  runApp(const MyApp()); //위젯을 화면에 표시 
}

// 프레임 
class MyApp extends StatelessWidget{ // 상태가 변하지 않는 위젯 
  const MyApp({super.key}); //생성자 
  
  @override
  Widget build(BuildContext context) { //호출되는 메소드
  
    return MaterialApp(
      title: 'Flutter Demo', //제목 
      theme: ThemeData(
        primarySwatch: Colors.blue // 블루에 어울리 는 컬러 세트를 만들어 테마 적용 
      ),
      home: const NewsPage(), //표시할 첫번째 화면 
    );
  }
}


class NewsPage extends StatefulWidget{ //상태가 변경될 수 있는 위젯 
  const NewsPage();

  @override
  State<StatefulWidget> createState() => _NewsPageState(); // state 객체를 생성하여 반환 
}


class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> futureArticles; // 비동기 데이터 
  
  @override
  void initState() {
    super.initState();
    futureArticles = NewsService().fetchArticles(); // 초기화 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 화면 상단 
        title: const Text(
          'Next',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<Article>>( 
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { //연결상태가 waiting이면 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) { // 에러를 가지고 있는 경우 
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // 데이터가 없는 경우 
            return const Center(child: Text('No Data'));
          } else {
            return ListView.builder( 
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return ArticleCard(article: article, key: ValueKey(article.url));
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar( // 화면 하단 
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
//class 