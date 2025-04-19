import 'package:byewall3/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,

            snap: true,
            floating: true,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppLocalizations.of(context)?.translate('settings') ??
                    "Settings",
              ),
              // background: FlutterLogo(),
            ),
          ),
          // const SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 20,
          //     child: Center(
          //       child: Text('Scroll to see the SliverAppBar in effect.'),
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return Container(
                // color: index.isOdd ? Colors.white : Colors.black12,
                height: 100.0,
                child: Center(
                  child: Text('$index', textScaler: const TextScaler.linear(5)),
                ),
              );
            }, childCount: 20),
          ),
        ],
      ),
    );
  }
}
