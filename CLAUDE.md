Create bash application that will asked for  every variables in below template.
The output will be file CLAUDE.md 

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
- SPECS_DIRECTORY : text only. Apps will validate is it empty or location is not valid

- Following are the rules for TEAMS
-- General rules: team should have PM, Dev, Tester, Doc
-- Look up for specs markdown in $SPEC_DIRECTORY directory
-- If there's frontend, therefore apps will be asked for what kind frontend programming language 
-- If there's backend, therefore apps will be asked for what kind of backend programming language
-- If there's backend and frontend, there will be integration test team
-- Apps will asked documentation team, is it necessary or not
-- Apps will asked either we will have another team again or not. 
--- This will be like loop of array 
--- apps will asked about what speciality in the team
--- does it have developer or not? If yes, will follow general rules for team. If not, it will only act as Subject Matter Expert. You need to asked whose direct contact of this team
-- Example of TEAM variable

```
- A frontend team (PM, Dev, UI Tester)
- A backend team (PM, Dev, API Tester)
- A integration team (PM, Dev, API Tester)
- An Auth team (PM, Dev)
```

- variable that have $TIME prefix should have asked one by one