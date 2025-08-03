#!/bin/bash

set -e

clear
echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                               ║"
echo "║  ██████╗ ██████╗  ██████╗ ███╗   ███╗██████╗ ████████╗                        ║"
echo "║  ██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██╔══██╗╚══██╔══╝                        ║"
echo "║  ██████╔╝██████╔╝██║   ██║██╔████╔██║██████╔╝   ██║                           ║"
echo "║  ██╔═══╝ ██╔══██╗██║   ██║██║╚██╔╝██║██╔═══╝    ██║                           ║"
echo "║  ██║     ██║  ██║╚██████╔╝██║ ╚═╝ ██║██║        ██║                           ║"
echo "║  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝        ╚═╝                           ║"
echo "║                                                                               ║"
echo "║   ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ████████╗ ██████╗ ██████╗ ║"
echo "║  ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗║"
echo "║  ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║   ██║   ██║   ██║██████╔╝║"
echo "║  ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║   ██║   ██║   ██║██╔══██╗║"
echo "║  ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║   ██║   ╚██████╔╝██║  ██║║"
echo "║   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝║"
echo "║                                                                               ║"
echo "║                    🚀 Interactive Project Setup Tool 🚀                       ║"
echo "║                                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo
echo "Welcome to Prompt Generator! 🎯"
echo "This tool will help you create organized project prompts with team configurations."
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
    
    # Check for required spec files
    if [ ! -f "$dir/main_spec.md" ]; then
        echo "Error: main_spec.md is required"
        exit 1
    fi
    
    if [ ! -f "$dir/integration_spec.md" ]; then
        echo "Error: integration_spec.md is required"
        exit 1
    fi
    
    # Check that at least frontend_spec.md OR backend_spec.md exists
    if [ ! -f "$dir/frontend_spec.md" ] && [ ! -f "$dir/backend_spec.md" ]; then
        echo "Error: You must have at least frontend_spec.md or backend_spec.md (or both)"
        exit 1
    fi
    
    return 0
}

# Function to detect frontend technology from frontend_spec.md
detect_frontend_tech() {
    local specs_dir="$1"
    local frontend_file="$specs_dir/frontend_spec.md"
    
    if [ ! -f "$frontend_file" ]; then
        echo ""
        return
    fi
    
    # Check for frontend technologies (case insensitive)
    if grep -qi "react" "$frontend_file"; then
        echo "React"
    elif grep -qi "vue" "$frontend_file"; then
        echo "Vue"
    elif grep -qi "angular" "$frontend_file"; then
        echo "Angular"
    elif grep -qi "svelte" "$frontend_file"; then
        echo "Svelte"
    elif grep -qi "next\.js\|nextjs" "$frontend_file"; then
        echo "Next.js"
    elif grep -qi "nuxt\.js\|nuxtjs" "$frontend_file"; then
        echo "Nuxt.js"
    elif grep -qi "vanilla.*javascript\|plain.*javascript" "$frontend_file"; then
        echo "Vanilla JavaScript"
    else
        echo ""
    fi
}

# Function to detect backend technology from backend_spec.md
detect_backend_tech() {
    local specs_dir="$1"
    local backend_file="$specs_dir/backend_spec.md"
    
    if [ ! -f "$backend_file" ]; then
        echo ""
        return
    fi
    
    # Check for backend technologies (case insensitive)
    if grep -qi "node\.js\|nodejs.*express\|express" "$backend_file"; then
        echo "Node.js/Express"
    elif grep -qi "django" "$backend_file"; then
        echo "Python/Django"
    elif grep -qi "fastapi" "$backend_file"; then
        echo "Python/FastAPI"
    elif grep -qi "spring.*boot\|java.*spring" "$backend_file"; then
        echo "Java/Spring Boot"
    elif grep -qi "\.net\|c#" "$backend_file"; then
        echo "C#/.NET"
    elif grep -qi "\bgo\b\|golang" "$backend_file"; then
        echo "Go"
    elif grep -qi "ruby.*rails\|rails" "$backend_file"; then
        echo "Ruby on Rails"
    elif grep -qi "laravel\|php.*laravel" "$backend_file"; then
        echo "PHP/Laravel"
    else
        echo ""
    fi
}

# Function to check if specs contain frontend/backend
check_specs_content() {
    local specs_dir="$1"
    local has_frontend=false
    local has_backend=false
    
    # Check for specific spec files
    if [ -f "$specs_dir/frontend_spec.md" ]; then
        has_frontend=true
    fi
    
    if [ -f "$specs_dir/backend_spec.md" ]; then
        has_backend=true
    fi
    
    echo "$has_frontend,$has_backend"
}

