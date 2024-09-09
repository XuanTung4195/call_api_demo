
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data_store/data_store.dart';
part 'demo_api_provider.g.dart';

@Riverpod()
class DemoApi extends _$DemoApi {
  DataStore<String> store = DataStore<String>();
  DataPage<String> pageStore = DataPage<String>();

  @override
  DemoState build() {
    store.setStateChangeListener((val) {
      state = state.copyWith(
        api: val,
      );
    });
    pageStore.setStateChangeListener((val) {
      state = state.copyWith(
        pageApi: val,
      );
    });
    return DemoState(
      api: store.state,
      pageApi: pageStore.state
    );
  }

  Future<DataState> testCallApi() async {
    return store.fetch(() async {
      await Future.delayed(const Duration(seconds: 2));
      return "Data Response at ${DateTime.now()}";
    });
  }


  Future<PageState> testCallApiPaging() async {
    return pageStore.fetch(() async {
      await Future.delayed(const Duration(seconds: 2));
      final curr = pageStore.state.data.length;
      return DataResponse(
        data: List.generate(20, (i) {
          return '${curr + i}';
        }).toList(),
      );
    });
  }
}

class DemoState {
  final DataState<String> api;
  final PageState<String> pageApi;

  DemoState({required this.api, required this.pageApi});

  DemoState copyWith({
    DataState<String>? api,
    PageState<String>? pageApi,
  }) {
    return DemoState(
      api: api ?? this.api,
      pageApi: pageApi ?? this.pageApi,
    );
  }
}