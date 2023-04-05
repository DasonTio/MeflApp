import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/components/button.dart';
import 'package:mefl_app_bloc/components/input_box.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/models/TeamModel.dart';
import 'package:mefl_app_bloc/pages/home/views/team/bloc/team_bloc.dart';
import 'package:mefl_app_bloc/services/user_service.dart';

class TeamSinglePage extends StatefulWidget {
  const TeamSinglePage({Key? key}) : super(key: key);

  @override
  _TeamSinglePageState createState() => _TeamSinglePageState();
}

class _TeamSinglePageState extends State<TeamSinglePage> {
  UserService _userService = UserService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userService.loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<TeamBloc, TeamState>(
      listener: (context, state) {
        if (state.teamStatus == TeamStatus.success) {
          SnackBar snackBar = SnackBar(content: Text("Success"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context
              .read<TeamBloc>()
              .add(ChangeTeamStatusEvent(teamStatus: TeamStatus.loading));
        }
      },
      child: Container(
        width: SizeConfig.blockWidth,
        height: SizeConfig.blockHeight,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.blockWidth! - horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bergabung dengan team',
                    style: boldFont.copyWith(
                      color: blackColor,
                      fontSize: SizeConfig.blockHorizontal! * 5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockVertical! * 2),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    height: SizeConfig.blockVertical! * 8,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockHorizontal! * 2,
                      vertical: 2.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              context
                                  .read<TeamBloc>()
                                  .add(ChangeTeamCodeEvent(teamCode: value));
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan kode team",
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.blockHorizontal!),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TeamBloc>().add(JoinTeamButtonEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            minimumSize: Size(0, SizeConfig.blockVertical! * 6),
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockVertical!,
                              horizontal: SizeConfig.blockHorizontal! * 3,
                            ),
                          ),
                          child: Text(
                            'Masuk',
                            style: mediumFont.copyWith(
                              fontSize: SizeConfig.blockHorizontal! * 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockVertical! * 5),
                  Text(
                    'Buat team',
                    style: boldFont.copyWith(
                      color: blackColor,
                      fontSize: SizeConfig.blockHorizontal! * 5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockVertical! * 2),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeamBloc>().add(CreateTeamButtonEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: EdgeInsets.all(SizeConfig.blockHorizontal! * 3),
                      alignment: Alignment.center,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline_outlined),
                        SizedBox(
                          width: SizeConfig.blockHorizontal!,
                        ),
                        Text(
                          "BUAT TEAM",
                          style: mediumFont.copyWith(
                            color: backgroundColor,
                            fontSize: SizeConfig.blockHorizontal! * 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: _userService.userTeam,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.where((d) => d != null).toList();
                  return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockVertical! * 4),
                      height: SizeConfig.blockHeight! / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tim Saya',
                            style: boldFont.copyWith(
                              color: accentColor,
                              fontSize: SizeConfig.blockHorizontal! * 5,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockVertical! * 2,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final teamProfile = data[index]!;
                                return Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Team ${teamProfile.name}",
                                        style: regularFont.copyWith(
                                          fontSize:
                                              SizeConfig.blockHorizontal! * 4,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<TeamBloc>().add(
                                              ChangeToManyViewButtonEvent(
                                                  teamId:
                                                      teamProfile.teamCode));
                                        },
                                        child: Text(
                                          "Gunakan",
                                          style: regularFont.copyWith(
                                            color: accentColor,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                                width: 2, color: accentColor)),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ));
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
