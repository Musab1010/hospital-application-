// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:flutter/material.dart';

// class Textinputpassword extends StatefulWidget {
//   const Textinputpassword({super.key, 
//     // super.key,
//     this.labl,
//     this.labl1,
//     this.controllertext,
//     //required this.obscurel,
//     required this.icon,
//   });

//   final labl;
//   final labl1;
//   final controllertext;
//   final Icon icon;

//   @override
//   State<Textinputpassword> createState() => _TextinputpasswordState();
// }

// class _TextinputpasswordState extends State<Textinputpassword> {
//   bool passToggle = true;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: TextFormField(
//             controller: widget.controllertext,
//              onChanged: (value) {
//               widget.controllertext;
              
//             },
//             obscureText: passToggle,
//             decoration: InputDecoration(
//               hintText: widget.labl,
//               labelText: widget.labl1,
//               icon: widget.icon ,
//               border: InputBorder.none,
//               suffixIcon: InkWell(
//                 onTap: () {
//                   setState(() {
//                     passToggle = !passToggle;
//                   });
//                 },
//                 child:
//                     Icon(passToggle ? Icons.visibility : Icons.visibility_off, ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
