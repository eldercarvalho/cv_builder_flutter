import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../shared/extensions/extensions.dart';
import '../../about/about_page.dart';
import '../../account/account_page.dart';
import '../view_models/home_view_model.dart';
import 'main_drawer_item.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 30.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.colors.outline,
                ),
              ),
            ),
            child: SvgPicture.asset(
              'assets/images/horizontal_logo.svg',
              height: 100,
            ),
          ),
          MainDrawerItem(
            text: context.l10n.account,
            icon: FeatherIcons.user,
            onTap: () => AccountPage.push(context),
          ),
          MainDrawerItem(
            text: context.l10n.about,
            icon: FeatherIcons.info,
            onTap: () => AboutPage.push(context),
          ),
          MainDrawerItem(
            text: context.l10n.logout,
            icon: FeatherIcons.logOut,
            onTap: () => homeViewModel.logout(),
          ),
        ],
      ),
    );
  }
}
