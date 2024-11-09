abstract class DataState<T> {
  T? data;
  String? message;

  DataState({this.data, this.message});
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(T? data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  DataFailed(String? message) : super(message: message);
}
