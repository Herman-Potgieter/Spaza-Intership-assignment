import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'simple_calc_state.dart';

class SimpleCalcCubit extends Cubit<SimpleCalcState> {
  SimpleCalcCubit() : super(SimpleCalcCalculated({}, 0));

  List<num> validDenominations = [200, 50, 20, 10, 5, 2, 1, 0.5, 0.2];

  void calculateWithMod(double? cost, double? tender) {
    if (cost == null || tender == null) return;

    if ((tender != validDenominations) && (cost > tender)) return;

    num totalChange = tender - cost;
    Map<String, num> breakdown = {};

    //totalchange = 50-25.50 = 24.50
    //forEach element in validDenominations...
    //(24.50/200).floor() = 0 then (24.50 MOD 200) = 24.50
    //(24.50/50).floor() = 0 then (24.50 MOD 50) = 24.50
    //(24.50/20).floor() = 1 then (24.50 MOD 20) = 4.50
    //(4.50/10).floor() = 0 then (4.50 MOD 10) = 4.50
    //(4.50/5).floor() = 0 then (4.50 MOD 5) = 4.50
    //(4.50/2).floor() = 2 then (4.50 MOD 2) = 0.50
    //(0.50/1).floor() = 0 then (0.50 MOD 1) = 0.50
    //(0.50/0.5).floor() = 1 then (0.50 MOD 0.5) = 0
    //(0/0.2).floor() = 0 then (0 MOD 0.2) = 0

    validDenominations.forEach(
      (element) {
        var number = (totalChange / element).floor();
        totalChange = totalChange % element;
        breakdown['${element}'] = number;
      },
    );

    totalChange = tender - cost;

    emit(SimpleCalcCalculated(breakdown, totalChange));
  }

  void clearAll() {
    emit(SimpleCalcCalculated({}, 0));
  }
}
