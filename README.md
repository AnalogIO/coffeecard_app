# Coffee card App [in development]

![Flutter build and test](https://github.com/AnalogIO/coffeecard_app/workflows/Flutter%20build%20and%20test/badge.svg) [![codecov](https://codecov.io/gh/AnalogIO/coffeecard_app/branch/master/graph/badge.svg)](https://codecov.io/gh/AnalogIO/coffeecard_app)

**Contact** AnalogIO at *feedback [at] analogio.dk*

We are rewriting our Coffee card app for Cafe Analog to a new cross platform one in Flutter.
With the coffee card app, users are able to buy and use clip card in Cafe Analog @ IT University of Copenhagen.

## SDKs

We are building the Flutter app with these SDK versions

| SDK       | Version   |
| --------- | --------- |
| Dart      | 2.15.1    |
| Flutter   | 2.8.1     |

## Contributing

We are invite everyone to report issues and create pull requests to the repository.

### Git branch structure

We follow a [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) inspired setup. The branch structure is as following :

- `develop` **(Main  branch)** All new branches must check out from `develop` into feature branches, then merged back to `develop`.
- `production` Reflects the current deployment in production. The `production` branch is merged with `develop` every time a new version is released to `production`.
- `feature/{author}/{feature-name}` New features are developed on feature branches following the *feature / author name / feature name branch* structure.

### Merging with the `develop` branch

**A pull request must be created and approved before merging with `develop`!**

We use a **rebase** strategy when merging to `develop`. When a feature has been finished in development, the feature branch must be rebased with `develop` before merging in order to avoid merge commits.

A rebase merge to `develop` can be done in command line like this:

```bash
git fetch
git checkout feature/author/feature-name # checkout the feature branch
git rebase origin/develop # rebase with remote develop branch
# resolve any conflicts
git checkout develop
git merge feature/author/feature-name
git push
```

Alternatively one can use the rebase function on the pull request.
