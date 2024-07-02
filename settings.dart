import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({Key? key});

 
 @override
  State<StatefulWidget> createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage>{
  final _formKey = GlobalKey<FormState>();
  bool _obscureText =true;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Scrollbar(
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...[
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Enter your ID',
                              labelText: 'ID',
                            ),
                            onChanged: (value){print(value);},
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'Enter your Password',
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText?Icons.visibility:Icons.visibility_off),
                                onPressed: () {
                                  setState(() { // 강제 갱신
                                    _obscureText=!_obscureText;
                                  });
                                } ,
                              ),
                            ),
                            obscureText: _obscureText, //비밀번호 필드 
                            onChanged: (value){print(value);},
                          ),  
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}