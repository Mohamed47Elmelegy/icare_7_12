class OrderResponse {
  String? msg;
  bool? state;
  String? orderID;
  OrderResponse(
      {required this.state, required this.msg, required this.orderID});
}
