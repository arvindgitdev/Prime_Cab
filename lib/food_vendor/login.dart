import 'package:flutter/material.dart';
//ui0i mport 'package:primecabs/Consumer/home_page.dart';
import 'package:primecabs/food_vendor/fv_home.dart';


class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to PrimeServices",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.black),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //iconColor: Colors.white,
                        backgroundColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyCustomWidget(),
                          )
                      );

                    },
                    child: Text("continue",
                      style: TextStyle(color: Colors.white),)),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 18.0,right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('-------',style: TextStyle(color: Colors.black,fontSize: 25),),
                    Text('or Login with',style: TextStyle(color: Colors.black),),
                    Text('-------',style: TextStyle(color: Colors.black,fontSize: 25),),

                  ],
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Icon(Icons.g_mobiledata,color: Colors.white,size: 40,),
                ),
                  SizedBox(width: 30,),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18)
                    ),
                    child: Icon(Icons.apple,color: Colors.white,size: 40,),

                  )
                ],

              )
            ],
          ),
        ),
      ),
    );
  }
}