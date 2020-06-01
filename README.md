# Coffee card App [in development]

**Contact** AnalogIO at *feedback [at] analogio.dk*

We are rewriting our Coffee card app for Cafe Analog to a new cross platform one in Flutter. 
With the coffee card app, users are able to buy and use clip card in Cafe Analog @ IT University of Copenhagen.

## SDKs

We are building the Flutter app with these SDK versions

| SDK       | Version   |
| --------- | --------- |
| Dart      | 2.8.3     |
| Flutter   | 1.17.2    |

## Contributing

We are invite everyone to report issues and create pull requests to the repository. 

### Git branch structure

We follow a [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) inspired setup. The branch structure is as following :

- `master` **(Main  branch)** The master branch is the main branches. All new branches must check out from here into feature branches and merged back to master. 
- `production` The production branch reflects the current deployment in production. The production branch is merged with the develop branch every time a new version is released to production.
- `feature/{author}/{feature-name}` New features are developed on feature branches following the *feature / author name / feature name branch* structure.

### Merging with the develop branch

**A pull request must be created and approved before merging with develop!**

We use a **rebase** strategy when merging to develop. When a feature has been finished in development, the feature branch must be rebased with master before merging in order to avoid merge commits.

A rebase merge to master can be done in command line like this:

```bash
git fetch
git checkout feature/author/feature-name # checkout the feature branch
git rebase origin/master # rebase with remote develop branch
# resolve any conflicts
git checkout master
git merge feature/author/feature-name
git push
```

Alternatively one can use the rebase function on the pull request.