# Get ROOT_DIRECTORY with validation (loop until valid)
while true; do
    read -p "Enter root directory path: " ROOT_DIRECTORY
    if [ -z "$ROOT_DIRECTORY" ]; then
        echo "Error: Root directory cannot be empty"
        echo "Please try again."
        continue
    fi
    if [ ! -d "$ROOT_DIRECTORY" ]; then
        echo "Error: Directory '$ROOT_DIRECTORY' does not exist"
        echo "Please try again."
        continue
    fi
    if [ ! -r "$ROOT_DIRECTORY" ] || [ ! -x "$ROOT_DIRECTORY" ]; then
        echo "Error: Directory '$ROOT_DIRECTORY' is not accessible"
        echo "Please try again."
        continue
    fi
    
    # Remove trailing slash if present
    ROOT_DIRECTORY=${ROOT_DIRECTORY%/}
    break
done

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
    detected_frontend=$(detect_frontend_tech "$SPECS_DIRECTORY")
    
    if [ -n "$detected_frontend" ]; then
        echo "Auto-detected frontend technology: $detected_frontend"
        read -p "Is this correct? (y/n): " confirm_frontend
        
        if [[ "$confirm_frontend" =~ ^[Yy]$ ]]; then
            frontend_lang="$detected_frontend"
        else
            echo "Please select frontend technology manually:"
            echo "Frontend programming language/framework options:"
            echo "1) React"
            echo "2) Vue"
            echo "3) Angular"
            echo "4) Svelte"
            echo "5) Next.js"
            echo "6) Nuxt.js"
            echo "7) Vanilla JavaScript"
            echo "8) Other"
            
            while true; do
                read -p "Choose frontend type (1-8): " frontend_choice
                case $frontend_choice in
                    1) frontend_lang="React"; break ;;
                    2) frontend_lang="Vue"; break ;;
                    3) frontend_lang="Angular"; break ;;
                    4) frontend_lang="Svelte"; break ;;
                    5) frontend_lang="Next.js"; break ;;
                    6) frontend_lang="Nuxt.js"; break ;;
                    7) frontend_lang="Vanilla JavaScript"; break ;;
                    8) read -p "Enter custom frontend type: " frontend_lang; break ;;
                    *) echo "Please enter a number between 1-8" ;;
                esac
            done
        fi
    else
        echo "Frontend programming language/framework options:"
        echo "1) React"
        echo "2) Vue"
        echo "3) Angular"
        echo "4) Svelte"
        echo "5) Next.js"
        echo "6) Nuxt.js"
        echo "7) Vanilla JavaScript"
        echo "8) Other"
        
        while true; do
            read -p "Choose frontend type (1-8): " frontend_choice
            case $frontend_choice in
                1) frontend_lang="React"; break ;;
                2) frontend_lang="Vue"; break ;;
                3) frontend_lang="Angular"; break ;;
                4) frontend_lang="Svelte"; break ;;
                5) frontend_lang="Next.js"; break ;;
                6) frontend_lang="Nuxt.js"; break ;;
                7) frontend_lang="Vanilla JavaScript"; break ;;
                8) read -p "Enter custom frontend type: " frontend_lang; break ;;
                *) echo "Please enter a number between 1-8" ;;
            esac
        done
    fi
    
    teams+=("- A frontend team (PM, Dev using $frontend_lang, UI Tester) - Location: $ROOT_DIRECTORY/frontend")
fi

