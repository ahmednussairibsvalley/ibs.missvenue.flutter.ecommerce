import 'package:intl/intl.dart';
import 'package:miss_venue/model/brand.dart';
import 'package:miss_venue/model/country.dart';
import 'package:miss_venue/model/state.dart';

import 'model.dart';

/// This is the Controller class which represents
/// the controller according to MVC (Model - View - Controller).
/// It communicates with the model and brings data to
/// the UI.
class Controller {
  /// The Customer object.
  Customer _customer;

  ///List of Product objects which
  ///represents the products which
  ///have offers.
  List<Product> _offers;

  ///List of Sector objects
  List<Sector> _sectors;

  ///List of countries returned from the API
  List<Country> _countries;

  Controller() {
    _offers = List();
    _sectors = List();
    _countries = List();
  }


  List<Country> get countries => _countries;

  set countries(List<Country> value) {
    _countries = value;
  }

  /// Initialize the Customer object.
  initCustomer(int id, String firstName, String lastName, String email,
      String phone) {
    _customer = Customer(id, firstName, lastName, email, phone);
    _testData();
  }

  initCustomerFromJson(Map json) {
    _customer = Customer.fromJson(json);
    _testData();
  }

  ///Adds a product to the customer's wishlist.
  addToWishList(Product product) {
    if (_customer != null) _customer.wishList.add(product);
  }

  ///Removes a product from the customer's wishlist.
  removeFromWishList(Product product) {
    if (_customer != null) {
      _customer.wishList.remove(product);
    }
  }

  ///Adds a product with specified quantitiy to
  ///the customer's cart.
  addToCart(Product product, int quantity) {
    CartItem item = CartItem(product.id, product, quantity);
    bool _added = false;
    if (_customer != null) {
      for (int i = 0; i < _customer.cart.length; i++) {
        if (_customer.cart[i].product == product) {
          _added = true;
          break;
        }
      }
      if (!_added) {
        _customer.cart.add(item);
      }
    }
  }

  ///Removes a product from
  ///the customer's cart.
  removeFromCart(Product product) {
    if (_customer != null) {
      for (int i = 0; i < _customer.cart.length; i++) {
        if (_customer.cart[i].product.id == product.id) {
          _customer.cart.remove(_customer.cart[i]);
          break;
        }
      }
    }
  }

  ///Adds an address to the customer's
  ///addresses list.
  addAddress(Address address) {
    if (_customer != null) _customer.addresses.add(address);
  }

  ///Removes an address from the customer's
  ///addresses list
  removeAddress(Address address) {
    if (_customer != null) {
      _customer.addresses.remove(address);
    }
  }

  ///Adds an order to the customer's
  ///orders list
  addOrder(Order order) {
    if (_customer != null) _customer.orders.add(order);
  }

  ///Removes an order from the customer's
  ///orders list
  removeOrder(Order order) {
    if (_customer != null) {
      _customer.orders.remove(order);
    }
  }

  ///Gets the Customer object.
  Customer get customer => _customer;

  ///Gets an address by its ID.
  Address getAddressById(int id) {
    Address address;
    for (int i = 0; i < _customer.addresses.length; i++) {
      if (_customer.addresses[i].id == id) {
        address = _customer.addresses[i];
        break;
      }
    }
    return address;
  }

  ///Gets an order by its ID.
  Order getOrderById(int id) {
    Order order;
    for (int i = 0; i < _customer.orders.length; i++) {
      if (_customer.orders[i].id == id) {
        order = _customer.orders[i];
        break;
      }
    }
    return order;
  }

  ///Gets a product by its ID.
  Product getProductById(int id) {
    Product _product;
    for (int i = 0; i < sectors.length; i++) {
      for (int j = 0; j < sectors[i].categories.length; j++) {
        for (int a = 0; a < sectors[i].categories[j].products.length; a++) {
          if (sectors[i].categories[j].products[a].id == id) {
            _product = sectors[i].categories[j].products[a];
            break;
          }
        }
      }
    }
    return _product;
  }

  ///Returns the product's sector index.
  int getProductSectorIndex(int productId) {
    int index = -1;
    for (int i = 0; i < sectors.length; i++) {
      for (int j = 0; j < sectors[i].categories.length; j++) {
        for (int a = 0; a < sectors[i].categories[j].products.length; a++) {
          if (sectors[i].categories[j].products[a].id == productId) {
            index = i;
            break;
          }
        }
      }
    }
    return index;
  }

  ///Returns the product's category index.
  int getProductCategoryIndex(int productId) {
    int index = -1;
    for (int i = 0; i < sectors.length; i++) {
      for (int j = 0; j < sectors[i].categories.length; j++) {
        for (int a = 0; a < sectors[i].categories[j].products.length; a++) {
          if (sectors[i].categories[j].products[a].id == productId) {
            index = j;
            break;
          }
        }
      }
    }
    return index;
  }

  ///Gets an item from the customer's
  ///cart using the cart item's ID.
  CartItem getCartItemById(int id) {
    CartItem item;
    for (int i = 0; i < _customer.cart.length; i++) {
      if (_customer.cart[i].id == id) {
        item = _customer.cart[i];
        break;
      }
    }
    return item;
  }

  ///Gets the offers list.
  List<Product> get offers => _offers;

  ///Gets the sectors list ..
  List<Sector> get sectors => _sectors;

