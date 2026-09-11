import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    final flutterRoute = FlutterRoute(
      Directory(
        Uri(path: 'web/app').toFilePath(),
      ),
    );

    // Serve the flutter web app at root '/' and under '/app'
    pod.webServer.addRoute(flutterRoute, '/');
    pod.webServer.addRoute(flutterRoute, '/app');

    // Setup the app config route for both root and /app paths.
    pod.webServer.addRoute(
      AppConfigRoute(apiConfig: pod.config.apiServer),
      '/assets/assets/config.json',
    );
    pod.webServer.addRoute(
      AppConfigRoute(apiConfig: pod.config.apiServer),
      '/app/assets/assets/config.json',
    );
  } else {
    // Setup a default page at the web root if flutter app is not built yet.
    pod.webServer.addRoute(RootRoute(), '/');
    pod.webServer.addRoute(RootRoute(), '/index.html');

    // Serve all files in the web/static relative directory under /.
    final root = Directory(Uri(path: 'web/static').toFilePath());
    pod.webServer.addRoute(StaticRoute.directory(root));

    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Start the server.
  await pod.start();
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
