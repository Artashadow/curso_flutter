import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit page'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text('Editar :D'),
          )
        ],
      ),
    );
  }
  
}