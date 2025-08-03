# Prompt Generator

A bash script that generates project prompt files (`prompt.md`) by interactively collecting project specifications and team configurations.

## What it does

The script creates a structured prompt file by:

1. **Auto-detecting technologies** from specification files
2. **Generating team structures** based on project requirements  
3. **Collecting scheduling information** for project management
4. **Creating organized output** with team locations and timelines

## Features

- **Smart Technology Detection**: Automatically scans `frontend_spec.md` and `backend_spec.md` for technologies (React, Vue, Angular, Node.js, Django, etc.)
- **Flexible Team Creation**: Supports frontend, backend, integration, documentation, and custom specialized teams
- **Validation**: Ensures required specification files exist and directories are accessible
- **Location Mapping**: Assigns team locations under the root directory structure

## Requirements

Your specs directory must contain:
- `main_spec.md` (required)
- `integration_spec.md` (required) 
- At least one of: `frontend_spec.md` OR `backend_spec.md` (or both)

## Usage

1. Make the script executable:
   ```bash
   chmod +x generate_claude.sh
   ```

2. Run the script:
   ```bash
   ./generate_claude.sh
   ```

3. Follow the interactive prompts:
   - Enter root directory path
   - Enter specs directory path
   - Confirm auto-detected technologies (or select manually)
   - Configure teams and schedule
   - Specify project timelines

## Output

Generates `prompt.md` in your specs directory with:
- Root and specs directory locations
- Team configurations with assigned technologies and locations
- Schedule for check-ins and commits
- Project timeline information

## Example Output

```markdown
Root folder are located in /path/to/project
The specs are located in /path/to/specs

Create:
- A frontend team (PM, Dev using React, UI Tester) - Location: /path/to/project/frontend
- A backend team (PM, Dev using Node.js/Express, API Tester) - Location: /path/to/project/backend
- An integration team (PM, Dev, Integration Tester) - Location: /path/to/project/integration

Schedule:
- 15-minute check-ins with PMs
- 30-minute commits from devs
- 20-minute commits from tester
- 10-minute orchestrator status sync

Timeline: [Week 1-2: Planning, Week 3-4: Development]
```