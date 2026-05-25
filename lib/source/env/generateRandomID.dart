import 'dart:math';

int generateRandomNumber() {
  return Random().nextInt(99999);
}

String generateUuidLike() {
  final random = Random();

  const hex = '0123456789abcdef';

  String randomHex(int length) {
    return List.generate(length, (_) {
      return hex[random.nextInt(16)];
    }).join();
  }

  String variant() {
    const variants = ['8', '9', 'a', 'b'];
    return variants[random.nextInt(variants.length)];
  }

  return '${randomHex(8)}-'
      '${randomHex(4)}-'
      '4${randomHex(3)}-'
      '${variant()}${randomHex(3)}-'
      '${randomHex(12)}';
}