# Backend team
if [ "$has_backend" = "true" ]; then
    detected_backend=$(detect_backend_tech "$SPECS_DIRECTORY")
    
    if [ -n "$detected_backend" ]; then
        echo "Auto-detected backend technology: $detected_backend"
        read -p "Is this correct? (y/n): " confirm_backend
        
        if [[ "$confirm_backend" =~ ^[Yy]$ ]]; then
            backend_lang="$detected_backend"
        else
            echo "Please select backend technology manually:"
            echo "Backend programming language/framework options:"
            echo "1) Node.js/Express"
            echo "2) Python/Django"
            echo "3) Python/FastAPI"
            echo "4) Java/Spring Boot"
            echo "5) C#/.NET"
            echo "6) Go"
            echo "7) Ruby on Rails"
            echo "8) PHP/Laravel"
            echo "9) Other"
            
            while true; do
                read -p "Choose backend type (1-9): " backend_choice
                case $backend_choice in
                    1) backend_lang="Node.js/Express"; break ;;
                    2) backend_lang="Python/Django"; break ;;
                    3) backend_lang="Python/FastAPI"; break ;;
                    4) backend_lang="Java/Spring Boot"; break ;;
                    5) backend_lang="C#/.NET"; break ;;
                    6) backend_lang="Go"; break ;;
                    7) backend_lang="Ruby on Rails"; break ;;
                    8) backend_lang="PHP/Laravel"; break ;;
                    9) read -p "Enter custom backend type: " backend_lang; break ;;
                    *) echo "Please enter a number between 1-9" ;;
                esac
            done
        fi
    else
        echo "Backend programming language/framework options:"
        echo "1) Node.js/Express"
        echo "2) Python/Django"
        echo "3) Python/FastAPI"
        echo "4) Java/Spring Boot"
        echo "5) C#/.NET"
        echo "6) Go"
        echo "7) Ruby on Rails"
        echo "8) PHP/Laravel"
        echo "9) Other"
        
        while true; do
            read -p "Choose backend type (1-9): " backend_choice
            case $backend_choice in
                1) backend_lang="Node.js/Express"; break ;;
                2) backend_lang="Python/Django"; break ;;
                3) backend_lang="Python/FastAPI"; break ;;
                4) backend_lang="Java/Spring Boot"; break ;;
                5) backend_lang="C#/.NET"; break ;;
                6) backend_lang="Go"; break ;;
                7) backend_lang="Ruby on Rails"; break ;;
                8) backend_lang="PHP/Laravel"; break ;;
                9) read -p "Enter custom backend type: " backend_lang; break ;;
                *) echo "Please enter a number between 1-9" ;;
            esac
        done
    fi
    
    teams+=("- A backend team (PM, Dev using $backend_lang, API Tester) - Location: $ROOT_DIRECTORY/backend")
fi

# Integration team if both frontend and backend
if [ "$has_frontend" = "true" ] && [ "$has_backend" = "true" ]; then
    teams+=("- An integration team (PM, Dev, Integration Tester) - Location: $ROOT_DIRECTORY/integration")
fi

# Documentation team
read -p "Is documentation team necessary? (y/n): " doc_needed
if [[ "$doc_needed" =~ ^[Yy]$ ]]; then
    teams+=("- A documentation team (PM, Technical Writer) - Location: $ROOT_DIRECTORY/documentation")
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
        team_location=$(echo "$specialty" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
        teams+=("- A $specialty team (PM, Dev, Tester) - Location: $ROOT_DIRECTORY/$team_location")
    else
        # Show available teams (excluding documentation team)
        echo "Available teams for direct contact:"
        team_count=0
        available_teams=()
        
        if [ "$has_frontend" = "true" ]; then
            team_count=$((team_count + 1))
            echo "$team_count) Frontend team"
            available_teams+=("Frontend team")
        fi
        
        if [ "$has_backend" = "true" ]; then
            team_count=$((team_count + 1))
            echo "$team_count) Backend team"
            available_teams+=("Backend team")
        fi
        
        if [ "$has_frontend" = "true" ] && [ "$has_backend" = "true" ]; then
            team_count=$((team_count + 1))
            echo "$team_count) Integration team"
            available_teams+=("Integration team")
        fi
        
        while true; do
            read -p "Choose direct contact team (1-$team_count): " contact_choice
            if [[ "$contact_choice" =~ ^[0-9]+$ ]] && [ "$contact_choice" -ge 1 ] && [ "$contact_choice" -le "$team_count" ]; then
                contact="${available_teams[$((contact_choice - 1))]}"
                break
            else
                echo "Please enter a number between 1-$team_count"
            fi
        done
        
        team_location=$(echo "$specialty" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
        teams+=("- A $specialty team (Subject Matter Expert from $contact) - Location: $ROOT_DIRECTORY/$team_location")
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

# Generate prompt.md
echo
echo "Generating prompt.md..."

cat > "$SPECS_DIRECTORY/prompt.md" << EOF
Root folder are located in $ROOT_DIRECTORY
The specs are located in $SPECS_DIRECTORY

Create:
$TEAMS

Schedule:
- $TIME_PM-minute check-ins with PMs
- $TIME_DEV-minute commits from devs
- $TIME_TESTER-minute commits from tester
- $TIME_ORCHESTRATOR orchestrator status sync

Timeline: [$TIMELINES]
EOF

echo "✓ prompt.md has been generated successfully in $SPECS_DIRECTORY!"