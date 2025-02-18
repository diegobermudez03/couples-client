import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuizzesHomepage extends StatelessWidget{
  const QuizzesHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TextField(),
              Container(
                child: Text("Quizes"),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [for(int i in Iterable.generate(20)) i].map((_){
                    return SizedBox(
                      width: 200,
                      height: 110,
                      child: Shimmer.fromColors(
                        child: Card(),
                        baseColor: Colors.grey.shade300, 
                        highlightColor: Colors.grey.shade100
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            heightFactor: 18,
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.add),
            )
          )
        ],
      )
    );
  }
}