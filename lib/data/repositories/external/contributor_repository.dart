import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:coffeecard/utils/either.dart';

class ContributorRepository {
  Future<Either<RequestFailure, List<Contributor>>> getContributors() async {
    return Future.value(
      const Right([
        Contributor(
          name: 'Andreas Trøstrup',
          githubUrl: 'https://github.com/duckth',
          avatarUrl: 'https://avatars.githubusercontent.com/u/8415722?v=4',
        ),
        Contributor(
          name: 'Frederik Martini',
          githubUrl: 'https://github.com/fremartini',
          avatarUrl: 'https://avatars.githubusercontent.com/u/39860858?v=4',
        ),
        Contributor(
          name: 'Frederik Petersen',
          githubUrl: 'https://github.com/fredpetersen',
          avatarUrl: 'https://avatars.githubusercontent.com/u/43568735?v=4',
        ),
        Contributor(
          name: 'Hjalte Sorgenfrei Mac Dalland',
          githubUrl: 'https://github.com/Hjaltesorgenfrei',
          avatarUrl: 'https://avatars.githubusercontent.com/u/8939023?v=4',
        ),
        Contributor(
          name: 'Jonas Anker Rasmussen',
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
