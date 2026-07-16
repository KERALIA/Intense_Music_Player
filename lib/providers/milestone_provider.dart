import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/milestone_service.dart';

final milestoneServiceProvider = Provider<MilestoneService>((ref) {
  return MilestoneService();
});
