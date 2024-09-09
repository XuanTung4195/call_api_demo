import 'dart:async';

import 'package:flutter/foundation.dart';

part 'data_state.dart';
part 'load_state.dart';
part 'with_listener_mixin.dart';

class DataPage<T> with WithListenerMixin<PageState<T>>{
  DataPage({
    int pageSize = 40,
    int initPage = 0,
  }) : _state = PageState<T>(
          data: [],
          initPage: initPage,
          isLastPage: false,
          total: 0,
          page: initPage,
          pageSize: pageSize,
          loadState: LoadState.success,
        );

  late PageState<T> _state;
  PageState<T> get state => _state;
  set state(PageState<T> value) {
    _state = value;
    notifyStateChanged(value);
  }
  final List<Completer<PageState<T>>> _pendingRequest = [];
  int _reqId = 0;

  void reset() {
    state = PageState<T>(
      data: [],
      initPage: state.initPage,
      isLastPage: false,
      total: 0,
      page: state.initPage,
      pageSize: state.pageSize,
      loadState: LoadState.success,
    );
    _resolveRequests(state);
    _reqId++;
  }

  void _resolveRequests(PageState<T> res) {
    for (var item in _pendingRequest) {
      item.complete(res);
    }
    _pendingRequest.clear();
  }

  Future<PageState<T>?> _fetchInternal(Future<DataResponse<T>> Function() loadFunction) async {
    PageState<T> ret;
    int currId = ++_reqId;
    try {
      state = state.copyWith(
          loadState: LoadState.loading,
          error: state.error,
      );
      final DataResponse<T> res = await loadFunction();
      if (currId != _reqId) {
        // The request has been canceled, no further processing will be performed
        return null;
      }
      // process data
      List<T> data = res.data;
      // process last page
      bool lastPage = res.isLastPage ?? data.isEmpty;

      // process total item
      int total = res.total ?? state.total;
      // next page
      int page = state.page + 1;
      final allData = state.data;
      allData.addAll(data);
      ret = state.success(
        loadState: LoadState.success,
        data: allData,
        initPage: state.initPage,
        isLastPage: lastPage,
        total: total,
        page: page,
        pageSize: state.pageSize,
        rawResponse: res.rawResponse,
        error: null
      );
    } catch (e, st) {
      if (currId != _reqId) {
        // The request has been canceled, no further processing will be performed
        return null;
      }
      if (kDebugMode) {
        print("$e, $st");
      }
      ret = state.copyWith(
        loadState: LoadState.error,
        error: e,
        rawResponse: null,
      );
    }
    state = ret;
    _resolveRequests(ret);
    return ret;
  }

  Future<PageState<T>> fetch(Future<DataResponse<T>> Function() loadFunction, {dynamic extra}) {
    final completer = Completer<PageState<T>>();
    _pendingRequest.add(completer);
    if (state.loadState != LoadState.loading) {
      _fetchInternal(loadFunction);
    }
    return completer.future;
  }
}

class DataStore<T> with WithListenerMixin<DataState<T>> {
  DataStore(): _state = DataState<T>(loadState: LoadState.success);

  late DataState<T> _state;
  DataState<T> get state => _state;
  set state(DataState<T> value) {
    _state = value;
    notifyStateChanged(state);
  }
  final List<Completer<DataState<T>>> _pendingRequest = [];
  int _reqId = 0;

  void reset() {
    state = DataState<T>(
      data: null,
      loadState: LoadState.success,
    );
    _resolveRequests(state);
    _reqId++;
  }

  void _resolveRequests(DataState<T> res) {
    for (var item in _pendingRequest) {
      item.complete(res);
    }
    _pendingRequest.clear();
  }

  Future<DataState<T>?> _fetchInternal(Future<T> Function() loadFunction) async {
    DataState<T> ret;
    int currId = ++_reqId;
    try {
      state = state.copyWith(
          loadState: LoadState.loading
      );
      final T res = await loadFunction();
      if (currId != _reqId) {
        // The request has been canceled, no further processing will be performed
        return null;
      }
      // process data
      ret = DataState<T>(
        data: res,
        loadState: LoadState.success,
      );
    } catch (e, st) {
      if (currId != _reqId) {
        // The request has been canceled, no further processing will be performed
        return null;
      }
      if (kDebugMode) {
        print("$e, $st");
      }
      ret = DataState<T>(
        data: null,
        loadState: LoadState.error,
        error: e,
      );
    }
    state = ret;
    _resolveRequests(ret);
    return ret;
  }

  Future<DataState<T>> fetch(Future<T> Function() loadFunction) {
    final completer = Completer<DataState<T>>();
    _pendingRequest.add(completer);
    if (state.loadState != LoadState.loading) {
      _fetchInternal(loadFunction);
    }
    return completer.future;
  }
}