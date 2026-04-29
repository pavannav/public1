# Session 40: Caching Dependencies

## Invalidating Cache

### Key Concepts
- Cache invalidation occurs when dependencies change, triggering a new SHA for the cache key (e.g., `node_modules-${{ hashFiles('**/package-lock.json') }}`).
- Changes to `package.json` and `package-lock.json` result in a new SHA, preventing reuse of the existing cache.
- This ensures pipelines always use the latest dependencies after updates.

### Lab Demo: Updating Dependencies and Observing Cache Invalidation

**Steps to Invalidate Cache:**
1. Navigate to your local repository: `cd solar-system`.
2. Install a new dependency (for demo purposes: `nodemon` for auto-redeploying on code changes):
   ```
   npm install nodemon
   ```
   - This updates `package.json` and `package-lock.json`.
   - Changes are committed and pushed to a feature branch.

**Before/after changes:**
```diff
! Local: No nodemon dependency
+ Local: nodemon installed, files modified (package.json, package-lock.json)
! Git Status: Green line for added dependency, "M" for modified package-lock.json
```

3. Trigger a new pipeline by pushing changes to the feature branch.
4. Observe pipeline execution:
   - Unit testing job starts.
   - Cache key becomes invalid due to new SHA from updated `package-lock.json`.
   - Cache extraction fails (new key doesn't match existing cache).
   - npm install downloads dependencies again (takes ~7 seconds).

```diff
- Cache: Not found due to new SHA key
+ Cache: New cache created post-installation
! Artifact Count: Increased from ~5700 to ~6000 due to new dependency
```

> [!IMPORTANT]
> Cache invalidation ensures dependency updates are reflected in CI/CD pipelines, preventing outdated builds.

> [!NOTE]
> Manual cache deletion can also be performed via GitLab UI: Pipelines → Clear Runner Caches (removes all caches for the repository).

> [!WARNING]
> Always commit dependency changes to the appropriate branch (feature vs. main) to avoid direct main branch modifications.
