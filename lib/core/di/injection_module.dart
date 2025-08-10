import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cashflow/core/database/database_service.dart';

@module
abstract class InjectionModule {
  @preResolve
  Future<Database> get database => DatabaseService.instance;

  @singleton
  DatabaseService get databaseService => DatabaseService();

}