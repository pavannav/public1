# Session 23: Use Rules at Workflow Level

## Pipeline Schedules

### Key Concepts
Pipeline schedules allow automatic triggering of CI/CD pipelines at regular intervals, providing consistent execution without manual intervention. This complements existing triggers like commit messages, branch changes, or merge requests.

**Key Features:**
- Scheduled execution using cron syntax
- Branch-specific runs
- Custom CI/CD variables for the pipeline environment
- Manual triggering capability
- Pipeline tagging for identification

### Lab Demo: Creating a Pipeline Schedule
Follow these steps to create and test a pipeline schedule:

1. Navigate to your GitLab project
2. Go to **Build → Pipeline schedules**
3. Click **New schedule** to create a new pipeline schedule
4. Configure the following:
   - **Description**: "Manual pipeline trigger" (or any descriptive text)
   - **Interval**: Choose from presets (daily, weekly, monthly) or use custom cron syntax
     - **Example**: To run once every year at midnight on January 1st, use cron syntax `0 0 1 1 *`
     - 💡 Cron format: `minute hour day month weekday`
   - **Timezone**: Select your preferred timezone (e.g., Mumbai for demo purposes)
   - **Target branch**: Select the branch for pipeline execution (e.g., main)
   - **Variables**: Add custom variables accessible by the pipeline
     - Example: Add `DEPLOY` variable with value "manual deployment"
   - **Activated**: Ensure this is checked to enable the schedule
5. Click **Save** to create the pipeline schedule

**Viewing and Triggering Schedules:**
- After creation, you can see multiple pipeline schedules in the list
- The next run time is calculated based on the current date (e.g., 11 months if today is after January)
- For immediate testing, **trigger manually**:
  - Click the play/run button on the schedule
  - This creates a new pipeline with a "scheduled" tag indicating how it was triggered
    > [!NOTE]  
    > Pipeline tags help identify trigger sources:
    > - "scheduled" for scheduled executions
    > - "merge request" for MR-based triggers

**Verifying Pipeline Execution:**
- Check the pipeline status in the Pipelines page
- View individual jobs to confirm successful completion
- Inspect job details to verify custom variables are used
  ```diff
  ! Key Variable Usage: CICD pipeline schedules use custom variables like DEPLOY during runtime
  ```

> [!IMPORTANT]  
> Pipeline schedules enhance automation by ensuring regular pipeline execution, ideal for maintenance tasks, automated testing, or scheduled deployments.

> [!NOTE]  
> Schedules can be edited after creation to modify intervals, variables, or other settings. Always verify cron syntax accuracy to avoid unexpected execution timing.
