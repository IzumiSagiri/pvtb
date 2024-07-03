import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pvtb/domain/usecase/delete_latency.dart';
import 'package:pvtb/domain/usecase/get_latency.dart';
import 'package:pvtb/domain/usecase/set_latency.dart';
import 'package:pvtb/presentation/views/privacy_policy.dart';

class Settings extends StatefulWidget {
  final GetLatency _getLatency;
  final SetLatency _setLatency;
  final DeleteLatency _deleteLatency;
  const Settings(this._getLatency, this._setLatency, this._deleteLatency,
      {super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late int _latency = widget._getLatency().runSync();
  @override
  Widget build(BuildContext context) => Column(children: [
        GridTileBar(
            title: Text(
              'Latency time (ms)',
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
            subtitle: Text('Don\'t change this if you\'re not sure.',
                style: TextStyle(color: Theme.of(context).primaryColor))),
        Slider(
            value: _latency.toDouble(),
            onChanged: ($) => setState(() => _latency = $.round()),
            onChangeEnd: (_) => widget._setLatency(_).runFuture(),
            min: 0,
            max: 100,
            divisions: 101,
            label: _latency.toString()),
        const SizedBox(height: 48),
        OutlinedButton(
            onPressed: () {
              widget._deleteLatency().runFuture();
              setState(() => _latency = 47);
            },
            child: const Text('Reset')),
        const SizedBox(height: 48),
        const Divider(),
        ListTile(
            title: const Text('Onboarding Pages'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => IntroductionScreen(
                        pages: [
                          PageViewModel(
                              title: 'A Whac-A-Mole PVT-B test',
                              body:
                                  'A 3 min PVT test to check your sleepiness.',
                              image:
                                  Center(child: Image.asset('assets/1.png'))),
                          PageViewModel(
                              title: 'Sleep-deprived person gets lower score',
                              body:
                                  'If you\'re sleepy, you can\'t focus and miss more hits.',
                              image:
                                  Center(child: Image.asset('assets/2.png'))),
                          PageViewModel(
                              title:
                                  'Sleep-deprived person has slightly longer reaction time',
                              body:
                                  'If you\'re sleepy, your reaction time is slightly slower.\nYour performance score is probably more useful than your reaction time.',
                              image:
                                  Center(child: Image.asset('assets/3.png'))),
                        ],
                        onDone: () => Navigator.of(context).pop(),
                        next: const Icon(Icons.navigate_next),
                        done: const Text('Done',
                            style: TextStyle(fontWeight: FontWeight.w600)))))),
        ListTile(
            title: const Text('About Whac-A-Mole PVT-B Sleep Test'),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationName: 'Whac-A-Mole PVT-B Sleep Test',
                  applicationVersion: '1.0.0',
                  applicationIcon: const CircleAvatar(
                      backgroundImage: AssetImage('assets/icon.png')),
                  applicationLegalese: 'Copyright © Sagiri HCI Lab, 2022',
                  children: [
                    const Divider(),
                    ListTile(
                        title: const Text('Privacy Policy'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage()));
                        }),
                    ListTile(
                        title: const Text('Terms & Conditions'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage()));
                        })
                  ]);
            })
      ]);
}
