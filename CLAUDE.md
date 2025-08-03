Create bash application that will asked for every variables in below template.
The output will be file CLAUDE.md located in the specs directory.

Following are the data
1. Template: following are the content of the CLAUDE.md
```
The specs are located in $SPECS_DIRECTORY

Create: $TEAMS
Schedule:
- $TIME_PM-minute check-ins with PMs
- $TIME_DEV-minute commits from devs
- $TIME_TESTER-minute commits from tester
- $TIME_ORCHESTRATOR orchestrator status sync

Timeline: [$TIMELINES]
```

2. Variables will be replace inside CLAUDE.md
- SPECS_DIRECTORY : text only. Apps will validate is it empty, location is not valid, or not accessible. If it's have any kind of error, then it will loop and asked same question again. 
- Apps must check for required spec files: 
  -- main_spec.md (always required)
  -- integration_spec.md (always required)
  -- At least one of frontend_spec.md OR backend_spec.md (or both)
  -- If any required file is missing, exit with error.

- Following are the rules for TEAMS
-- General rules: team should have PM, Dev, Tester, Doc
-- Look up for specific spec files in $SPECS_DIRECTORY directory
-- If frontend_spec.md exists, apps will auto-detect frontend technology by scanning the file for keywords (React, Vue, Angular, Svelte, Next.js, Nuxt.js, Vanilla JavaScript). If detected, ask for confirmation. If not detected or not confirmed, provide manual selection options.
-- If backend_spec.md exists, apps will auto-detect backend technology by scanning the file for keywords (Node.js/Express, Python/Django, Python/FastAPI, Java/Spring Boot, C#/.NET, Go, Ruby on Rails, PHP/Laravel). If detected, ask for confirmation. If not detected or not confirmed, provide manual selection options.
-- If both frontend_spec.md and backend_spec.md exist, there will be integration test team
-- Apps will asked documentation team, is it necessary or not
-- Apps will asked either we will have another team again or not. 
--- This will be like loop of array 
--- apps will asked about what speciality in the team
--- does it have developer or not? If yes, will follow general rules for team. If not, it will only act as Subject Matter Expert from available teams (Frontend, Backend, Integration - excluding Documentation team)
-- Example of TEAM variable

```
- A frontend team (PM, Dev using React, UI Tester)
- A backend team (PM, Dev using Node.js/Express, API Tester)
- An integration team (PM, Dev, Integration Tester)
- A documentation team (PM, Technical Writer)
- A [custom specialty] team (Subject Matter Expert from [chosen team])
```

- Variables that have $TIME prefix should be asked one by one