# Session 41: Invalidate Cache

## Invalidate Cache

### Key Concepts

- Welcome to the second project status meeting.
- Production database has encountered issues (periodically unresponsive and sluggish) since the team began developing GitLab CI/CD pipelines.
- Alice is called to investigate the issue and make refactoring to the pipeline.
- Reviewing the successful pipeline: two jobs - unit testing and code coverage.
- Both jobs are connecting to the production database using variables defined for production DB connection.
- Issue: In real-time scenarios, do not use production database for testing services or code coverage jobs; use dev environment database or mock database instead.
- Solution: GitLab's "services" concept - additional containers running with the job to provide services like databases.

  Services allow:
  - Spinning up a new database container.
  - Populating the database with mock data.
  - Using that database for testing jobs and code coverage jobs.
- Upcoming session: Explore services, understand them, refactor the application, and configure services for both jobs.

> [!WARNING]
> Using production databases for unit testing and code coverage in CI/CD can cause production database issues and performance degradation.

> [!IMPORTANT]
> GitLab services provide additional containers (e.g., databases) that run alongside jobs, enabling isolated testing environments with mock data.

> [!NOTE]
> Services exclude the risk associated with testing directly against production resources.

```diff
- Problem: Pipeline jobs using production database for testing and code coverage
+ Solution: Utilize GitLab services to create mock databases for CI/CD jobs
! Best Practice: Always use mock or dev environments instead of production for non-production tasks
```
