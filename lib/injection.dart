import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'features/EventDashboard/domain/usecases/get_event_attendees_usecase.dart';
import 'features/EventDashboard/domain/usecases/scan_attendance_usecase.dart';
import 'features/EventDashboard/domain/usecases/scan_identity_check_usecase.dart';
import 'features/EventDashboard/domain/usecases/update_attendees_status_usecase.dart';
import 'features/Authentication/domain/usecases/get_authorization.dart';
import 'features/Authentication/domain/usecases/get_user_from_api.dart';
import 'features/User/data/datasources/user_remote_datasource.dart';
import 'features/User/data/repositories/user_repository_implementation.dart';
import 'features/User/domain/repositories/user_repository.dart';
import 'features/User/domain/usecases/edit_profile_usecase.dart';
import 'features/User/presentation/provider/user_provider.dart';
import 'features/ChangePasswordInProfile/data/datasources/change_password_remote_datasource.dart';
import 'features/ChangePasswordInProfile/data/repositories/change_password_in_profile_repository_implementation.dart';
import 'features/ChangePasswordInProfile/domain/repositories/change_password_in_profile_repository.dart';
import 'features/ChangePasswordInProfile/domain/usecases/change_password_usecase.dart';
import 'features/ChangePasswordInProfile/presentation/provider/change_password_provider.dart';
import 'features/EventDashboard/data/datasources/event_dashboard_remote_datasource.dart';
import 'features/EventDashboard/data/repositories/event_dashboard_repository_implementation.dart';
import 'features/EventDashboard/domain/repositories/event_dashboard_repository.dart';
import 'features/EventDashboard/domain/usecases/get_event_by_id_usecase.dart';
import 'features/EventDashboard/presentation/provider/event_dashboard_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/Authentication/data/datasources/remote_datasource.dart';
import 'features/Authentication/data/repositories/authentication_repository_impl.dart';
import 'features/Authentication/domain/repositories/authentication_repository.dart';
import 'features/Authentication/domain/usecases/forgot_password.dart';
import 'features/Authentication/domain/usecases/get_user.dart';
import 'features/Authentication/domain/usecases/logout.dart';
import 'features/Authentication/domain/usecases/recovery_password.dart';
import 'features/Authentication/domain/usecases/refresh_token.dart';
import 'features/Authentication/domain/usecases/sign_in.dart';
import 'features/Authentication/domain/usecases/verify_code.dart';
import 'features/Authentication/presentation/provider/authentication_provider.dart';
import 'features/Home/data/datasources/home_local_datasource.dart';
import 'features/Home/data/datasources/home_remote_datasource.dart';
import 'features/Home/data/datasources/home_remote_datasource_implementation.dart';
import 'features/Home/data/repositories/home_repository_implementation.dart';
import 'features/Home/domain/repositories/home_repository.dart';
import 'features/Home/domain/usecases/home_event_history_usecase.dart';
import 'features/Home/domain/usecases/home_summary_usecase.dart';
import 'features/Home/presentation/provider/home_provider.dart';
import 'features/LandingEvent/data/datasources/landing_event_local_datasource.dart';
import 'features/LandingEvent/data/datasources/landing_event_remote_datasource.dart';
import 'features/LandingEvent/data/datasources/landing_event_remote_datasource_implementation.dart';
import 'features/LandingEvent/data/repositories/landing_event_repository_impl.dart';
import 'features/LandingEvent/domain/repositories/landing_event_repository.dart';
import 'features/LandingEvent/domain/usecases/event_ongoing_usecase.dart';
import 'features/LandingEvent/domain/usecases/event_past_usecase.dart';
import 'features/LandingEvent/domain/usecases/event_upcoming_usecase.dart';
import 'features/LandingEvent/presentation/provider/landing_event_provider.dart';
import 'features/LandingSearchEvents/data/datasources/search_events_local_datasource.dart';
import 'features/LandingSearchEvents/data/datasources/search_events_remote_datasource.dart';
import 'features/LandingSearchEvents/data/repositories/search_events_repository_impl.dart';
import 'features/LandingSearchEvents/domain/repositories/search_events_repository.dart';
import 'features/LandingSearchEvents/domain/usecases/search_events_usecase.dart';
import 'features/LandingSearchEvents/presentation/provider/search_event_provider.dart';

final GetIt myInjection = GetIt.instance;

