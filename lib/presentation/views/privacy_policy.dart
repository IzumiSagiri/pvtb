import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../common/privacy_policy.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Markdown(
          data: privacyPolicy,
          onTapLink: (text, href, title) => launchUrlString(href!)));
}

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Markdown(
          data: termsAndConditions,
          onTapLink: (text, href, title) => launchUrlString(href!)));
}
