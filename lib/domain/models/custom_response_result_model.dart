/// This class can be used to create instances for results after
/// POST, PUT or any http WRITE method.
class CustomResponseResultModel {
  final int statusCode;
  final String messageForClient;

  CustomResponseResultModel({this.statusCode = 500, this.messageForClient = 'Something went wrong'});
}
