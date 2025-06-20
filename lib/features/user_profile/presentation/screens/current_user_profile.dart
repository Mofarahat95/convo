import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_states.dart';
import 'package:convo/features/user_profile/presentation/bloc/user_profile_cubit.dart';
import 'package:convo/features/user_profile/presentation/bloc/user_profile_states.dart';

class CurrentUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserProfileCubit()),
        BlocProvider.value(value: HomeCubit.get(context)), // ضروري نحتفظ بالـ HomeCubit الحالي
      ],
      child: BlocListener<UserProfileCubit, UserProfileState>(
        listener: (context, state) async {
          if (state is UserProfileLoading) {
            print("Uploading image...");
          } else if (state is UserProfileLoaded) {
            await HomeCubit.get(context).getCurrentUser(); // ✅ يحدث البيانات
          }
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.white),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text('Profile', style: quicksand20()),
          ),
          backgroundColor: Colors.black,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40),
                  _profileImageWithEditButton(),
                  SizedBox(height: 8),
                  _userInfo(),
                  Text('Never give up 💪', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                  SizedBox(height: 24),
                  _userDetails(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImageWithEditButton() {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final currentUser = HomeCubit.get(context).currentUser;
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.purple[100],
              backgroundImage: NetworkImage(currentUser?.profilePic ?? ''),
            ),
            Positioned(
              bottom: -6,
              right: -6,
              child: GestureDetector(
                onTap: () {
                  UserProfileCubit.get(context).pickAndUploadProfileImage(context);
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _userInfo() {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final currentUser = HomeCubit.get(context).currentUser;
        return Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentUser?.name ?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.verified, color: Colors.green, size: 22),
            ],
          ),
        );
      },
    );
  }

  Widget _userDetails() {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final currentUser = HomeCubit.get(context).currentUser;
        if (currentUser == null) return Container();

        String birthDate = DateTime.fromMillisecondsSinceEpoch(currentUser.birthday)
            .toString()
            .substring(0, 10);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              _profileDetail('Birthday', birthDate),
              Divider(thickness: 0.5),
              _profileDetail('Phone Number', currentUser.phone),
              Divider(thickness: 0.5),
              _profileDetail('Email', currentUser.email),
              Divider(thickness: 0.5),
            ],
          ),
        );
      },
    );
  }

  Widget _profileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          Spacer(),
          Text(value, style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
