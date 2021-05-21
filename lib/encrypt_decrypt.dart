import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class EncryptDecrypt {

  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAes(text) {
    final encrypted = encrypter.encrypt(text,iv: iv);
    return encrypted.base16;
  }

  static decryptAes(text) {
    return encrypter.decrypt16(text,iv: iv);
  }


}