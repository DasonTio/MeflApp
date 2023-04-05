import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/services/transaction_service.dart';

class TeamTransactionPage extends StatefulWidget {
  const TeamTransactionPage({Key? key}) : super(key: key);

  @override
  _TeamTransactionPageState createState() => _TeamTransactionPageState();
}

class _TeamTransactionPageState extends State<TeamTransactionPage> {
  TransactionService _service = TransactionService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _service.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.blockVertical! * 2),
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
                      width: SizeConfig.blockHorizontal! * 24,
                    ),
                    Text(
                      "Transaksi",
                      style: boldFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 6,
                      ),
                    ),
                  ],
                ),
              ),
              paddingContent(StreamBuilder(
                stream: _service.all,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return ListView.builder(                      
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final single = data[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: SizeConfig.blockVertical! * 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockHorizontal! * 3,
                            vertical: SizeConfig.blockVertical! * 2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "#${single.reference.transactionId}",
                                style: regularFont.copyWith(
                                  color: Colors.black45,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: single.models.length,
                                itemBuilder: (context, index) {
                                  final model = single.models[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeConfig.blockVertical!),
                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              SizeConfig.blockHorizontal! * 12,
                                          height:
                                              SizeConfig.blockHorizontal! * 12,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  model.menu.image!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: SizeConfig.blockHorizontal! *
                                                3),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.menu.name,
                                              style: semiBoldFont.copyWith(
                                                fontSize: SizeConfig
                                                        .blockHorizontal! *
                                                    4,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig.blockVertical! *
                                                      0.3,
                                            ),
                                            Text(
                                              moneyFormat
                                                  .format(model.menu.price),
                                              style: regularFont.copyWith(
                                                color: Colors.black45,
                                              ),
                                            )
                                          ],
                                        )),
                                        Text(
                                          "x${model.model.quantity}",
                                          style: regularFont.copyWith(
                                            fontSize:
                                                SizeConfig.blockHorizontal! * 3,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
            ],
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
}
