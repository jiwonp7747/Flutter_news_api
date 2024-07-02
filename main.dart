import 'package:flutter/material.dart'; //material 디자인 라이브러리 
import 'package:flutter_application_1/article_card.dart';
import 'articles.dart';
import 'settings.dart';
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
  late Future<List<Article>> futureArticles; // 비동기 데이터 //futureArticles는 article객체의 리스트 
  final List<Article> _articles =[];
  final ScrollController _scrollController = ScrollController();  
  String _country='kr';
  String _category='';
  int _currentPage = 1;
  bool _isLoadingMore =false;

  final List<Map<String, String>> categories = [
    {'title': 'Headlines'},
    {'title': 'Business'},
    {'title': 'Technology'},
    {'title': 'Entertainment'},
    {'title': 'Sports'},
    {'title': 'Science'},
  ];
  
  @override
  void initState() {
    super.initState();
    futureArticles = NewsService().fetchArticles(); // 초기화 
    futureArticles.then((articles){
      setState(()=>_articles.addAll(articles));
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCountryTap({String country='kr'}){
    setState(() {
      _articles.clear(); // 기사 비우기 
      _currentPage=1;
      futureArticles = NewsService().fetchArticles(country: country, category: _category); // 기사 가져오기 
      futureArticles.then((articles){
        setState(()=>_articles.addAll(articles)); // 기사 옮기기 
        _country=country;
      });
    });
  }

  void _onCategoryTap({String category=''}){ // 
    
    setState(() {
      _articles.clear(); // 기사 비우기 
      _currentPage=1;
      futureArticles = NewsService().fetchArticles(category: category, country: _country); // 기사 가져오기 
      futureArticles.then((articles){
        setState(()=>_articles.addAll(articles)); // 기사 옮기기 
        _category=category;
      });
    });
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/3.jpg'),
                  fit: BoxFit.cover
                  )
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 80)),
                  Text('News Category', style: TextStyle(color: Color.fromARGB(255, 105, 152, 191)),
                  ),
                ],
              )
              ),
              ...categories.map((category)=> ListTile(
                title: Text(category['title']!),
                onTap: (){
                  _onCategoryTap(category: category['title']!);
                   Navigator.pop(context);
                },
              )),

          ],
          
        ),
      ),
      body: FutureBuilder<List<Article>>( // 몸통 // FutureBuilder 위젯은 비동기 작업의 결과를 기반으로 ui를 빌드 
        future: futureArticles, // future은 futureBuilder가 기다릴 비동기 작업을 지정 //FutureBuilder는 실시간으로 모니터링 하고 ui에 반영
        builder: (context, snapshot) { // FutureBuilder가 비동기 작업의 상태에 따라 호출 
          if (snapshot.connectionState == ConnectionState.waiting) { //연결상태가 waiting이면 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) { // 에러를 가지고 있는 경우 
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // 데이터가 없는 경우 
            return const Center(child: Text('No Data'));
          } else {
            return ListView.builder( 
              controller: _scrollController,
              itemCount: _articles.length+(_isLoadingMore?1:0),
              itemBuilder: (context, index) {
                if(index==_articles.length){
                  return const Center(child: CircularProgressIndicator());
                }
                final article = _articles[index];
                return ArticleCard(article: article, key: ValueKey(article.url));
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar( // 화면 하단 
        items: [
          //const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Image.asset('assets/images/potato.jpg', width: 24, height: 24,), label: 'Country'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: ((value)=>_onNavItemTap(value, context)),
      ),
    );
  }

  void _scrollListener() {
    if(_scrollController.position.extentAfter <200 && !_isLoadingMore){
        setState(() {
          _isLoadingMore=true;        
        });
        _loadMoreArticles();
    }
  }
  
  // 기사 추가 로딩 
  Future<void>  _loadMoreArticles() async{
    _currentPage++;
    List<Article> articles = await NewsService().fetchArticles(page: _currentPage);
    setState(() {
      _articles.addAll(articles); //받은 내용을 누적
      _isLoadingMore= false;
    });
  }
  
  void _showModalBottomSheet(BuildContext context){
    showModalBottomSheet(context: context, // showModalBottomSheet 빈 캔버스 
      builder: (BuildContext context){
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 3, // 가로줄에 몇개의 아이템
            crossAxisSpacing: 4.0, // 아이템 사이의 간격 
            mainAxisSpacing: 4.0,
            children: [
              //...List.

              Container( //korea
                color: Colors.white,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    _onCountryTap(country: 'kr');
                  },
                  child: Center(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: [
                        Image.asset('assets/images/kr.png', width: 50, height: 50, fit: BoxFit.cover,),
                        Text('Korea')
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    _onCountryTap(country: 'US');
                  },
                  child: Center(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: [
                        Image.asset('assets/images/us.png', width: 50, height: 50, fit: BoxFit.cover,),
                        Text('United State')
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    _onCountryTap(country: 'jp');
                  },
                  child: Center(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                      children: [
                        Image.asset('assets/images/japan.png', width: 50, height: 50, fit: BoxFit.cover,),
                        Text('Japan')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
  }

  _onNavItemTap(int value, BuildContext context) {
    print('Selected Index: $value');
    switch(value){
      case 0: // country 버튼 
        _showModalBottomSheet(context); 
        break;
      case 1:
        
        break;
      case 2:
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=>SettingsPage()));
        break;
    }
    List<Map<String, String>> items=[
      {'title': 'Korea', 'image': 'assets/images/123.png', 'code': 'kr'},
      {'title': 'United States', 'image': 'assets/images/123.png', 'code': 'kr'},
      {'title': 'Japan', 'image': 'assets/images/123.png', 'code': 'kr'},
    ];

    
  }
}
//class 