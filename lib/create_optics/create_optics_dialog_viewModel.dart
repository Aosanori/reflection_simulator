import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/view_model_change_notifier.dart';
import '../../simulation/simulation_service.dart';

final createOpticsDialogViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CreateOpticsDialogViewModel(ref.watch(simulationServiceProvider)),
);

class CreateOpticsDialogViewModel extends ViewModelChangeNotifier {
  CreateOpticsDialogViewModel(this._simulationService);
  final SimulationService _simulationService;
}
