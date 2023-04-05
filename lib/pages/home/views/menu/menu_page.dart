import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/components/category_list.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/components/search_box.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/menu_process_page.dart';
import 'package:mefl_app_bloc/services/menu_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  MenuService _menuService = MenuService();

  @override
  void initState() {
    super.initState();
    _menuService.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        width: SizeConfig.blockWidth,
        height: SizeConfig.blockHeight! - SizeConfig.blockVertical! * 10,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding * 2,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Home',
                        style: boldFont.copyWith(
                          fontSize: SizeConfig.blockHorizontal! * 6,
                          color: blackColor,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Icon(Icons.menu)),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.blockVertical! * 2),
                SearchBox(
                  services: _menuService,
                ),
                SizedBox(height: SizeConfig.blockVertical! * 2),
                StreamBuilder(
                  stream: _menuService.allCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      if (data
                          .where((element) => element.name == "All")
                          .isEmpty) {
                        data.insert(
                            0, CategoryModel(name: "All", categoryId: ""));
                      }
                      return CategoryList(
                        categories: data,
                        services: _menuService,
                      );
                    }
                    return Container(
                      height: SizeConfig.blockVertical! * 4,
                    );
                  },
                ),
                SizedBox(height: SizeConfig.blockVertical! * 2),
                StreamBuilder(
                  stream: _menuService.allMenus,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.length > 0) {
                      final data = snapshot.data!;
                      return BlocBuilder<MenuBloc, MenuState>(
                        builder: (context, state) {
                          return Expanded(
                            child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 18,
                                      mainAxisSpacing: 18,
                                      childAspectRatio: 0.7),
                              shrinkWrap: false,
                              itemBuilder: ((context, index) {
                                MenuModel product = data[index];
                                bool registered = state.cart
                                    .where((item) => item.name == product.name)
                                    .isNotEmpty;
                                return GestureDetector(
                                  key: Key(product.name),
                                  onTap: () {
                                    context.read<MenuBloc>().add(
                                        AddItemToCartButtonEvent(
                                            item: product));
                                  },
                                  child: Container(
                                    height: SizeConfig.blockVertical! * 32,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    product.image!),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x11000000),
                                                  blurRadius: 40.0,
                                                  offset: Offset(20, 20),
                                                )
                                              ],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: whiteColor,
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: SizeConfig
                                                          .blockVertical! *
                                                      2,
                                                  right: SizeConfig
                                                          .blockHorizontal! *
                                                      5,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: SizeConfig
                                                              .blockHorizontal! *
                                                          4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      color: Color.fromARGB(
                                                          84, 186, 132, 132),
                                                    ),
                                                    child: Text(
                                                      formatter.format(
                                                          product.price),
                                                      style: boldFont.copyWith(
                                                        color: whiteColor,
                                                        fontSize: SizeConfig
                                                                .blockHorizontal! *
                                                            3.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // Registered
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: AnimatedScale(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    scale: registered ? 1 : 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: blackColor,
                                                      ),
                                                      child: Icon(
                                                        Icons.check,
                                                        size: SizeConfig
                                                                .blockHorizontal! *
                                                            5,
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: SizeConfig.blockVertical!),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            product.name,
                                            style: boldFont.copyWith(
                                                color: blackColor,
                                                fontSize: SizeConfig
                                                        .blockHorizontal! *
                                                    4.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasData) {
                      return Container(
                        height: SizeConfig.blockHeight! / 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store,
                                size: SizeConfig.blockHorizontal! * 20,
                                color: accentColor.withOpacity(0.5),
                              ),
                              Text(
                                "No Data Registered Yet",
                                style: semiBoldFont.copyWith(
                                    color: accentColor.withOpacity(0.5),
                                    fontSize: SizeConfig.blockHorizontal! * 4),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: SizeConfig.blockVertical! * 78,
              right: 0,
              child: BlocBuilder<MenuBloc, MenuState>(
                bloc: BlocProvider.of<MenuBloc>(context),
                builder: (context, state) {
                  if (state.cart.length > 0) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<MenuBloc>(context),
                              child: MenuProcessPage(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12.0),
                        backgroundColor: accentColor,
                      ),
                      child: Text(
                        state.cart.length.toString(),
                        style: boldFont.copyWith(
                          fontSize: SizeConfig.blockHorizontal! * 4,
                        ),
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12.0),
                      backgroundColor: accentColor,
                    ),
                    child: Icon(Icons.local_grocery_store),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
