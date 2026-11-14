# setup-runtime

> Setup Deno runtime with cache

## Inputs

| Name        | Required | Default     | Description                                  |
| ----------- | -------- | ----------- | -------------------------------------------- |
| `version`   | No       | auto-detect | Deno version (or from .tool-versions/.dvmrc) |
| `cache-key` | No       | ``          | Custom cache key suffix                      |

## Outputs

| Name           | Description                        |
| -------------- | ---------------------------------- |
| `deno-version` | Resolved Deno version              |
| `cache-hit`    | Whether cache was hit (true/false) |

## Usage

```yaml
- uses: nanoolabs/actions/actions/setup-runtime@v1
  with:
    version: "2" # optional, defaults to Deno 2 if no .tool-versions/.dvmrc found
    # cache-key: custom-suffix

- run: deno install
```

## Behavior

- Auto detect version from `.tool-versions` (asdf) or `.dvmrc` (dvm)
  - `.tool-versions`: strips inline comments, handles leading whitespace
  - `.dvmrc`: picks first line starting with digit
  - Falls back to Deno 2 if neither file exists
- Uses `denoland/setup-deno@v2`
- Caches `~/.cache/deno`
- Cache key includes `deno.lock` / `import_map.json` hash for automatic invalidation

## Renovate

Detects Deno version from `.tool-versions` / `.dvmrc` for automated dependency updates

## Security

- No secrets required
- Permissions: `contents: read`

## Windows Support

Works on Windows runners via Git Bash. Deno publish supported.

## References & Impact

| Source              | URL                                    | Impact                  |
| ------------------- | -------------------------------------- | ----------------------- |
| Deno runtime        | https://deno.land/                     | Default Deno 2 fallback |
| denoland/setup-deno | https://github.com/denoland/setup-deno | Action for Deno setup   |
| asdf .tool-versions | https://asdf-vm.com/                   | Version file format     |
| dvm                 | https://github.com/justjavac/dvm       | `.dvmrc` version file   |
