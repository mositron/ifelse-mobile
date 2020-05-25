
import 'package:bloc/bloc.dart';
import '../site.dart';

class CartBloc extends Bloc<String, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(String event) async* {
    switch (event) {
      case 'amount':
        yield Site.cartAmount;
        //yield state - 1;
        break;
      default:
        yield Site.cartAmount;
        break;
    }
  }
}