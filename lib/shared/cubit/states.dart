// ignore_for_file: camel_case_types

abstract class TaskatyStates {}

class InitialState extends TaskatyStates {}

class ChangeScreenIndex extends TaskatyStates {}

class ChangeBottomSheetState extends TaskatyStates {}

class CreateDatabaseState extends TaskatyStates {}

class ErrorWhileCreatingDatabaseState extends TaskatyStates {}

class GetFromDatabaseLoadingState extends TaskatyStates {}

class GetFromDatabaseState extends TaskatyStates {}

class ErrorWhileGetingFromDatabaseState extends TaskatyStates {}

class InsertdataIntoDatabase extends TaskatyStates {}

class UpdateDatabaseState extends TaskatyStates {}

class DeleteFromDatabaseState extends TaskatyStates {}
