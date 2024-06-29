import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
import 'dart:convert'; //json


class NewsService{ //비즈니스 클래스 
 
  Future<List<Article>> fetchArticles({String country='kr', String category='', String apiKey='65c81411210440abb26c46fd08e1a6f4'}) async{ 
    //future는 비동기로 동작 반환해주는 값을 future에 보관
    // async는 비동기 메소드 
    // 결과가 처리돼야 할 함수의 포인터를 리턴 
    String url='https://newsapi.org/v2/top-headlines?';
    url+='country=$country';

    if(category.isNotEmpty){
        url+='&category=$category';
    }

    url+='&apiKey=$apiKey'; //요청 url 완성 

    final response = await http.get(Uri.parse(url)); // http get 요청 

    if(response.statusCode==200){ //성공적으로 응답을 받으면 
      Map<String, dynamic> json = jsonDecode(response.body); // json 객체로 디코딩 
      List<dynamic> body = json['articles']; // articles 키에 포함된 내용을 리스트 
      List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      // json의 필요없는 내용들 걸러주는 역할 
       // Json 객체를 Article 객체로 만들고 리스트로 만든다
      return articles;
    }else{
      throw Exception('Failed to load articles');
    }
  }
}

class Article{
  final String title; // 기사 제목 
  final String description; // 설명
  final String urlToImage; // 이미지 url 
  final String url; // 기사의 웹 url 

  Article({required this.title, required this.description, required this.urlToImage, required this.url});
// required는 매개 변수가 필수 임을 나타낸다.

// 초기화 
  factory Article.fromJson(Map<String, dynamic> json){ // facotry 는 싱글톤 객체 //dart에서는 생성자 오버로딩 x 따라서 함수 만든다
    return Article(
      title: json['title'] ?? '', //키가 존재하지 않으면 공백으로 대체 
      description: json['description'] ?? '',
      urlToImage: json['urlToImage: '] ?? '',
      url: json['url'] ?? ''
    );
  }
}