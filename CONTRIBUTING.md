# Contribution guidelines

We invite everyone to report issues and create pull requests to the repository.

## Git branch structure

We follow a [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) inspired setup. The
branch structure is as following :

- `develop` **(Main branch)** All new branches must check out from `develop` into feature branches,
  then merged back to `develop`.
- `production` Reflects the current deployment in production. The `production` branch is merged
  with `develop` every time a new version is released to `production`.
- `feature/{author}/{feature-name}` New features are developed on feature branches following the *
  feature / author name / feature name branch* structure.

## Merging with the `develop` branch

**A pull request must be created and approved before merging with `develop`!**

We use a **rebase** strategy when merging to `develop`. When a feature has been finished in
development, the feature branch must be rebased with `develop` before creating the pull request in order to avoid
merge commits.

A rebase from `develop` to the feature branch can be done in command line like this:

```bash
git fetch
git checkout feature/author/feature-name # checkout the feature branch
git rebase origin/develop # rebase with remote develop branch
# resolve any conflicts
# add or stage your changes

# Then commit and push to the feature branch
git commit -m "New Purchase button for coffee clip cards"
git push
```

Now go to github and create a pull request from the feature branch to the develop branch.
If the pull request closes an issue, make sure to tag this issue in the description for the pull request.