# Contribution guidelines

We invite everyone to report issues and create pull requests to the repository.

## Issues

Issues are used to track bugs, feature requests and other tasks related to the
project. When creating an issue, please make sure to follow the issue template 
and provide as much information as possible.

## Development

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)

Opening this project in VSCode will prompt you to install the recommended
extensions:

- [Dart extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [bloc extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc)

## Git branch structure

We follow a [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
inspired setup. The branch structure is as following:

- `develop` **(Main branch)** All new branches must check out from `develop`
  into feature branches, then merged back to `develop`. Feature branches can
  have any name, but should be named after the feature they implement.
- `production` Reflects the current deployment in production. The `production`
  branch is merged with `develop` every time a new version is released to
  `production`.

## Merging with the `develop` branch

**A pull request must be created and approved before merging with `develop`!**

When a feature branch is ready to be merged with `develop`, the following steps
should be taken:

1. Make sure the feature branch is up to date with the `develop` branch. This
   can be done by merging the `develop` branch into the feature branch, or by
   rebasing the feature branch on top of the `develop` branch.

A rebase from `develop` to the feature branch can be done in command line like
this:

```bash
git fetch
# checkout the feature branch
git checkout feature/author/feature-name

# rebase with remote develop branch
git rebase origin/develop

# (resolve any conflicts if necessary)

# Then commit and push to the feature branch
git commit -m "New Purchase button for coffee clip cards"
git push
```

From there, the feature branch can be merged with `develop` using a pull
request. If the pull request closes an issue, the issue should be referenced in
the pull request description using the `Closes #issue-number` syntax.
