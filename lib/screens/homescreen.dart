import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilicis/models/pushnotification.dart';
import 'package:mobilicis/models/shopModel.dart';
import 'package:mobilicis/screens/notification.dart';

import 'package:mobilicis/widgets/carousalImage.dart';
import 'package:mobilicis/widgets/filterButton.dart';
import 'package:mobilicis/widgets/products.dart';
import 'package:mobilicis/widgets/searchbar.dart';
import 'package:mobilicis/widgets/shopBox.dart';
import 'package:mobilicis/widgets/title.dart';
import 'package:mobilicis/widgets/topBrands.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _totalNotifications = 0;
  FirebaseMessaging? _messaging;

  PushNotification? _notificationInfo;
  bool _isLoading = true;
  @override
  void initState() {
    init();
    registerNotification();

    super.initState();
    fetchData();
    fetchFilters();
  }

  init() async {
    String devicetoken = await getdeviceToken();
    print("########### $devicetoken");
  }

  final List<ShopBox> boxDataList = [
    ShopBox(icon: Icons.mobile_friendly, text: 'Bestselling Mobiles'),
    ShopBox(icon: Icons.verified, text: 'Verified Devices Only'),
    ShopBox(icon: Icons.mobile_off, text: 'Like New Condition'),
    ShopBox(icon: Icons.phonelink_ring_outlined, text: 'Phones with Warranty'),
    ShopBox(icon: Icons.phone_iphone, text: 'Shop By Price'),
  ];
  List<Map<String, dynamic>> listings = [];
  Map<String, dynamic> filters = {};

  Future<void> fetchData() async {
    try {
      final response = await Dio().get(
        'https://dev2be.oruphones.com/api/v1/global/assignment/getListings?page=1&limit=10',
      );
      if (response.statusCode == 200) {
        setState(() {
          listings = List<Map<String, dynamic>>.from(
            response.data['listings'],
          );
          _isLoading = false;
        });
        // print(listings);
      }
    } catch (error) {
      // Handle error
      setState(() {
        _isLoading = true;
      });
    }
  }

  Future<Map<String, dynamic>> fetchFilters() async {
    try {
      final response = await Dio().get(
        'https://dev2be.oruphones.com/api/v1/global/assignment/getFilters?isLimited=true',
      );
      if (response.statusCode == 200) {
        filters = response.data['filters'];
        print(filters);
        return filters;
      }
    } catch (error) {
      // Handle error
      print(error);
    }
    return {};
  }

  Future getdeviceToken() async {
    FirebaseMessaging _fbm = FirebaseMessaging.instance;
    String? deviceToken = await _fbm.getToken();
    return deviceToken == null ? "" : deviceToken.toString();
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // ...
        print('User granted permission');
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  String selectedBrand = "All";
  String selectedRam = "All";
  String selectedStorage = "All";
  String selectedConditon = "All";
  String selectedWarranty = "All";
  String selectedVerification = "All";

  void updateSelectedBrand(String brand) {
    setState(() {
      selectedBrand = brand;
    });

    print(selectedBrand);
  }

  void navigateToNotificationScreen() {
    // Reset the notification count when the notification icon is clicked
    setState(() {
      _totalNotifications = 0;
    });

    // Navigate to the NotificationScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(
          notifications: _notificationInfo!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2c2e43),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/hamburger.svg'),
          onPressed: () {},
        ),
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          height: 35,
          width: 35,
          color: Colors.white,
        ),
        actions: [
          const Center(
              child: Text(
            'India',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          )),
          IconButton(
            icon: SvgPicture.asset('assets/images/location.svg',
                height: 25, width: 25),
            onPressed: () {
              // Add your search icon action here
            },
          ),
          Stack(children: <Widget>[
            IconButton(
              icon: SvgPicture.asset(
                'assets/images/notification.svg',
                height: 40,
                width: 20,
                color: Colors.white,
              ),
              onPressed: navigateToNotificationScreen,
            ),
            Positioned(
              // draw a red marble
              top: 8,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  '$_totalNotifications',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]),
        ],
      ),
      body: ListView(
        children: [
          const SearchBar(),
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BoxTitle(
                title: 'Buy Top Brands',
              ),
              const TopBrands(),
              const ImageSlider(),
              const BoxTitle(title: 'Shop By'),
              Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: const Color.fromARGB(255, 249, 248, 248),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: boxDataList.length,
                  itemBuilder: (context, index) {
                    return BoxWidget(
                      data: boxDataList[index],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      BoxTitle(title: 'Best Deals Near You'),
                      Text('India',
                          style: TextStyle(
                              color: Color.fromARGB(255, 218, 190, 29),
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Filter',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          )),
                      IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            List<dynamic> makeList = filters['make'] ?? [];
                            List<dynamic> ramList = filters['ram'] ?? [];
                            List<dynamic> storageList =
                                filters['storage'] ?? [];
                            List<dynamic> conditionList =
                                filters['condition'] ?? [];
                            filterBottomMenu(context, makeList, ramList,
                                conditionList, storageList);
                          })
                    ],
                  ),
                ],
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        final listing = listings[index];
                        return Products(
                            imgUrl: listing["defaultImage"]['fullImage'],
                            price: '₹ ${listing['listingNumPrice'].toString()}',
                            storage: listing['deviceStorage'],
                            deviceCondition: listing['deviceCondition'],
                            name: listing['marketingName'],
                            location: listing['listingLocation'],
                            date: listing['listingDate']);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.89,
                      ),
                    )
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> filterBottomMenu(
      BuildContext context,
      List<dynamic> makeList,
      List<dynamic> ramList,
      List<dynamic> storageList,
      List<dynamic> conditionList) {
    int _lowerValue = 0;
    int _upperValue = 4000000;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.66,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filters',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  TextButton(
                    child: const Text('Clear Filter',
                        style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Text("Brand"),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: makeList
                      .map(
                        (title) => Row(children: [
                          FilterButton(
                            onPress: () => updateSelectedBrand(title),
                            titleBtn: title,
                            isSelected: selectedBrand == title,
                          ),
                          SizedBox(width: 5),
                        ]),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text("Ram"),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ramList
                      .map(
                        (title) => Row(children: [
                          FilterButton(
                            onPress: () => updateSelectedBrand(title),
                            titleBtn: title,
                            isSelected: selectedBrand == title,
                          ),
                          SizedBox(width: 5),
                        ]),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text("Storage"),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: storageList
                      .map(
                        (title) => Row(children: [
                          FilterButton(
                            onPress: () => updateSelectedBrand(title),
                            titleBtn: title,
                            isSelected: selectedBrand == title,
                          ),
                          SizedBox(width: 5),
                        ]),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text("Conditions"),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: conditionList
                      .map(
                        (title) => Row(children: [
                          FilterButton(
                            onPress: () => updateSelectedBrand(title),
                            titleBtn: title,
                            isSelected: selectedBrand == title,
                          ),
                          SizedBox(width: 5),
                        ]),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text("Price"),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Min:"),
                      SizedBox(
                        width: 130,
                        height: 35,
                        child: TextField(
                          keyboardType: TextInputType.number,

                          decoration: InputDecoration(
                            hintText: "0",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          // Other properties and callbacks as needed
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Max:"),
                      SizedBox(
                        width: 130,
                        height: 35,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '400000',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          // Other properties and callbacks as needed
                        ),
                      )
                    ],
                  ),
                ],
              ),
              RangeSlider(
                min: 0,
                max: 4000000,
                divisions: 51,
                activeColor: const Color(0xFF2c2e43),
                values:
                    RangeValues(_lowerValue.toDouble(), _upperValue.toDouble()),
                onChanged: (RangeValues values) {
                  setState(() {
                    _lowerValue = values.start.round();
                    _upperValue = values.end.round();
                  });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF2c2e43),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Circular border radius
                  ),
                  minimumSize: const Size(400, 44),
                ),
                child: const Text('APPLY'),
              )
            ],
          ),
        );
      },
    );
  }
}
