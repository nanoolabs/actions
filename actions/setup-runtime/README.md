# setup-runtime

> Setup Node.js runtime with package manager and cache

## Input

| Name              | Required | Default     | Description                            |
| ----------------- | -------- | ----------- | -------------------------------------- |
| `version`         | No       | auto-detect | node version (or from .tool-versions)  |
| `package-manager` | No       | `pnpm`      | package manager: `pnpm`, `npm`, `yarn` |
| `cache-key`       | No       | ``          | custom cache key suffix                |

## Output

| Name           | Description                        |
| -------------- | ---------------------------------- |
| `node-version` | resolve Node version               |
| `cache-hit`    | whether cache was hit (true/false) |

## Usage

```yaml
- uses: nanoolabs/actions/actions/setup-runtime@v1
  with:
    version: '24'
    package-manager: pnpm
    # cache-key: custom-suffix

- run: pnpm install --frozen-lockfile
```

## Behavior

- Auto detect version from `.tool-versions` (asdf)
- Use `actions/setup-node@v4`
- Enable corepack for pnpm
- Caches `node_modules` and npm cache
- Cache key includes lockfile hash for automatic invalidation

## Renovate

> Btw, detects Node version from `.tool-versions` for automated dependency updates
