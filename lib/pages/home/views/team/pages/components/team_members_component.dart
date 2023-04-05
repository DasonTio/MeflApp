import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/models/MemberModel.dart';
import 'package:mefl_app_bloc/models/TeamModel.dart';
import 'package:mefl_app_bloc/pages/home/views/team/bloc/team_bloc.dart';
import 'package:mefl_app_bloc/services/member_service.dart';

class TeamMembersComponent extends StatefulWidget {
  const TeamMembersComponent({Key? key, required this.teamData})
      : super(key: key);

  final TeamModel teamData;
  @override
  _TeamMembersComponentState createState() => _TeamMembersComponentState();
}

class _TeamMembersComponentState extends State<TeamMembersComponent> {
  MemberService member = MemberService();

  @override
  void initState() {
    super.initState();
    member.load();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<TeamBloc, TeamState>(
      listener: ((context, state) {}),
      child: StreamBuilder(
        stream: member.all,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Container(
              width: double.infinity,
              height: SizeConfig.blockHeight! / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: accentColor.withOpacity(0.1),
              ),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final profile = data[index];
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockHorizontal! * 3,
                        vertical: SizeConfig.blockVertical! * 2,
                      ),
                      child: profile.member.userStatus == UserStatus.pending
                          ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    profile.user.name,
                                    style: mediumFont.copyWith(
                                      fontSize: SizeConfig.blockHorizontal! * 4,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<TeamBloc>().add(
                                        AcceptMemberButtonEvent(
                                            userId: profile.user.id!));
                                  },
                                  child: Icon(
                                    Icons.check_circle,
                                    color: accentColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<TeamBloc>().add(
                                        RejectMemberButtonEvent(
                                            userId: profile.user.id!));
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    profile.user.name,
                                    style: mediumFont.copyWith(
                                      fontSize: SizeConfig.blockHorizontal! * 4,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                                Icon(Icons.person)
                              ],
                            ),
                    );
                  }),
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
            width: double.infinity,
            height: SizeConfig.blockHeight! / 3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
