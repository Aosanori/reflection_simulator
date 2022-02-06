import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../common/view_model_change_notifier.dart';
import '../../../simulation/optics_state.dart';
import '../../../simulation/simulation_repository.dart';

import '../../optics.dart';

final createFirstNodeDialogViewModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => CreateFirstNodeDialogViewModel(
    ref.watch(simulationRepositoryProvider),
    ref.watch(opticsStateActionProvider),
  ),
);

class CreateFirstNodeDialogViewModel extends ViewModelChangeNotifier {
  CreateFirstNodeDialogViewModel(
    this._simulationRepository,
    this._opticsStateAction,
  );
  final SimulationRepository _simulationRepository;
  final OpticsStateAction _opticsStateAction;

  late Optics selectedOptics = currentOpticsList[0];

  List<Optics> get currentOpticsList => _simulationRepository.currentOpticsList;
  void addFirstNode() {
    _opticsStateAction.addFirstNode(selectedOptics);
  }

  void changeOptics(Optics? newOptics) {
    selectedOptics = newOptics!;
    notifyListeners();
  }
}
