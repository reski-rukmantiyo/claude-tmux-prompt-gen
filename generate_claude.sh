#!/bin/bash

set -e

echo "=== CLAUDE.md Generator ==="
echo

# Function to validate specs directory
validate_specs_directory() {
    local dir="$1"
    if [ -z "$dir" ]; then
        echo "Error: Specs directory cannot be empty"
        return 1
    fi
    if [ ! -d "$dir" ]; then
        echo "Error: Directory '$dir' does not exist"
        return 1
    fi
    if [ ! -r "$dir" ] || [ ! -x "$dir" ]; then
        echo "Error: Directory '$dir' is not accessible"
        return 1
    fi
    return 0
}

# Function to check if specs contain frontend/backend
check_specs_content() {
    local specs_dir="$1"
    local has_frontend=false
    local has_backend=false
    
    if find "$specs_dir" -name "*.md" -exec grep -l -i "frontend\|ui\|web\|react\|vue\|angular" {} \; 2>/dev/null | head -1 > /dev/null 2>&1; then
        has_frontend=true
    fi
    
    if find "$specs_dir" -name "*.md" -exec grep -l -i "backend\|api\|server\|database" {} \; 2>/dev/null | head -1 > /dev/null 2>&1; then
        has_backend=true
    fi
    
    echo "$has_frontend,$has_backend"
}

# Get SPECS_DIRECTORY with validation (loop until valid)
while true; do
    read -p "Enter specs directory path: " SPECS_DIRECTORY
    if validate_specs_directory "$SPECS_DIRECTORY"; then
        break
    fi
    echo "Please try again."
done

# Check specs content for frontend/backend
specs_content=$(check_specs_content "$SPECS_DIRECTORY")
has_frontend=$(echo "$specs_content" | cut -d',' -f1)
has_backend=$(echo "$specs_content" | cut -d',' -f2)

echo
echo "Detected in specs:"
[ "$has_frontend" = "true" ] && echo "- Frontend components found"
[ "$has_backend" = "true" ] && echo "- Backend components found"
echo

# Initialize teams array
teams=()

# Frontend team
if [ "$has_frontend" = "true" ]; then
    read -p "What frontend programming language/framework? " frontend_lang
    teams+=("- A frontend team (PM, Dev using $frontend_lang, UI Tester)")
fi

# Backend team
if [ "$has_backend" = "true" ]; then
    read -p "What backend programming language/framework? " backend_lang
    teams+=("- A backend team (PM, Dev using $backend_lang, API Tester)")
fi

# Integration team if both frontend and backend
if [ "$has_frontend" = "true" ] && [ "$has_backend" = "true" ]; then
    teams+=("- An integration team (PM, Dev, Integration Tester)")
fi

# Documentation team
read -p "Is documentation team necessary? (y/n): " doc_needed
if [[ "$doc_needed" =~ ^[Yy]$ ]]; then
    teams+=("- A documentation team (PM, Technical Writer)")
fi

# Additional teams loop
while true; do
    echo
    read -p "Do you want to add another specialized team? (y/n): " add_team
    if [[ ! "$add_team" =~ ^[Yy]$ ]]; then
        break
    fi
    
    read -p "What is the specialty of this team? " specialty
    read -p "Does this team have developers? (y/n): " has_devs
    
    if [[ "$has_devs" =~ ^[Yy]$ ]]; then
        teams+=("- A $specialty team (PM, Dev, Tester)")
    else
        read -p "Who is the direct contact for this SME team? " contact
        teams+=("- A $specialty team (SME: $contact)")
    fi
done

# Convert teams array to string
TEAMS=$(printf '%s\n' "${teams[@]}")

# Get TIME variables
echo
echo "=== Schedule Configuration ==="
read -p "PM check-in duration (minutes): " TIME_PM
read -p "Dev commit duration (minutes): " TIME_DEV
read -p "Tester commit duration (minutes): " TIME_TESTER
read -p "Orchestrator sync duration (minutes): " TIME_ORCHESTRATOR

# Get TIMELINES
echo
read -p "Enter project timelines (e.g., Week 1-2: Planning, Week 3-4: Development): " TIMELINES

# Generate CLAUDE.md
echo
echo "Generating CLAUDE.md..."

cat > CLAUDE.md << EOF
The specs are located in $SPECS_DIRECTORY

Create: $TEAMS
Schedule:
- $TIME_PM-minute check-ins with PMs
- $TIME_DEV-minute commits from devs
- $TIME_TESTER-minute commits from tester
- $TIME_ORCHESTRATOR orchestrator status sync

Timeline: [$TIMELINES]
EOF

echo "✓ CLAUDE.md has been generated successfully!"