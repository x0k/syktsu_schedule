import 'dart:io';
import 'dart:convert';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

String jsonFixture(String name) => json.encode(json.decode(fixture(name)));