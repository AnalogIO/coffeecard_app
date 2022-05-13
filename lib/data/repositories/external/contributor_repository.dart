import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:coffeecard/utils/either.dart';

class ContributorRepository {
  Future<Either<ApiError, List<Contributor>>> getContributors() async {
    //FIXME: fetch data from API when available
    return Future.value(
      Right([
        Contributor(
          name: 'Frederik Martini',
          githubUrl: 'https://github.com/fremartini',
          avatarUrl: 'https://avatars.githubusercontent.com/u/39860858?v=4',
        ),
        Contributor(
          name: 'Jonas Anker',
          githubUrl: 'https://github.com/jonasanker',
          avatarUrl: 'https://avatars.githubusercontent.com/u/25930103?v=4',
        ),
        Contributor(
          name: 'Omid Marfavi',
          githubUrl: 'https://github.com/marfavi',
          avatarUrl: 'https://avatars.githubusercontent.com/u/21163286?v=4',
        ),
        Contributor(
          name: 'Thomas Andersen',
          githubUrl: 'https://github.com/TTA777',
          avatarUrl: 'https://avatars.githubusercontent.com/u/39203167?v=4',
        ),
      ]),
    );
  }
}
