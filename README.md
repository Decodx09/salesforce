# salesforce-cicd-demo

Source-tracked Salesforce DX project with a GitHub Actions PR-validation pipeline that spins up a scratch org, deploys metadata, and runs Apex tests on every pull request.

## Local prerequisites

- [Salesforce CLI (`sf`)](https://developer.salesforce.com/tools/salesforce-cli): `npm install -g @salesforce/cli`
- A **Dev Hub**-enabled Salesforce org (any production or Developer Edition org with Dev Hub turned on)
- Node.js 18+

## One-time Dev Hub auth (local)

```bash
sf org login web --set-default-dev-hub --alias devhub
```

## Spin up a scratch org locally

```bash
sf org create scratch -f config/project-scratch-def.json -a demo -d -y 7
sf project deploy start -o demo
sf apex run test -o demo -c -r human -w 20
sf org open -o demo
```

## CI: how the GitHub Actions pipeline works

`.github/workflows/pr-validation.yml` runs on every PR to `main`:

1. Installs the `sf` CLI.
2. Authenticates to your Dev Hub using an SFDX auth URL stored in the `SFDX_AUTH_URL_DEVHUB` repository secret.
3. Creates a 1-day scratch org.
4. Pushes source and runs all local Apex tests with coverage.
5. Tears down the scratch org (even if earlier steps fail).

### Setting the `SFDX_AUTH_URL_DEVHUB` secret

1. Log into your Dev Hub locally: `sf org login web -d -a devhub`.
2. Print the auth URL: `sf org display --target-org devhub --verbose --json | jq -r .result.sfdxAuthUrl`.
3. In GitHub: **Settings → Secrets and variables → Actions → New repository secret**, name `SFDX_AUTH_URL_DEVHUB`, paste the URL.

Keep this secret private — it grants full access to your Dev Hub.

## Layout

```
sfdx-project.json                 SFDX project descriptor
config/project-scratch-def.json   Scratch org shape
force-app/main/default/classes/   Apex sources + tests
.github/workflows/pr-validation.yml
```

## Extending the pipeline

Common next steps once this baseline is green:

- Add a deploy job that runs on push to `main` against a sandbox (auth URL stored as another secret).
- Add PMD static analysis (e.g. `pmd-github-action`).
- Add LWC / Aura linting with ESLint + Prettier.
- Gate merges on a coverage threshold by parsing `sf apex run test --result-format json`.
