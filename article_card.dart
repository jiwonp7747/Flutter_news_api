import 'package:flutter/material.dart';
import 'articles.dart';
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget{

  late final Article article;

  ArticleCard({super.key, required this.article});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(article.url),  //developer.log('URL : ${article.url}'),

      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (article.urlToImage.isNotEmpty) ?
              Image.network(article.urlToImage,
                width: double.infinity,
                height: 200,
                fit:BoxFit.cover,
                ):
              Image.asset('assets/images/123.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(article.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
              ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(article.description,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)
                ),
              ),
            
          ],
        ),
      ),
    );
  }
  
  _launchUrl(String url) async { //비동기 동작 
    final Uri uri=Uri.parse(url);
    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    } else{
      throw 'Could not launch $url';
    }
  }
}