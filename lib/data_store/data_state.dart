
part of 'data_store.dart';

class DataState<T> {
  DataState({
    required this.loadState,
    this.data,
    this.error,
  });

  final T? data;
  final LoadState loadState;
  final Object? error;
  bool get isLoading => loadState == LoadState.loading;
  bool get isSuccess => loadState == LoadState.success;

  DataState<T> copyWith({
    T? data,
    LoadState? loadState,
    Object? error,
  }) {
    return DataState<T>(
      data: data ?? this.data,
      loadState: loadState ?? this.loadState,
      error: error,
    );
  }
}

class DataResponse<T> {
  final List<T> data;
  final int? total;
  final bool? isLastPage;
  final dynamic rawResponse;

  DataResponse({required this.data, this.total, this.isLastPage, this.rawResponse});
}

class PageState<T> {
  PageState({
    required this.data,
    required this.initPage,
    required this.isLastPage,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.loadState,
    this.error,
    this.rawResponse,
  });

  final List<T> data;
  final int initPage;
  final bool isLastPage;
  final int total;
  final int page;
  final int pageSize;
  final LoadState loadState;
  final Object? error;
  final dynamic rawResponse;
  bool get isLoading => loadState == LoadState.loading;

  PageState<T> copyWith({
    List<T>? data,
    int? initPage,
    bool? isLastPage,
    int? total,
    int? page,
    int? pageSize,
    LoadState? loadState,
    Object? error,
    dynamic rawResponse,
  }) {
    return PageState<T>(
      data: data ?? this.data,
      initPage: initPage ?? this.initPage,
      isLastPage: isLastPage ?? this.isLastPage,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      loadState: loadState ?? this.loadState,
      error: error,
      rawResponse: rawResponse,
    );
  }

  PageState<T> success({
    List<T>? data,
    int? initPage,
    bool? isLastPage,
    int? total,
    int? page,
    int? pageSize,
    LoadState? loadState,
    Object? error,
    dynamic rawResponse,
  }) {
    return PageState<T>(
      data: data ?? this.data,
      initPage: initPage ?? this.initPage,
      isLastPage: isLastPage ?? this.isLastPage,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      loadState: loadState ?? this.loadState,
      error: error,
      rawResponse: rawResponse,
    );
  }
}
