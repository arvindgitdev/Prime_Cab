import 'package:flutter/material.dart';

class RegScreen extends StatelessWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 80.0,left: 20),
                child: Column(
                  children: [
                    Text(
                      'Welcome to\nPrimecab',
                      style: TextStyle(
                      fontSize: 38,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Let's Create your Account",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          //fontWeight: FontWeight.bold),
                    ),
                    )
                  ]
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child:  Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                            label: Text('Full Name',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                            ),)
                        ),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                            label: Text('Phone or Gmail',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                            ),)
                        ),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                            label: Text('Car no',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                            ),)
                        ),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                            label: Text('Car color',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                            ),)
                        ),
                      ),

                      const SizedBox(height: 10,),
                      const SizedBox(height: 70,),
                      Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                          /*gradient: const LinearGradient(
                              colors: [
                                Color(0xffB81736),
                                Color(0xff281537),
                              ]
                          ),*/
                        ),
                        child: const Center(child: Text('continue',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                        ),),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}