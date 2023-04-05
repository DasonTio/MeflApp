import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/pages/home/home_page.dart';
import 'package:mefl_app_bloc/pages/home/home_view.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/print/menu_print_page.dart';
import 'package:mefl_app_bloc/repository/transaction_repo.dart';
import 'package:mefl_app_bloc/services/menu_service.dart';

class MenuProcessPage extends StatefulWidget {
  const MenuProcessPage({Key? key}) : super(key: key);

  @override
  _MenuProcessPageState createState() => _MenuProcessPageState();
}

class _MenuProcessPageState extends State<MenuProcessPage> {
  TransactionRepo _transactionRepo = TransactionRepo();
  MenuService _menuService = MenuService();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state.status == MenuStatus.success) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuPrintPage(
                    transactionId: state.transactionId,
                  ),
                ));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: SizeConfig.blockHeight! - SizeConfig.blockVertical! * 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  paddingContent(
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: SizeConfig.blockHorizontal! * 20,
                        ),
                        Text(
                          "Proses Menu",
                          style: boldFont.copyWith(
                            fontSize: SizeConfig.blockHorizontal! * 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  paddingContent(TextFormField(
                    onChanged: (value) => () {},
                    decoration: InputDecoration(
                      hintText: "Masukkan nomor meja",
                      border: UnderlineInputBorder(),
                      focusColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  )),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  Expanded(
                    child: BlocBuilder<MenuBloc, MenuState>(
                      builder: (context, state) {
                        state.cart.length;
                        final categorizedData = state.cart.toSet().toList();
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: categorizedData.length,
                          itemBuilder: (context, index) {
                            final data = categorizedData[index];
                            final multiData =
                                state.cart.where((element) => element == data);
                            return paddingContent(Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: SizeConfig.blockHorizontal! * 15,
                                    width: SizeConfig.blockHorizontal! * 15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(data.image!),
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
                                  ),
                                  SizedBox(
                                      width: SizeConfig.blockHorizontal! * 2),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data.name,
                                          style: boldFont.copyWith(
                                            fontSize:
                                                SizeConfig.blockHorizontal! * 3,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                SizeConfig.blockVertical! * .5),
                                        Text(
                                          "Rp.${data.price}",
                                          style: regularFont.copyWith(
                                              color: Colors.grey,
                                              fontSize:
                                                  SizeConfig.blockHorizontal! *
                                                      3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.read<MenuBloc>().add(
                                                IncrementItemButtonEvent(
                                                    item: data),
                                              );
                                        },
                                        child: Icon(Icons.add),
                                      ),
                                      Text(multiData.length.toString()),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<MenuBloc>().add(
                                                DecrementItemButtonEvent(
                                                    item: data),
                                              );
                                        },
                                        child: Icon(Icons.remove),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ));
                          },
                        );
                      },
                    ),
                  ),
                  paddingContent(
                    BlocBuilder<MenuBloc, MenuState>(
                        bloc: BlocProvider.of<MenuBloc>(context),
                        builder: (context, state) {
                          final grandTotal = state.cart
                              .fold(0.0, (prev, next) => prev += next.price);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grandtotal: ${moneyFormat.format(grandTotal)}',
                                style: boldFont.copyWith(
                                  fontSize: SizeConfig.blockHorizontal! * 4,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  paddingContent(
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<MenuBloc>()
                              .add(TransactionButtonEvent());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Text(
                          'Proses',
                          style: boldFont.copyWith(
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paddingContent(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: child,
    );
  }

  Widget formHeader(String text) {
    return paddingContent(
      Text(
        text,
        style: boldFont.copyWith(
          fontSize: SizeConfig.blockHorizontal! * 4,
        ),
      ),
    );
  }
}
