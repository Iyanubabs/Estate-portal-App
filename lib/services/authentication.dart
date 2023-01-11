import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estate_portal_copy/models/occupant_model.dart';
import 'package:estate_portal_copy/screens/pages/signIn_page.dart';
import 'package:estate_portal_copy/screens/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

class AuthenticationService {
  Future<String> getName(houseNo) async {
    String name = '';
    ByteData data = await rootBundle.load("assets/spreadSheet/500 ALL.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      excel.tables[table]!.rows.forEach((element) {
        if (element[3]!.value.toString() == houseNo) {
          name = '${element[1]!.value} ${element[2]!.value}';
          print('yes $name');
        }
      });
    }
    return name;
  }

  // Future<bool> login(
  //   email,
  //   password,
  // ) async {
  //   bool isLOggedINFalse = false;
  //   try {
  //     final user = (await FirebaseAuth.instance
  //             .signInWithEmailAndPassword(email: email, password: password))
  //         .user;

  //     if (user != null) {
  //       isLOggedINFalse = true;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     isLOggedINFalse = false;
  //     print(e.message);
  //     // final errorMessage = getMessageFromErrorCode(e);
  //   } catch (e) {
  //     isLOggedINFalse = false;
  //     print(e.toString());
  //   }
  //   return isLOggedINFalse;
  // }
}
