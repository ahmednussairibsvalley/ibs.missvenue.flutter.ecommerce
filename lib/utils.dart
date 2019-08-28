import 'dart:convert';
import 'dart:io';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';

/*
* Set of methods for consuming
* the web services ..
*
*
*/

///The base URL.
final _baseUrl = 'http://40.85.116.121:8678';

///Used for login.
Future<Map> authenticate(String email, String password) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/login';

  try {
    var response = await http.post(
      apiUrl,
      body: {'Email': email, 'Password': password, 'RegistrationType': '1'},
    );

//  var response =
//  await http.post(apiUrl,
//    body: {'Email': 'ismail3@mycompany.com', 'Password': '38954857213'},);
//    print(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      result = json.decode(response.body);

      Globals.customerId = result['Customer']['Customer_Id'];
//      print('${result.toString()}');
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

///Gets the total price of the customer's cart's items
Future<double> getTotalPrice(int customerId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/details?Id=$customerId';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result['ShoppingCart']['Total_Amount'];
}

///Gets the list of offers from the API.
Future<List> getOffers() async {
  List result;
  String apiUrl = '$_baseUrl/api/product/select?categoryId=null&manufacturerId=null&productId=null&hasOffer=true';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Gets the customer details
Future<Map> getCustomerDetails(int customerId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/details?Id=$customerId';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Gets the customer wish list data from the API.
Future<Map> getCustomerWishList(int customerId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/details?Id=$customerId';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result['WishList'];
}

///Gets the customer cart data from the API.
Future<Map> getCustomerCart(int customerId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/details?Id=$customerId';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result['ShoppingCart'];
}

///Gets the customer's addresses from the API.
Future<List> getCustomerAddresses(int customerId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/details?Id=$customerId';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result['Addresses'];
}

///Gets the countries list from the API.
Future<List> getCountriesFromApi() async {
  List result;
  String apiUrl = '$_baseUrl/api/address/country_list?Id=null';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Gets the states list for the country
///specified by its countryId from the API.
Future<List> getStatesFromApi(int countryId) async {
  List result;
  String apiUrl = '$_baseUrl/api/address/state_list?Id=null&country_id=$countryId';
  var response = await http.get(apiUrl);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Sends to the API for password recovery.
Future<Map> sendForPasswordRecovery(String email) async {
  String apiUrl = '$_baseUrl/api/password/recovery';
  var response = await http.post(apiUrl, body: {
    'email': email,
  });
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    Map result = json.decode(response.body);
    return result;
  } else {
    return null;
  }
}

///Updates the password.
Future<Map> updatePassword(String oldPassword, String newPassword) async {
  Map result;
  String apiUrl = '$_baseUrl/api/password/update';
  var response = await http.post(apiUrl, body: {
    "customerid": '${Globals.customerId}',
    "oldpassword": oldPassword,
    "newpassword": newPassword
  });

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Updates the customer profile.
Future<Map> updateCustomerProfile(String firstName, String lastName,
    String email, String phone) async {
  Map result;
  String apiUrl = '$_baseUrl/api/customer/update';
  var response = await http.post(apiUrl, body: {
    "customerid": '${Globals.customerId}',
    "firstname": firstName,
    "lastname": lastName,
    "email": email,
    "phone": phone
  });
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Used for signing up.
Future<Map> register(String firstName, String lastName, String email,
    String phone, String password, String passwordConfirm) async {
  String apiUrl = '$_baseUrl/api/customer/register';
  var response = await http.post(apiUrl, body: {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone_No': phone,
    'password': password
  });

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    Map result = json.decode(response.body);

    return result;
  }

  return null;
}

///Used for login with Facebook.
Future<Map> loginWithFacebook() async {
  Map map;
  try {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,cover,picture.type(large),email&access_token=$token');
//    print('${graphResponse.statusCode}');
    if (graphResponse.statusCode == 200) {
      final profile = json.decode(graphResponse.body);
//      print('${profile.toString()}, token: $token');
//      print('${profile['first_name']}');
      //return true;

      map = profile;
      map['id'] = profile['id'];
      map['firstName'] = profile['first_name'];
      map['lastName'] = profile['last_name'];
      map['email'] = profile['email'];
      map['imageUrl'] = profile['picture']['data']['url'];

      Map customerMap = await register(profile['firstName'],
          profile['lastName'], profile['email'], '', '123', '123');
      Globals.customerId = customerMap['customer_id'];
      map['id'] = customerMap['customer_id'];
//      print('${map['id']}');
    }
  } catch (error) {
    map = null;
  }

//  print('${map.toString()}');
  return map;
}

///Used for login with Google+.
Future<Map> loginWithGoogle() async {
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

    map = await register(tmpMap['firstName'], tmpMap['lastName'],
        tmpMap['email'], '', '123', '123');
    Globals.customerId = map['customer_id'];
//    map['id'] = customerMap['customer_id'];
//    print('$map');
    //return true;
  } on SocketException catch (_) {
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

///Gets the list of categories for a sector
///specified by its sectorId from the API.
Future<List> getCategoriesList(int sectorId) async {
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
Future<bool> isImageAvailable(String imageUrl) async {
  if (imageUrl.isEmpty || imageUrl == null) {
    return false;
  }
  var response = await http.get(imageUrl);

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

///Adds a product specified by its productId with
///specified quantity to the customer's cart.
Future<Map> addToCart(int productId, int quantity) async {
  Map result;
  String apiUrl = '$_baseUrl/api/Cart/add';
  var response = await http.post(
    apiUrl,
    body: {
      'ShoppingCartTypeId': '2',
      'customerId': '${Globals.customerId}',
      'productId': '$productId',
      'quantity': '$quantity'
    },
  );
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Removes a product specified by its productId with
///specified quantity from the customer's cart.
Future<Map> removeFromCart(int productId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/Cart/update';
  var response = await http.post(
    apiUrl,
    body: {
      'ShoppingCartTypeId': '2',
      'customerId': '${Globals.customerId}',
      'productId': '$productId',
      'quantity': '0'
    },
  );
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Updates the cart item quantity.
Future<Map> updateCartItem(int productId, int quantity) async {
  Map result;
  String apiUrl = '$_baseUrl/api/Cart/update';
  var response = await http.post(
    apiUrl,
    body: {
      'ShoppingCartTypeId': '2',
      'customerId': '${Globals.customerId}',
      'productId': '$productId',
      'quantity': '$quantity'
    },
  );
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Adds a product specified by its productId
///to the customer's wishlist
Future<Map> addToWishList(int productId) async {
  Map result;
  String apiUrl = '$_baseUrl/api/Cart/add';
  print('${Globals.customerId}');
  try {
    var response = await http.post(
      apiUrl,
      body: {
        "ShoppingCartTypeId": "1",
        "customerId": "${Globals.customerId}",
        "productId": "$productId",
        "quantity": "1"
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      result = json.decode(response.body);
    }
  } on SocketException catch (e) {
    print('$e');
  } catch (e) {
    print('$e');
  }

  return result;
}

///Removes a product specified by its productId
///from the customer's wishlist
Future<Map> removeFromWishList(int productId) async {
//  print('Customer ID: ${Globals.customerId}');
//  print('Product ID: $productId');
  Map result;
  String apiUrl = '$_baseUrl/api/Cart/update';
  var response = await http.post(
    apiUrl,
    body: {
      'ShoppingCartTypeId': '1',
      'customerId': '${Globals.customerId}',
      'productId': '$productId',
      'quantity': '0'
    },
  );
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}

///Adds new address to the user's addresses.
Future<Map> addAddress({
  @required String address1, @required String address2,
  @required String firstName, @required String lastName,
  @required String city, @required int countryId, @required int stateId,
  @required String email, @required String phone
}) async {
  Map result;
  String apiUrl = '$_baseUrl/api/address/add';
  var response = await http.post(
    apiUrl,
    body: {
      'customerid': '${Globals.customerId}',
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'city': city,
      'address1': address1,
      'address2': address2,
      'countryId': '$countryId',
      'stateProvinceId': '$stateId',
      'phoneNumber': phone,
    },
  );
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    result = json.decode(response.body);
  }
  return result;
}