Future<void> init() async {
  //! External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  myInjection.registerLazySingleton(() => sharedPreferences);
  myInjection.registerLazySingleton(() => http.Client());

  //
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  // GGGAAAPPP
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  //

  //! Data sources
  //? AUTHORIZATION
  myInjection.registerLazySingleton<AuthenticationRemoteDataSource>(
    // * AUTH
    () => AuthenticationRemoteDataSourceImplementation(client: myInjection()),
  );

  //? LANDING HOME
  myInjection.registerLazySingleton<HomeRemoteDatasource>(
    // * LANDING HOME
    () => HomeRemoteDatasourceImplementation(client: myInjection()),
  );
  myInjection.registerLazySingleton<HomeLocalDatasource>(
    // * LANDING HOME
    () =>
        HomeLocalDatasourceImplementation(sharedPreferences: sharedPreferences),
  );

  // ? LANDING EVENT
  myInjection.registerLazySingleton<LandingEventRemoteDataSource>(
    // * LANDING EVENT
    () => LandingEventRemoteDatasourceImplementation(client: myInjection()),
  );

  myInjection.registerLazySingleton<LandingEventLocalDatasource>(
    // * LANDING EVENT
    () => LandingEventLocalDatasourceImplementation(
      sharedPreferences: sharedPreferences,
    ),
  );

  // ? SEARCH EVENT

  myInjection.registerLazySingleton<SearchEventsRemoteDatasource>(
    // * SEARCH EVENT
    () => SearchEventsRemoteDatasourceImplementation(client: myInjection()),
  );

  myInjection.registerLazySingleton<SearchEventsLocalDatasource>(
    // * SEARCH EVENT
    () => SearchEventsLocalDatasourceImplementation(
      client: myInjection(),
      sharedPreferences: sharedPreferences,
    ),
  );

  // ? EVENT DASHBOARD

  myInjection.registerLazySingleton<EventDashboardRemoteDatasource>(
    // * EVENT DASHBOARD
    () => EventDashboardRemoteDatasourceImplementation(client: myInjection()),
  );

  // ? CHANGE PASSWORD

  myInjection.registerLazySingleton<ChangePasswordRemoteDatasource>(
    // * CHANGE PASSWORD
    () => ChangePasswordRemoteDataSourceImplementation(client: myInjection()),
  );

  // ? USER

  myInjection.registerLazySingleton<UserRemoteDatasource>(
    // * CHANGE PASSWORD
    () => UserRemoteDatasourceImplementation(client: myInjection()),
  );

  //
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  // GGGAAAPPP
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  //

  //! Repository
  myInjection.registerLazySingleton<AuthenticationRepository>(
    //* AUTH
    () => AuthenticationRepositoryImpl(
      authenticationRemoteDataSource: myInjection(),
      sharedPreferences: sharedPreferences,
    ),
  );

  myInjection.registerLazySingleton<HomeRepository>(
    // * LANDING HOME
    () => HomeRepositoryImplementation(
      homeRemoteDatasource: myInjection(),
      homeLocalDatasource: myInjection(),
      sharedPreferences: sharedPreferences,
    ),
  );

  // ? SEARCH EVENT

  myInjection.registerLazySingleton<LandingEventRepository>(
    // * SEARCH EVENT
    () => LandingEventRepositoryImplementation(
      sharedPreferences,
      landingEventLocalDatasource: myInjection(),
      landingEventRemoteDataSource: myInjection(),
    ),
  );

  myInjection.registerLazySingleton<SearchEventsRepository>(
    // * SEARCH EVENT
    () => SearchEventsRepositoryImplementation(
      searchEventsLocalDatasource: myInjection(),
      searchEventsRemoteDatasource: myInjection(),
      sharedPreferences: sharedPreferences,
    ),
  );

  // ? EVENT DASHBOARD

  myInjection.registerLazySingleton<EventDashboardRepository>(
    // * EVENT DASHBOARD
    () => EventDashboardRepositoryImplementation(
      sharedPreferences: sharedPreferences,
      eventDashboardRemoteDatasource: myInjection(),
    ),
  );

  // ? CHANGE PASSWORD

  myInjection.registerLazySingleton<ChangePasswordInProfileRepository>(
    // * CHANGE PASSWORD
    () => ChangePasswordInProfileRepositoryImplementation(
      changePasswordRemoteDatasource: myInjection(),
    ),
  );

  // ? USER

  myInjection.registerLazySingleton<UserRepository>(
    // * CHANGE PASSWORD
    () => UserRepositoryImplementation(
      sharedPreferences: sharedPreferences,
      userRemoteDatasource: myInjection(),
    ),
  );

  //
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  // GGGAAAPPP
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  //

  //! Use Cases
  // * AUTH
  myInjection.registerLazySingleton(() => SignIn(myInjection()));
  myInjection.registerLazySingleton(() => ForgotPassword(myInjection()));
  myInjection.registerLazySingleton(() => VerifyCode(myInjection()));
  myInjection.registerLazySingleton(() => GetUser(myInjection()));
  myInjection.registerLazySingleton(() => Logout(myInjection()));
  myInjection.registerLazySingleton(() => RecoveryPassword(myInjection()));
  myInjection.registerLazySingleton(() => RefreshToken(myInjection()));
  myInjection.registerLazySingleton(() => GetUserFromApi(myInjection()));
  myInjection.registerLazySingleton(() => GetAuthorization(myInjection()));

  // * LANDING HOME
  myInjection.registerLazySingleton(() => HomeSummaryUsecase(myInjection()));
  myInjection.registerLazySingleton(
    () => HomeEventHistoryUsecase(myInjection()),
  );

  // * LANDING EVENT
  myInjection.registerLazySingleton(
    () => LandingEventOngoingUsecase(myInjection()),
  );
  myInjection.registerLazySingleton(
    () => LandingEventPastUsecase(myInjection()),
  );
  myInjection.registerLazySingleton(
    () => LandingEventUpcomingUsecase(myInjection()),
  );

  // * SEARCH EVENT
  myInjection.registerLazySingleton(() => SearchEventsUsecase(myInjection()));

  // * EVENT DASHBOARD
  myInjection.registerLazySingleton(() => GetEventByIdUsecase(myInjection()));
  myInjection.registerLazySingleton(() => ScanAttendanceUsecase(myInjection()));
  myInjection.registerLazySingleton(
    () => ScanIdentityCheckUsecase(myInjection()),
  );
  myInjection.registerLazySingleton(
    () => GetEventAttendeesUsecase(myInjection()),
  );
  myInjection.registerLazySingleton(
    () => UpdateAttendeesStatusUsecase(myInjection()),
  );

  // * CHANGE PASSWORD
  myInjection.registerLazySingleton(() => ChangePasswordUsecase(myInjection()));

  // * USER
  myInjection.registerLazySingleton(() => EditProfileUsecase(myInjection()));

  //
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  // GGGAAAPPP
  //
  //-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//-//
  //
  //

  //! Providers

  // ? NOT IMPORTANT

  // * AUTH
  myInjection.registerFactory(
    () => AuthenticationProvider(
      signInUseCase: myInjection(),
      forgotPasswordUseCase: myInjection(),
      verifyCodeUseCase: myInjection(),
      getUserUseCase: myInjection(),
      logoutUseCase: myInjection(),
      recoveryPasswordUseCase: myInjection(),
      refreshTokenUsecase: myInjection(),
      getUserFromApiUsecase: myInjection(),
      getAuthorizationUsecase: myInjection(),
    ),
  );

  // * LANDING HOME
  myInjection.registerFactory(
    () => HomeProvider(
      homeSummaryUsecase: myInjection(),
      homeEventHistoryUsecase: myInjection(),
    ),
  );

  // * LANDING EVENT
  myInjection.registerFactory(
    () => LandingEventProvider(
      landingEventUpcomingUsecase: myInjection(),
      landingEventPastUsecase: myInjection(),
      landingEventOngoingUsecase: myInjection(),
    ),
  );

  // * SEARCH EVENT
  myInjection.registerFactory(
    () => SearchEventsProvider(searchEventUsecase: myInjection()),
  );

  // * EVENT DASHBOARD
  myInjection.registerFactory(
    () => EventDashboardProvider(
      getEventByIdUsecase: myInjection(),
      scanAttendanceUsecase: myInjection(),
      scanIdentityCheckUsecase: myInjection(),
      getEventAttendeesUsecase: myInjection(), updateAttendeesStatusUsecase: myInjection(),
    ),
  );

  // * CHANGE PASSWORD
  myInjection.registerFactory(
    () => ChangePasswordProvider(changePasswordUsecase: 
    myInjection()),
  );

  // * CHANGE PASSWORD
  myInjection.registerFactory(
    () => UserProvider(editProfileUsecase: myInjection()),
  );
}
