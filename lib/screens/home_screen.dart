import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/screens/restauran/restaurant_menu_screen.dart';
import 'package:zaheb/ui/tabs.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool showSearchBar = false;
  bool showSlideZone = false;
  double nearBy = 15.0;
  Position devicePosition;
  final TextEditingController _searchController = TextEditingController();

  int filterBy = 0;
  List<String> categoriesFilterList = [
    'عرض الكل',
    'شعبية',
    'مشاوي',
    'شاورما',
    'بروست',
    'مقاهي',
    'عصيرات',
    'برجر',
    'مخابز',
    'صيني',
    'هندي',
    'امريكي',
    'ايطالي',
    'مكسيكي',
    'لبناني',
    'تركي',
    'لقيمات',
    'حلويات',
    'صحي',
    'مأكولات بحرية',
    'اخرى',
  ];
  @override
  void initState() {
    getCurrentPositionOfThisDevice();
    super.initState();
  }


  getCurrentPositionOfThisDevice() async {
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((p) {
      if(mounted) {
        setState(() {
          devicePosition = p;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Image(
            image: AssetImage('assets/images/zaheb-logo.png'),
            height: 50,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                RotationTransition(
                    child: child, turns: animation
                ),
            child: showSearchBar ? Icon(Icons.close, color: Colors.black) : Icon(Icons.search, color: Colors.black),
          ),
          onTap: () {
            setState(() {
              showSlideZone = false;
              showSearchBar = showSearchBar == false;
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        //  height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: categoriesFilterList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  filterBy = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0, right: 23.0, top: 18.0),
                                child: Text(categoriesFilterList[index].toString(), style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: filterBy == index ? Theme.of(context).primaryColorDark : Colors.black,
                                ),),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 8.0),
                            child: Text('اخفاء', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
            icon: Icon(Icons.sort, color: Colors.black),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) =>
                    RotationTransition(
                        child: child, turns: animation
                    ),
                child: showSlideZone ? Icon(Icons.close, color: Colors.black) : Icon(Icons.format_line_spacing, color: Colors.black),
              ),
              onTap: () {
                if(devicePosition == null) {
                  Toast.show('يرجى السماح بخاصية (GPS) لكي يتم عرض المطاعم حسب الاقرب لموقعك.', context, gravity: Toast.TOP, duration: Duration(seconds: 3).inSeconds);
                } else {
                  setState(() {
                    showSlideZone = showSlideZone == false;
                    showSearchBar = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.width <= 360 ? MediaQuery.of(context).size.height * 0.84 : MediaQuery.of(context).size.height * 0.84,
            child: Stack(
              children: <Widget>[
                showSearchBar ? Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) =>
                        ScaleTransition(
                            child: child, scale: animation
                        ),
                    child: showSearchBar ? Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 50.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(15.0),
                              child: TextFormField(
                                controller: _searchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.send,
                                onFieldSubmitted: (v) {

                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none
                                  ),
                                  hintText: 'بحث ',
                                  hintStyle: TextStyle(color: Colors.black, fontSize: 13.0),
                                  suffix: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.only(top: 1.0, right: 15, bottom: 7),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(4.7),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          MediaQuery.of(context).viewInsets.bottom > 0 ? Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _searchController.text = null;
                              },
                              child: Text('الغاء', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
                            ),
                          ) : SizedBox.shrink(),
                        ],
                      ),
                    ) : SizedBox.shrink(),
                  ),
                ) : SizedBox.shrink(),
                AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  margin: showSearchBar ? EdgeInsets.only(top: 50) : EdgeInsets.only(top: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildRestaurantsContainer(context),
                  ),
                ),
                showSlideZone ? Positioned(
                  bottom: 55,
                  left: 0,
                  right: 0,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) =>
                        ScaleTransition(
                            child: child, scale: animation
                        ),
                    child: showSlideZone ? Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 50.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(15.0),
                              child: Slider(
                                value: nearBy,
                                onChanged: (double value) {
                                  setState(() {
                                    nearBy = value;
                                  });
                                },
                                min: 1,
                                max: 21,
                                label: "${nearBy.toInt()} كم ",
                                divisions: 21,
                                activeColor: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          MediaQuery.of(context).viewInsets.bottom > 0 ? Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _searchController.text = null;
                              },
                              child: Text('الغاء', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
                            ),
                          ) : SizedBox.shrink(),
                        ],
                      ),
                    ) : SizedBox.shrink(),
                  ),
                ) : SizedBox.shrink(),

              ],
            )
        ),
      ),
      bottomNavigationBar: BottomNavBtns(),
    );
  }



  Widget _buildRestaurantsContainer(BuildContext context) {
    return StreamBuilder(
      stream: Database().fetchRestaurant(),
      builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
        if(!snapshot.hasData) {
          return LoadingScreen(true);
        } else {
          return _buildRestaurantsGridList(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildRestaurantsGridList(BuildContext context, List<Restaurant> documentsSec) {
    List<Restaurant> documents = [];
    if(_searchController.text.isNotEmpty) {
      documentsSec.forEach((Restaurant restaurant) {
        if (restaurant.name.contains(_searchController.text))
          documents.add(restaurant);
      });
    } else {
      documents = documentsSec;
    }

    if(devicePosition != null) {
      List<Restaurant> documentsNearby = [];
      documents.forEach((Restaurant restaurantNearBy) {
        int distance = Restaurant.calculateDistance(devicePosition.latitude, devicePosition.longitude, restaurantNearBy.lat, restaurantNearBy.lng);
        if (distance <= nearBy.toInt()) {
          restaurantNearBy.distance = distance;
          documentsNearby.add(restaurantNearBy);
        }
      });
      documentsNearby.sort((a, b) => a.distance.compareTo(b.distance));
      documents = documentsNearby;
    }

    if(filterBy != null) {

      if(filterBy != 0) {
        List<Restaurant> documentsFilterBy = [];
        documents.forEach((Restaurant restaurantFilterBy) {
          if (restaurantFilterBy.categoryNumberType == filterBy) {
            documentsFilterBy.add(restaurantFilterBy);
          }
        });
        documents = documentsFilterBy;
      }
    }


    bool isSmallScreen = false;
    if(MediaQuery.of(context).size.width <= 400) {
      isSmallScreen = true;
    }

    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(documents.length, (index) {
        Restaurant restaurant = documents[index];
        return Container(
          child: InkWell(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => RestaurantMenuScreen(restaurant: restaurant)));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: Text(restaurant.name, style: isSmallScreen ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.headline)),

                      ],
                    ),
                    Container(
                      child: StarDisplay(value: restaurant.stars),
                    ),
                    Flexible(child: Text(restaurant.description, style: TextStyle(fontSize: isSmallScreen ? 9.0 : 11.0),)),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: devicePosition != null ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Flexible(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(Restaurant.calculateDistance(devicePosition.latitude, devicePosition.longitude, restaurant.lat, restaurant.lng).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 10.0 : 15.0)),
                                      SizedBox(width: 5),
                                      Text('كم', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 11.0 : 11.0))
                                    ],
                                  ),
                                )
                              ],
                            ) : SizedBox.shrink(),
                          ),
                          Expanded(
                            child: Hero(
                              tag: 'logo${restaurant.id}',
                              child: Image(
                                image: NetworkImage(restaurant.image),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}


/*
List<Map<String, dynamic>> d = [
                {
                  'image': 'https://pngimg.com/uploads/mcdonalds/mcdonalds_PNG15.png',
                  'name': 'ماكدولنز',
                  'description': 'شركة ماكدونالدز (بالإنجليزية: McDonald\'s Corporation) ‏ تأسست 15 مايو 1940، إحدى أكبر سلسلة مطاعم الوجبات السريعة في العالم. الطعام الأساسي الذي يعده هو البرجر ',
                  'lat': '21.560186',
                  'lng': '39.215149',
                  'city': 'جدة ',
                  'openAt': '8 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://p7.hiclipart.com/preview/121/1018/571/hamburger-whopper-chophouse-restaurant-burger-king-cheeseburger-burger-king-logo.jpg',
                  'name': 'بيرجر كينك',
                  'description': 'برجر كنج (بالإنجليزية: Burger King) هي شركة دولية كبيرة سلسلة مطاعم الوجبات السريعة، معظمهم بيع لحوم والبطاطا المقلية، والمشروبات غير الكحوليه والحلويات ',
                  'lat': '21.628500',
                  'lng': '39.137558',
                  'city': 'جدة ',
                  'openAt': '4 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://upload.wikimedia.org/wikipedia/fr/thumb/b/bf/KFC_logo.svg/1200px-KFC_logo.svg.png',
                  'name': 'دجاج كنتاكي ',
                  'description': 'دجاج كنتاكي أو كي إف سي كما تُعرف حالياً (بالإنجليزية: KFC؛ اختصارا لـ Kentucky Fried Chicken) (والمعنى الحرفية «دجاج كنتاكي المقلي») - هي سلسلة مطاعم للوجبات ',
                  'lat': '21.536236',
                  'lng': '39.128288',
                  'city': 'جدة ',
                  'openAt': '10 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://pngimg.com/uploads/mcdonalds/mcdonalds_PNG15.png',
                  'name': 'ماكدولنز',
                  'description': 'شركة ماكدونالدز (بالإنجليزية: McDonald\'s Corporation) ‏ تأسست 15 مايو 1940، إحدى أكبر سلسلة مطاعم الوجبات السريعة في العالم. الطعام الأساسي الذي يعده هو البرجر ',
                  'lat': '21.560186',
                  'lng': '39.215149',
                  'city': 'جدة ',
                  'openAt': '8 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://p7.hiclipart.com/preview/121/1018/571/hamburger-whopper-chophouse-restaurant-burger-king-cheeseburger-burger-king-logo.jpg',
                  'name': 'بيرجر كينك',
                  'description': 'برجر كنج (بالإنجليزية: Burger King) هي شركة دولية كبيرة سلسلة مطاعم الوجبات السريعة، معظمهم بيع لحوم والبطاطا المقلية، والمشروبات غير الكحوليه والحلويات ',
                  'lat': '21.628500',
                  'lng': '39.137558',
                  'city': 'جدة ',
                  'openAt': '4 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://upload.wikimedia.org/wikipedia/fr/thumb/b/bf/KFC_logo.svg/1200px-KFC_logo.svg.png',
                  'name': 'دجاج كنتاكي ',
                  'description': 'دجاج كنتاكي أو كي إف سي كما تُعرف حالياً (بالإنجليزية: KFC؛ اختصارا لـ Kentucky Fried Chicken) (والمعنى الحرفية «دجاج كنتاكي المقلي») - هي سلسلة مطاعم للوجبات ',
                  'lat': '21.536236',
                  'lng': '39.128288',
                  'city': 'جدة ',
                  'openAt': '10 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://pngimg.com/uploads/mcdonalds/mcdonalds_PNG15.png',
                  'name': 'ماكدولنز',
                  'description': 'شركة ماكدونالدز (بالإنجليزية: McDonald\'s Corporation) ‏ تأسست 15 مايو 1940، إحدى أكبر سلسلة مطاعم الوجبات السريعة في العالم. الطعام الأساسي الذي يعده هو البرجر ',
                  'lat': '21.560186',
                  'lng': '39.215149',
                  'city': 'جدة ',
                  'openAt': '8 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://p7.hiclipart.com/preview/121/1018/571/hamburger-whopper-chophouse-restaurant-burger-king-cheeseburger-burger-king-logo.jpg',
                  'name': 'بيرجر كينك',
                  'description': 'برجر كنج (بالإنجليزية: Burger King) هي شركة دولية كبيرة سلسلة مطاعم الوجبات السريعة، معظمهم بيع لحوم والبطاطا المقلية، والمشروبات غير الكحوليه والحلويات ',
                  'lat': '21.628500',
                  'lng': '39.137558',
                  'city': 'جدة ',
                  'openAt': '4 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://upload.wikimedia.org/wikipedia/fr/thumb/b/bf/KFC_logo.svg/1200px-KFC_logo.svg.png',
                  'name': 'دجاج كنتاكي ',
                  'description': 'دجاج كنتاكي أو كي إف سي كما تُعرف حالياً (بالإنجليزية: KFC؛ اختصارا لـ Kentucky Fried Chicken) (والمعنى الحرفية «دجاج كنتاكي المقلي») - هي سلسلة مطاعم للوجبات ',
                  'lat': '21.536236',
                  'lng': '39.128288',
                  'city': 'جدة ',
                  'openAt': '10 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://pngimg.com/uploads/mcdonalds/mcdonalds_PNG15.png',
                  'name': 'ماكدولنز',
                  'description': 'شركة ماكدونالدز (بالإنجليزية: McDonald\'s Corporation) ‏ تأسست 15 مايو 1940، إحدى أكبر سلسلة مطاعم الوجبات السريعة في العالم. الطعام الأساسي الذي يعده هو البرجر ',
                  'lat': '21.560186',
                  'lng': '39.215149',
                  'city': 'جدة ',
                  'openAt': '8 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://p7.hiclipart.com/preview/121/1018/571/hamburger-whopper-chophouse-restaurant-burger-king-cheeseburger-burger-king-logo.jpg',
                  'name': 'بيرجر كينك',
                  'description': 'برجر كنج (بالإنجليزية: Burger King) هي شركة دولية كبيرة سلسلة مطاعم الوجبات السريعة، معظمهم بيع لحوم والبطاطا المقلية، والمشروبات غير الكحوليه والحلويات ',
                  'lat': '21.628500',
                  'lng': '39.137558',
                  'city': 'جدة ',
                  'openAt': '4 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                },
                {
                  'image': 'https://upload.wikimedia.org/wikipedia/fr/thumb/b/bf/KFC_logo.svg/1200px-KFC_logo.svg.png',
                  'name': 'دجاج كنتاكي ',
                  'description': 'دجاج كنتاكي أو كي إف سي كما تُعرف حالياً (بالإنجليزية: KFC؛ اختصارا لـ Kentucky Fried Chicken) (والمعنى الحرفية «دجاج كنتاكي المقلي») - هي سلسلة مطاعم للوجبات ',
                  'lat': '21.536236',
                  'lng': '39.128288',
                  'city': 'جدة ',
                  'openAt': '10 صباحا',
                  'closeAt': '10 ايلا',
                  'mobile': '+966512345678',
                  'whatsapp': '+966512345678',
                  'timestamp': 1,
                  'numberOfVotes': 0,
                  'stars': 0,
                  'starsTasteQuality': 0,
                  'starsClean': 0,
                  'starsPrepartionTime': 0,
                  'starsTimeCommitment': 0,
                  'starsPackagingRequest': 0,
                }
              ];

              List<Map<String, dynamic> foods = [
              {
  "name": 'بيتزا',
  "description": 'هي أكلة تعود أصولها إلى دول شرق البحر الأبيض المتوسط كاليونان وتركيا حيث كانوا يقومون بإنضاج طبقة من العجين على حجر ساخن ويغطونها ',
  "price": '30',
  "image": 'https://toppng.com/public/uploads/preview/izza-and-cold-drink-images-png-clip-royalty-free-library-pepperoni-pizza-transparent-background-11562941672omkbn3rkfy.png',
},
{
  "name": ' شاورما الضانى ',
  "description": ' شاورما بطعم ورائحة الشوى بتتبيلة مميزة ومختلفة ',
  "price": '15',
  "image": 'https://www.ma7shy.com/media/cache/image_recipe_medium/uploads/media/shawarma-013_1442849073.jpg',
},
{
  "name": ' دجاج  مغربي',
  "description": ' من المطبخ المغربى دجاج بتتبيلة شهية ومختلفة. ',
  "price": '10',
  "image": 'https://www.ma7shy.com/media/cache/image_recipe_medium/uploads/media/cinnamon%20spiced%20moroccan%20chicken%20a%20spicy%20perspective_recipes_1007x545_1459168167.jpg',
}
];


 List<Map<String, dynamic>> reviews = [
                                {
                                  "restaurantId": "test",
                                  "stars": 5,
                                  "starsTasteQuality": 3,
                                  "starsClean": 5,
                                  "starsPrepartionTime": 5,
                                  "starsTimeCommitment": 5,
                                  "starsPackagingRequest": 5,
                                  "name": "اشرف انس",
                                  "review": "وعاء عميق نضع جميع مكونات الصوص ونخلطهم جيدا ثم يغطى ونضعة فى الثلاجة. ",
                                  "userName": "test",
                                  "phoneMobile": "test",
                                  "userId": "test",
                                },
                                {
                                  "restaurantId": "test",
                                  "stars": 5,
                                  "starsTasteQuality": 3,
                                  "starsClean": 5,
                                  "starsPrepartionTime": 5,
                                  "starsTimeCommitment": 5,
                                  "starsPackagingRequest": 5,
                                  "name": "اشرف انس",
                                  "review": "يرص فى طبق التقديم ويقدم مع الصوص السابق تحضيرة بالهنا والشفا.",
                                  "userName": "test",
                                  "phoneMobile": "test",
                                  "userId": "test",
                                  "timestamp": 0,
                                  "date": "test"
                                },
                                {
                                  "restaurantId": "test",
                                  "stars": 5,
                                  "starsTasteQuality": 3,
                                  "starsClean": 5,
                                  "starsPrepartionTime": 5,
                                  "starsTimeCommitment": 5,
                                  "starsPackagingRequest": 5,
                                  "name": "اشرف انس",
                                  "review": "يجب أن يكون الصوص عند التقديم بدرجة حرارة الغرفة",
                                  "userName": "test",
                                  "phoneMobile": "test",
                                  "userId": "test",
                                }
                              ];

                              reviews.forEach((r) {
                                r['timestamp'] = DateTime.now().millisecondsSinceEpoch;
                                r['date'] = DateFormat.yMd().format(DateTime.now());
                                Firestore.instance.collection('restaurants').document(widget.restaurant.id).collection('reviews').document(r['timestamp'].toString()).setData(r);
                                print(r);
                              });

              foods.forEach((r) {
                r['timestamp'] = DateTime.now().millisecondsSinceEpoch;
                Firestore.instance.collection('restaurants').document(r['timestamp'].toString()).setData(r);
                print(r);
              });
 */