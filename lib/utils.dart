import 'dart:convert';
import 'dart:io';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';
import 'globals.dart';

/*
* Set of methods for consuming
* the web services ..
*
*
*/

final _baseUrl = 'http://40.85.116.121:8678';


Future<Map> authenticate(String email, String password) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/login';


  try {
    var response =
    await http.post(apiUrl,
      body: {'Email': email, 'Password': password},);

//  var response =
//  await http.post(apiUrl,
//    body: {'Email': 'ismail3@mycompany.com', 'Password': '38954857213'},);
    print(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      result = json.decode(response.body);


      print('${result.toString()}');
//    Globals.customerId =
//    result['Result'] == true ? result['Customer_Id']
//        : result['Result'] == false ? 0
//        : 0;
//    return result['Result'] == true ? true
//        : result['Result'] == false ? false
//        : null;
    }
  } on SocketException catch (e) {
    print('$e');
    result = null;
  } catch (e) {
    print('$e');
    result = null;
  }

  return result;

}

Future<String> sendForPasswordRecovery(String email) async {
  String apiUrl = '$_baseUrl/Customer/mobile_PasswordRecoverySend';
  var response = await http.post(apiUrl, body: {'Email': email,});
  if(response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202){
    Map result = json.decode(response.body);
    Globals.customerId =
    result['Result'] == true ? result['Customer_Id']
        : result['Result'] == false ? 0
        : 0;
    return result['Result'];
  } else {
    return null;
  }
}

Future<Map> register(String firstName, String lastName,
    String email, String phone,
    String password, String passwordConfirm) async{
  String apiUrl = '$_baseUrl/api/customer/register';
  var _userName = '$firstName $lastName';
  var response = await http.post(apiUrl,
      body: {'firstName' : firstName, 'lastName' : lastName, 'email' : email, 'phone_No' : phone, 'password' : password});

  if(response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202){
    Map result = json.decode(response.body);

    return result;

  }

  return null;

}

Future<Map> loginWithFacebook() async{
  Map map;
  try{
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,cover,picture.type(large),email&access_token=$token');
    print('${graphResponse.statusCode}');
    if(graphResponse.statusCode == 200){
      final profile = json.decode(graphResponse.body);
      print('${profile.toString()}, token: $token');
      print('${profile['first_name']}');
      //return true;


      map = profile;
      map['id'] = profile['id'];
      map['firstName'] = profile['first_name'];
      map['lastName'] = profile['last_name'];
      map['email'] = profile['email'];
      map['imageUrl'] = profile['picture']['data']['url'];

      Map customerMap = await register(profile['firstName'], profile['lastName'], profile['email'], '', '123', '123');
      Globals.customerId = customerMap['customer_id'];
      map['id'] = customerMap['customer_id'];
      print('${map['id']}');
    }
  } catch(error){
    map = null;
  }

  print('${map.toString()}');
  return map;
}

Future<Map> loginWithGoogle() async{
  Map map;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

//  String value = DateFormat.yMMMMd().format(DateTime.now());
//  print(value);
  try {
    final result = await _googleSignIn.signIn();
    //print('${result.email}');
    //print('${result.displayName}');
    //print('${result.id}');
    //print('${result.photoUrl}');
    Map tmpMap = Map();
    tmpMap['id'] = result.id;
    List names = result.displayName.split(' ');
    tmpMap['firstName'] = names[0];
    tmpMap['lastName'] = names[1];
    tmpMap['email'] = result.email;
    tmpMap['imageUrl'] = result.photoUrl;

    map = await register(
        tmpMap['firstName'], tmpMap['lastName'], tmpMap['email'], '', '123',
        '123');
//    Globals.customerId = customerMap['customer_id'];
//    map['id'] = customerMap['customer_id'];
    print('$map');
    //return true;
  }on SocketException catch (_) {
    map = null;
    print('not connected');
  } catch (error) {
    map = null;
    print(error);
    //return false;
  }
  return map;
}

Future<List> getSectorsList() async {
  String apiUrl = '$_baseUrl/api/Category/Sectors?count=100';

  try {
    var response = await http.get(apiUrl);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      var result = json.decode(response.body);
      return result;
    }
    return null;
  } catch (error) {
    return null;
  }

}

Future<List> getCategoriesList(int sectorId) async{
  String apiUrl = '$_baseUrl/api/Category/home?count=100&sector_id=$sectorId';

  var response = await http.get(apiUrl);

  try {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      var result = json.decode(response.body);
      return result;
    }
    return null;
  } catch (e) {
    return null;
  }
}

/// Gets the products list for a category specified
/// by its ID categoryId from the API.
Future<List> getProductsList(int categoryId) async {
  String apiUrl = '$_baseUrl/api/Category/details?category_id=$categoryId';

  try {
    var response = await http.get(apiUrl);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      var result = json.decode(response.body);
      return result['products'];
    }
    return null;
  } catch (e) {
    return null;
  }

}

/// Gets the brands list for a category specified
/// by its ID categoryId from the API.
Future<List> getBrandsList(int categoryId) async {
  String apiUrl = '$_baseUrl/api/Category/details?category_id=$categoryId';

  try {
    var response = await http.get(apiUrl);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      var result = json.decode(response.body);
      return result['Brands'];
    }
    return null;
  } catch (e) {
    return null;
  }
}

///Is the image accessible by its URL.
Future<bool> isImageAvailable(String imageUrl) async{
  if(imageUrl.isEmpty || imageUrl == null){
    return false;
  }
  var response = await http.get(imageUrl);

  if(response.statusCode == 200){
    return true;
  }
  return false;
}