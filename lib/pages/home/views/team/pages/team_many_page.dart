import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/pages/home/views/team/bloc/team_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/team/pages/components/team_members_component.dart';
import 'package:mefl_app_bloc/pages/home/views/team/pages/team_transaction_page.dart';
import 'package:mefl_app_bloc/services/member_service.dart';
import 'package:mefl_app_bloc/services/team_service.dart';
import 'package:mefl_app_bloc/services/transaction_service.dart';

class TeamManyPage extends StatefulWidget {
  const TeamManyPage({Key? key}) : super(key: key);

  @override
  _TeamManyPageState createState() => _TeamManyPageState();
}

class _TeamManyPageState extends State<TeamManyPage> {
  TeamService team = TeamService();
  MemberService member = MemberService();
  TransactionService transaction = TransactionService();

  @override
  void initState() {
    super.initState();
    team.load();
    member.load();
    transaction.load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamBloc, TeamState>(
      listener: (context, state) {},
      child: StreamBuilder(
        stream: team.all,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat datang, ",
                            style: regularFont.copyWith(
                              color: blackColor,
                              fontSize: SizeConfig.blockHorizontal! * 6,
                            ),
                          ),
                          Text(
                            "Team ${data.name}",
                            style: boldFont.copyWith(
                              fontSize: SizeConfig.blockHorizontal! * 6,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<TeamBloc>()
                              .add(ChangeToSingleViewButtonEvent());
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: SizeConfig.blockVertical! * 20,
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Pendapatan:".toUpperCase(),
                                style: semiBoldFont.copyWith(
                                  fontSize: SizeConfig.blockHorizontal! * 3.5,
                                  color: whiteColor,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockVertical!,
                              ),
                              StreamBuilder(
                                stream: transaction.all,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final data = snapshot.data!;
                                    final total = data.fold(0.0, (prev, next) {
                                      return prev += next.reference.grandtotal!;
                                    });
                                    return Text(
                                      formatter
                                          .format(total)
                                          .replaceAll('Rp', ''),
                                      style: boldFont.copyWith(
                                        fontSize:
                                            SizeConfig.blockHorizontal! * 8,
                                        color: whiteColor,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error Occured');
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockHorizontal! * 2,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TeamTransactionPage(),));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(0, SizeConfig.blockVertical! * 20),
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockHorizontal! * 6,
                            ),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: blackColor,
                            size: SizeConfig.blockHorizontal! * 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Anggota',
                        style: regularFont.copyWith(
                            fontSize: SizeConfig.blockHorizontal! * 5),
                      ),
                      Row(
                        children: [
                          Text(
                            "#${data.teamCode}",
                            style: mediumFont.copyWith(
                              color: accentColor.withOpacity(0.4),
                              fontSize: SizeConfig.blockHorizontal! * 5,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockHorizontal! * 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: data.teamCode),
                              ).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Team Code has been copied"),
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.copy,
                              color: accentColor.withOpacity(0.4),
                              size: SizeConfig.blockHorizontal! * 5,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  TeamMembersComponent(
                    teamData: data,
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Container(
              width: SizeConfig.blockWidth,
              height: SizeConfig.blockHeight,
              child: Center(
                child: Text("Error Occured"),
              ),
            );
          }
          return Container(
            width: SizeConfig.blockWidth,
            height: SizeConfig.blockHeight,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
