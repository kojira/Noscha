import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nostr_core_dart/nostr.dart';

Uint8List _decryptPrivateKeyWithMap(Map map) {
  return decryptPrivateKey(hexToBytes(map['privkey']), map['password']);
}

Future<Uint8List> _encryptPrivateKeyWithMap(Map map) async {
  return encryptPrivateKey(hexToBytes(map['privkey']), map['password']);
}

Future<({Keychain user, String enPrivkey, String password})>
    generatePrivateKey() async {
  Keychain user = Keychain.generate();
  String defaultPassword = generateStrongPassword(16);
  String enPrivkey = bytesToHex(await _encryptPrivateKeyWithMap(
      {'privkey': user.private, 'password': defaultPassword}));
  return (user: user, enPrivkey: enPrivkey, password: defaultPassword);
}

Future<({String password, String enPrivkey, Keychain user})> generateWrapper(
        void _) =>
    generatePrivateKey();

String getEncodedPrivkey(privKey) {
  return Nip19.encodePrivkey(privKey);
}

String getEncodedPubkey(pubKey) {
  return Nip19.encodePubkey(pubKey);
}
