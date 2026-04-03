import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

class PinDecryptionUtil {
  PinDecryptionUtil._();

  static String decryptLaravelCiphertext({
    required String ciphertextB64,
    required String appKey,
  }) {
    debugPrint(
      '[PIN] decryptLaravelCiphertext: ciphertextLen=${ciphertextB64.length}, appKeyLen=${appKey.length}',
    );
    final keyB64 = appKey.startsWith('base64:') ? appKey.substring(7) : appKey;
    final key = base64.decode(keyB64);
    if (key.length != 32) {
      throw Exception('Invalid APP_KEY: must be 32 bytes (256 bits)');
    }

    final payloadJson = utf8.decode(base64.decode(ciphertextB64));
    final payload = json.decode(payloadJson) as Map<String, dynamic>;
    final ivB64 = payload['iv'] as String;
    final valueB64 = payload['value'] as String;
    final macHex = payload['mac'] as String;

    final macCalc = Hmac(
      sha256,
      key,
    ).convert(utf8.encode(ivB64 + valueB64)).toString();
    if (macCalc != macHex) {
      throw StateError('MAC verification failed');
    }

    final iv = base64.decode(ivB64);
    final value = base64.decode(valueB64);

    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );
    cipher.init(
      false,
      PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
        null,
      ),
    );

    final plainBytes = cipher.process(value);
    final plain = utf8.decode(plainBytes);
    debugPrint('[PIN] decryptLaravelCiphertext: success plainLen=${plain.length}');
    return plain;
  }
}
