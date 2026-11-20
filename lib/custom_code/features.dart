/// Which parts of the app a build carries.
///
/// The SIB bank link — linking an account, sending to it — is in every build by default.
/// A build for the BBAN transfer alone is made with `--dart-define=SIB=false`, which takes
/// the link out of the screens and stops the app asking for the linked accounts.
const bool kSibEnabled = bool.fromEnvironment('SIB', defaultValue: true);
