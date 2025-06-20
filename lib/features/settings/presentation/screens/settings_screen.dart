import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/core/utils/assets_manager.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/features/auth/login/presentation/bloc/login_cubit.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Settings',
            style: quicksand24(),
          ),
          toolbarHeight: 100,
        ),
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          HomeCubit.get(context).currentUser?.profilePic??""), // Use your image here
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          HomeCubit.get(context).currentUser?.name??"" ,
                          style: quicksand18(color: AppColors.primary900),
                        ),
                          Text(
                          'Never give up 💪',
                          style: quicksand14(color: AppColors.primary900),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.qr_code,
                      color: AppColors.primary900,
                      size: 30,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: AppColors.primary200),
                SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SettingsOption(
                        icon: Icons.lock,
                        title: 'Account',
                        subtitle: 'Privacy, security, change number',
                      ),
                      SettingsOption(
                        icon: Icons.chat,
                        title: 'Chat',
                        subtitle: 'Chat history, theme, wallpapers',
                      ),
                      SettingsOption(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Messages, group and others',
                      ),
                      SettingsOption(
                        icon: Icons.storage,
                        title: 'Storage and data',
                        subtitle: 'Network usage, storage usage',
                      ),
                      SettingsOption(
                        icon: Icons.help,
                        title: 'Help',
                        subtitle: 'Help center, contact us, privacy policy',
                      ),
                      SettingsOption(
                        icon: Icons.person_add,
                        title: 'Invite a friend',
                        subtitle: '',
                      ),
                      InkWell(
                        onTap: () {
                          LoginCubit.get(context).Logout();
                          GoRouter.of(context).go(AppRoutes.loginRoute);
                        },
                        child: SettingsOption(
                          icon: Icons.login_outlined,
                          title: 'Logout',
                          subtitle: '',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingsOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary400,
            size: 30,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: quicksand14(color: AppColors.primary700).copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black.withOpacity(0.6),
            size: 16,
          ),
        ],
      ),
    );
  }
}