  ///Increases the quantity of items in
  ///the customer's cart.
  increaseCartItemQuantity(CartItem item) {
    int quantity = item.quantity + 1;
    item.quantity = quantity;
  }

  ///Decreases the quantity of items in
  ///the customer's cart.
  decreaseCartItemQuantity(CartItem item) {
    if (item.quantity > 1) {
      int quantity = item.quantity - 1;
      item.quantity = quantity;
    }
  }

  ///Does the customer's cart contain
  ///the product whose id is the
  ///productId?
  bool containsCartItem(int productId) {
    bool value = false;

    for (int i = 0; i < _customer.cart.length; i++) {
      if (_customer.cart[i].product.id == productId) {
        value = true;
        break;
      }
    }
    return value;
  }

  ///Does the customer's wishlist contain
  ///the product whose id is the
  ///productId?
  bool containsWishListItem(int productId) {
    bool value = false;
    for (int i = 0; i < _customer.wishList.length; i++) {
      if (_customer.wishList[i].id == productId) {
        value = true;
        break;
      }
    }
    return value;
  }

  ///Calculates the total price of the
  ///items in the customer's cart and
  ///returns it.
  double calculateTotalPrice() {
    double sum = 0;

    for (int i = 0; i < _customer.cart.length; i++) {
      //print('Item price: ${_customer.cart[i].product.price}');
      if (_customer.cart[i].product.sellingPrice <
          _customer.cart[i].product.price) {
        sum = sum +
            (_customer.cart[i].product.sellingPrice *
                _customer.cart[i].quantity);
      } else {
        sum = sum +
            (_customer.cart[i].product.price * _customer.cart[i].quantity);
      }
    }
    return sum;
  }

  ///Populates sectors list.
  populateSectors(List list) {
    for (int i = 0; i < list.length; i++) {
      _sectors.add(Sector.fromJson(list[i]));
    }
  }

  ///Populates categories list for each sector.
  populateCategories(int sectorIndex, List list) {
    for (int i = 0; i < list.length; i++) {
      _sectors[sectorIndex].categories.add(Category.fromJson(list[i]));
    }
  }

  ///Populates products list for each category from each sector.
  populateProducts(int sectorIndex, int categoryIndex, List list) {
    for (int i = 0; i < list.length; i++) {
      Product product = Product.fromJsonWithRelatedProducts(list[i]);
      _sectors[sectorIndex].categories[categoryIndex].products.add(product);
      if (product.sellingPrice < product.price) {
        _offers.add(product);
      }
    }
  }

  ///Populates brands list for each category from each sector.
  populateBrands(int sectorIndex, int categoryIndex, List list) {
    for (int i = 0; i < list.length; i++) {
      Brand brand = Brand.fromJson(list[i]);
      _sectors[sectorIndex].categories[categoryIndex].brands.add(brand);
    }
  }

  Map<String, Map<int, String>> getAttributes(int sectorIndex,
      int categoryIndex,
      int productIndex,) {
    Map<String, Map<int, String>> result;

    for (int i = 0;
    i <
        sectors[sectorIndex]
            .categories[categoryIndex]
            .products[productIndex]
            .attributes
            .length;
    i++) {
      result[sectors[sectorIndex]
          .categories[categoryIndex]
          .products[productIndex]
          .attributes[i]
          .name] =
          getAttributesValues(sectorIndex, categoryIndex, productIndex, i);
    }

    return result;
  }

  Map<int, String> getAttributesValues(int sectorIndex,
      int categoryIndex,
      int productIndex,
      int attributeIndex,) {
    Map<int, String> result;

    for (int i = 0;
    i <
        sectors[sectorIndex]
            .categories[categoryIndex]
            .products[productIndex]
            .attributes[attributeIndex]
            .values
            .length;
    i++) {
      result[sectors[sectorIndex]
          .categories[categoryIndex]
          .products[productIndex]
          .attributes[attributeIndex]
          .values[i]
          .id] =
          sectors[sectorIndex]
              .categories[categoryIndex]
              .products[productIndex]
              .attributes[attributeIndex]
              .values[i]
              .name;
    }
    return result;
  }

  populateCountries(List json) {
    for (int i = 0; i < json.length; i++) {
      _countries.add(Country.fromJson(json[i]));
    }
  }

  populateStates(int countryIndex, List json) {
    for (int i = 0; i < json.length; i++) {
      countries[countryIndex].states.add(State.fromJson(json[i]));
    }
  }


  ///It's just test data to populate
  ///fields and objects as there is no
  ///ready API for the project
  _testData() {
//    final addresses = [
//      Address(1, '40, The 10th District, Nasr City', 'First Floor, Suite 3',
//          '+201118301953', 'Nasr City', 'Cairo', 'Egypt'),
//      Address(
//          2,
//          '100, Al-Maadi',
//          '',
//          '+201118551353',
//          'Al-Maadi',
//          'Cairo',
//          'Egypt'),
//    ];
//    _customer.addresses.add(addresses[0]);
//    _customer.addresses.add(addresses[1]);

    final orders = [
      Order(10023, 'Pending', DateTime.utc(2019, 4, 20)),
      Order(10006, 'On Way', DateTime.utc(2019, 4, 19)),
      Order(10023, 'Delivered', DateTime.utc(2019, 3, 25)),
    ];

    _customer.orders.add(orders[0]);
    _customer.orders.add(orders[1]);
    _customer.orders.add(orders[2]);
  }
}
