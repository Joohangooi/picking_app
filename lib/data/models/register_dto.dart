import 'package:flutter/material.dart';

class RegistrationDto {
  String? name;
  String? email;
  String? password;
  String? phoneNum;
  String? address;
  String? company;

  RegistrationDto({
    this.name,
    @required this.email,
    @required this.password,
    this.phoneNum,
    this.address,
    @required this.company,
  }) {}
}
