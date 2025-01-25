import 'package:flutter/material.dart';

customErrorScreen(){

  return ErrorWidget.builder = ((details){
    return Material(
      child: Container(
        // height: double.infinity,
        // width: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Container( decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(
                  'asstes/images/hjg.jpg',
                ),
               ),
          ),),
           const  SizedBox(height: 20,),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(details.exception.toString(),
              style: const TextStyle(color: Color.fromARGB(255, 255, 7, 7), fontSize: 20, ),
              textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );

  });
}