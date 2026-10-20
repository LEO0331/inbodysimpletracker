# GitHub Pages deployment

Updated: **2026-10-20**. The live web app is built from `main` using
`.github/workflows/deploy.yml`. Generated site files are deployed as an Actions
artifact rather than committed to a `gh-pages` branch.

## Workflow

1. A push to `main` or manual **Run workflow** starts the build job.
2. Checkout source and read Pages configuration with `actions/configure-pages@v5`.
3. Run synthetic privacy tests and the tracked-file publication guard.
4. Install Flutter dependencies and build the release Web app with the project
   base path `/inbodysimpletracker/`, without source maps or external Web resources.
5. Remove any remaining source maps and run the guard on `build/web`.
6. Upload **only** `build/web` with `actions/upload-pages-artifact@v3`, retaining
   the artifact for one day. No source repository, local records, runtime logs or
   original videos are included.
7. The dependent deploy job uses `actions/deploy-pages@v4` and the `github-pages`
   environment. Its output supplies the deployed site URL.

Both jobs share a workflow-level concurrency group, with deployments serialized.
The existing group name is retained to serialize any older workflow still running
during migration; its `gh-pages` suffix does not publish or require a branch.

## Repository settings and permissions

In **Settings → Pages → Build and deployment**, the source is **GitHub Actions**.
The `github-pages` environment must allow deployments from `main`; preserve any
required reviewers or other protections. Build permissions are `contents: read`
and `pages: read`. Only the deploy job receives `pages: write` and `id-token: write`
for Pages/OIDC. Repository-content write permission is not required.

The generated `gh-pages` branch can be retired after a successful artifact deployment
and a live-site check. Do not reintroduce a branch-publishing workflow: future
deployments should use the same verified artifact path and Pages environment.
Deleting that generated branch does not delete source history, local records or
videos, and does not purge previously published material from GitHub caches.

## Verify or recover a deployment

- In **Actions → Deploy to GitHub Pages**, check both build and deploy jobs.
- A failed source/asset guard must stop the workflow before artifact upload.
- A failed build cannot start deployment; the last successful deployment remains
  the baseline to investigate rather than bypassing checks.
- Confirm the environment URL loads and asset requests use the repository base path.
- If deployment fails, inspect job logs, Pages source mode, environment restrictions
  and token permissions. Retry the fixed workflow from `main` using **Run workflow**.
- Do not upload private records to reproduce an issue. Do not manually package the
  repository root as an artifact or relax privacy checks to make deployment pass.

The [storage/privacy document](data-storage-privacy.md) describes what stays local
and the separate historical runtime-log finding. Pages artifacts contain a public
web application, not Windows local checkpoint data.

References: [GitHub custom Pages workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages),
[upload-pages-artifact](https://github.com/actions/upload-pages-artifact), and
[deploy-pages](https://github.com/actions/deploy-pages).
