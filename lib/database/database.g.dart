// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WorkoutDao? _workoutDaoInstance;

  WorkoutPlanDao? _workoutPlanDaoInstance;

  Future<sqflite.Database> open(String path,
      List<Migration> migrations, [
        Callback? callback,
      ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Workout` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `date` TEXT NOT NULL, `exercises` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workout_plans` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `exercises` TEXT NOT NULL, `duration` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WorkoutDao get workoutDao {
    return _workoutDaoInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  WorkoutPlanDao get workoutPlanDao {
    return _workoutPlanDaoInstance ??=
        _$WorkoutPlanDao(database, changeListener);
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(this.database,
      this.changeListener,)
      : _queryAdapter = QueryAdapter(database),
        _workoutInsertionAdapter = InsertionAdapter(
            database,
            'Workout',
                (Workout item) =>
            <String, Object?>{
              'id': item.id,
              'name': item.name,
              'date': item.date,
              'exercises': item.exercises
            });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Workout> _workoutInsertionAdapter;

  @override
  Future<List<Workout>> getAllWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM Workout',
        mapper: (Map<String, Object?> row) =>
            Workout(
                id: row['id'] as int?,
                name: row['name'] as String,
                date: row['date'] as String,
                exercises: row['exercises'] as String));
  }

  @override
  Future<void> deleteWorkout(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Workout WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertWorkout(Workout workout) async {
    await _workoutInsertionAdapter.insert(workout, OnConflictStrategy.abort);
  }
}

class _$WorkoutPlanDao extends WorkoutPlanDao {
  _$WorkoutPlanDao(this.database,
      this.changeListener,)
      : _queryAdapter = QueryAdapter(database),
        _workoutPlanInsertionAdapter = InsertionAdapter(
            database,
            'workout_plans',
                (WorkoutPlan item) =>
            <String, Object?>{
              'id': item.id,
              'name': item.name,
              'exercises': item.exercises,
              'duration': item.duration
            });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutPlan> _workoutPlanInsertionAdapter;

  @override
  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    return _queryAdapter.queryList('SELECT * FROM workout_plans',
        mapper: (Map<String, Object?> row) =>
            WorkoutPlan(
                id: row['id'] as int?,
                name: row['name'] as String,
                exercises: row['exercises'] as String,
                duration: row['duration'] as String));
  }

  @override
  Future<void> deleteWorkoutPlan(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM workout_plans WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertWorkoutPlan(WorkoutPlan plan) async {
    await _workoutPlanInsertionAdapter.insert(plan, OnConflictStrategy.abort);
  }
}
