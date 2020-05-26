
import 'package:bloc/bloc.dart';

class CartBloc extends Bloc<String, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(String event) async* {
    print('mapEventToState - '+event);
    switch (event) {
      case 'amount':
        yield state + 1;
        //yield state - 1;
        break;
      default:
        yield state + 1;
        break;
    }
  }
}