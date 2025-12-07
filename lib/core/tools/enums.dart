enum StatusOrder {
  newOrder,
  pending,
  processing,
  outForDelivery,
  delivered,
  cancelled,
}

enum RequestType { productsShoppingCart, productNotFount, package, oneProduct }

enum UnitProducts { kg, pcs, l, g }

String? statusOrderToString(status) {
  switch (status) {
    case StatusOrder.newOrder:
      return "New";
    case StatusOrder.pending:
      return "pending";
    case StatusOrder.processing:
      return "processing";
    case StatusOrder.outForDelivery:
      return "outForDelivery";
    case StatusOrder.delivered:
      return "delivered";
    case StatusOrder.cancelled:
      return "cancelled";
  }
  return null;
}

StatusOrder? stringToStatusOrder(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return StatusOrder.newOrder;
    case "pending":
      return StatusOrder.pending;
    case "processing":
      return StatusOrder.processing;
    case "outForDelivery":
      return StatusOrder.outForDelivery;
    case "delivered":
      return StatusOrder.delivered;
    case "cancelled":
      return StatusOrder.cancelled;
  }
  return null;
}
