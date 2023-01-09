import 'package:bloc/bloc.dart';
import '../convert/util.dart';

class ProductBloc extends Bloc<Map, Map> {
  @override
  Map get initialState => {
        'event': '',
        'amount': 1,
        'style1': -1,
        'style2': -1,
        'stock': 0,
        'stocked': 0,
        'price': 0,
        'unit': '',
        'type': '',
      };

  @override
  Stream<Map> mapEventToState(Map event) async* {
    switch (event['event']) {
      case 'style1':
        state['style1'] = getInt(event['value']);
        yield Map.from(state);
        break;
      case 'style2':
        state['style2'] = getInt(event['value']);
        yield Map.from(state);
        break;
      case 'amount':
        state['amount'] = getInt(event['value']);
        yield Map.from(state);
        break;
      case 'stock':
        state['stock'] = getInt(event['value']);
        yield Map.from(state);
        break;
      case 'update':
        state.addAll(event['value']);
        yield Map.from(state);
        break;
      case 'clear':
        state['amount'] = 1;
        state['style1'] = -1;
        state['style2'] = -1;
        yield Map.from(state);
        break;
      default:
        yield Map.from(state);
        break;
    }
  }
}
