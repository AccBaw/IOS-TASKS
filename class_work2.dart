
//Task: Safe E-Commerce Order Processor
    //Write function processOrder with named parameters: orderId, itemPrice, promoCode?, deliveryFee?.
    //Apply 10% discount if promoCode == 'SAVE10'.
    //Default deliveryFee to 500.0 ₸ using ?? if null.
    //Print order summary and return final total.

void main() {
  processOrder(
    orderId: 101,
    itemPrice: 5000.0,
    promoCode: "SAVE10",
  );

  print("");

  processOrder(
    orderId: 102,
    itemPrice: 8000.0,
  );
}

double processOrder({
  required int orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  double discount = 0.0;

  if (promoCode == "SAVE10") {
    discount = itemPrice * 0.10;
  }

  double delivery = deliveryFee ?? 500.0;

  double total = itemPrice - discount + delivery;

  print("Order ID: $orderId");
  print("Item price: $itemPrice");
  print("Promo code: $promoCode");
  print("Discount: $discount");
  print("Delivery: $delivery");
  print("Total: $total");

  return total;
}