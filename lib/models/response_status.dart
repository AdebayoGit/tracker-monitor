class Status {
  String code;
  Object response;
  Status({required this.code, required this.response});
}


class Success extends Status{

  Success({required Object response}) : super(code: '200', response: response);

  @override
  String toString(){
    return "Completed without an error";
  }
}

class Failure extends Status{

  Failure({required String code, required Object response}) : super(code: code, response: response);

  @override
  String toString(){
    return "Completed with an error";
  }
}