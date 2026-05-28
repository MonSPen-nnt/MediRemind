import '../remote/health_profile_remote_data_source.dart';
import '../../models/health_profile.dart';

class HealthProfileRepository {
  HealthProfileRepository({HealthProfileRemoteDataSource? remoteDataSource})
    : _remoteDataSource =
          remoteDataSource ?? HealthProfileRemoteDataSourceImpl();

  final HealthProfileRemoteDataSource _remoteDataSource;

  Future<HealthProfile> getProfile(String id) {
    return _remoteDataSource.fetchHealthProfile(id);
  }

  Future<HealthProfile> saveProfile(HealthProfile profile) {
    return _remoteDataSource.createHealthProfile(profile);
  }
}
