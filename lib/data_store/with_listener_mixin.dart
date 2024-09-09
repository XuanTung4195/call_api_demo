part of 'data_store.dart';

typedef StateChangeCallback<T> = void Function(T state);

mixin WithListenerMixin<T> {
  final Set<StateChangeCallback<T>> _stateChangeListeners = {};

  Set<StateChangeCallback<T>> get stateChangeListeners => _stateChangeListeners;

  void addStateChangeListener(StateChangeCallback<T> listener) {
    _stateChangeListeners.add(listener);
  }

  void setStateChangeListener(StateChangeCallback<T> listener) {
    _stateChangeListeners.clear();
    _stateChangeListeners.add(listener);
  }

  void notifyStateChanged(T state) {
    if (_stateChangeListeners.isNotEmpty) {
      for (var item in _stateChangeListeners) {
        try {
          item.call(state);
        } catch (e, st) {
          if (kDebugMode) {
            print("$e, $st");
          }
        }
      }
    }
  }

}