
import 'package:bloc/bloc.dart';

class InformBloc extends Bloc<String, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(String event) async* {
    switch (event) {
      case 'selected':
        yield state + 1;
        //yield state - 1;
        break;
      default:
        yield state + 1;
        break;
    }
  }
}