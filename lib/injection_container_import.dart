import 'package:icare/injection_container.dart' as container;

// Expose the Service Locator for backward compatibility
final sl = container.sl;

// Orchestrate initialization
Future<void> init() async {
  await container.init();
}
