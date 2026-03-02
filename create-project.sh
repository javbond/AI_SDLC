#!/bin/bash
# create-project.sh — Scaffold a new project from the AI-Native SDLC Factory kit
#
# Usage:
#   bash create-project.sh <project-name> [target-directory]
#
# Examples:
#   bash create-project.sh my-awesome-app
#   bash create-project.sh my-awesome-app ~/projects
#
# What it does:
#   1. Creates a new directory with the project name
#   2. Copies all kit files (agents, skills, rules, hooks, scripts, docs, state)
#   3. Initializes .sdlc/state.json with the project name
#   4. Initializes a git repository
#   5. Runs setup-agents.sh (configures agent teams)
#   6. Creates initial git commit
#   7. Prints next steps

set -e

# --- Parse arguments ---
PROJECT_NAME="${1:-}"
TARGET_DIR="${2:-.}"

if [ -z "$PROJECT_NAME" ]; then
  echo ""
  echo "Usage: bash create-project.sh <project-name> [target-directory]"
  echo ""
  echo "Examples:"
  echo "  bash create-project.sh my-app"
  echo "  bash create-project.sh my-app ~/projects"
  echo ""
  echo "The project will be created at: [target-directory]/[project-name]"
  echo "If target-directory is omitted, the current directory is used."
  exit 1
fi

# Validate project name (alphanumeric, hyphens, underscores — must start with letter)
if ! echo "$PROJECT_NAME" | grep -qE '^[a-zA-Z][a-zA-Z0-9_-]*$'; then
  echo "Error: Project name must start with a letter and contain only letters, numbers, hyphens, and underscores."
  echo "  Valid:   my-awesome-app, lending_platform, FinLend2"
  echo "  Invalid: 123app, my app, @project"
  exit 1
fi

# --- Resolve paths ---
KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)/$PROJECT_NAME" || PROJECT_DIR="$TARGET_DIR/$PROJECT_NAME"

if [ -d "$PROJECT_DIR" ]; then
  echo "Error: Directory already exists: $PROJECT_DIR"
  echo "Choose a different project name or target directory."
  exit 1
fi

# --- Colors ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}┌──────────────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│       AI-NATIVE SDLC FACTORY — Project Scaffold         │${NC}"
echo -e "${BLUE}└──────────────────────────────────────────────────────────┘${NC}"
echo ""

# --- Step 1: Create project directory ---
echo -e "${YELLOW}Step 1/6: Creating project directory...${NC}"
mkdir -p "$PROJECT_DIR"
echo -e "${GREEN}  Created: $PROJECT_DIR${NC}"
echo ""

# --- Step 2: Copy kit files ---
echo -e "${YELLOW}Step 2/6: Copying kit files...${NC}"

# Using rsync for clean copy with exclusions
if command -v rsync &>/dev/null; then
  rsync -a \
    --exclude='.DS_Store' \
    --exclude='.git/' \
    --exclude='examples/' \
    --exclude='create-project.sh' \
    --exclude='update-kit.sh' \
    --exclude='README.md' \
    "$KIT_DIR/" "$PROJECT_DIR/"
else
  # Fallback: cp -r with manual cleanup
  cp -r "$KIT_DIR/" "$PROJECT_DIR/"
  rm -rf "$PROJECT_DIR/.git" "$PROJECT_DIR/examples" "$PROJECT_DIR/create-project.sh" "$PROJECT_DIR/update-kit.sh" "$PROJECT_DIR/README.md"
  find "$PROJECT_DIR" -name '.DS_Store' -delete 2>/dev/null || true
fi

echo -e "${GREEN}  Copied: .claude/ (11 agents, 10 skills, 5 rules, 2 hooks)${NC}"
echo -e "${GREEN}  Copied: .sdlc/ (state template)${NC}"
echo -e "${GREEN}  Copied: docs/ (output directories)${NC}"
echo -e "${GREEN}  Copied: scripts/ (gate-check, setup, launcher)${NC}"
echo -e "${GREEN}  Copied: CLAUDE.md, USAGE-GUIDE.md, .gitignore, kit.json${NC}"
echo ""

# --- Step 3: Initialize state.json with project name ---
echo -e "${YELLOW}Step 3/6: Initializing project state...${NC}"

if command -v python3 &>/dev/null; then
  python3 -c "
import json
from datetime import datetime, timezone

state_path = '$PROJECT_DIR/.sdlc/state.json'
with open(state_path, 'r') as f:
    state = json.load(f)

state['project'] = '$PROJECT_NAME'
state['createdAt'] = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
state['updatedAt'] = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')

with open(state_path, 'w') as f:
    json.dump(state, f, indent=2)
    f.write('\n')
"
  echo -e "${GREEN}  Project name: $PROJECT_NAME${NC}"
  echo -e "${GREEN}  Phase: not_started (run /sdlc init to begin)${NC}"
else
  echo -e "${YELLOW}  Warning: python3 not found. Set project name manually via /sdlc init${NC}"
fi
echo ""

# --- Step 4: Initialize git repository ---
echo -e "${YELLOW}Step 4/6: Initializing git repository...${NC}"
cd "$PROJECT_DIR"

if git init -b main &>/dev/null; then
  echo -e "${GREEN}  Git repo initialized (branch: main)${NC}"
else
  # Fallback for older git versions
  git init &>/dev/null
  git symbolic-ref HEAD refs/heads/main 2>/dev/null || true
  echo -e "${GREEN}  Git repo initialized${NC}"
fi
echo ""

# --- Step 5: Run setup-agents.sh ---
echo -e "${YELLOW}Step 5/6: Configuring agent teams...${NC}"
if [ -f "$PROJECT_DIR/scripts/setup-agents.sh" ]; then
  bash "$PROJECT_DIR/scripts/setup-agents.sh" 2>&1 | sed 's/^/  /'
else
  echo -e "${YELLOW}  Warning: setup-agents.sh not found. Run manually later.${NC}"
fi
echo ""

# --- Step 6: Initial commit ---
echo -e "${YELLOW}Step 6/6: Creating initial commit...${NC}"

KIT_VERSION=$(python3 -c "import json; print(json.load(open('kit.json'))['version'])" 2>/dev/null || echo "1.0.0")

git add -A
git commit -m "$(cat <<EOF
chore: scaffold project from AI-Native SDLC Factory kit v${KIT_VERSION}

Project: ${PROJECT_NAME}
Kit: ai-sdlc-factory v${KIT_VERSION}
Stack: Angular 17+ / Spring Boot 3.x / PostgreSQL / DDD
Agents: 11 | Skills: 10 | Rules: 5 | Phases: 9
EOF
)" &>/dev/null

echo -e "${GREEN}  Initial commit created${NC}"
echo ""

# --- Summary ---
echo -e "${BLUE}┌──────────────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│                   Project Ready!                         │${NC}"
echo -e "${BLUE}├──────────────────────────────────────────────────────────┤${NC}"
echo -e "${BLUE}│                                                          │${NC}"
echo -e "${BLUE}│  Project:  ${GREEN}${PROJECT_NAME}${BLUE}${NC}"
echo -e "${BLUE}│  Location: ${GREEN}${PROJECT_DIR}${BLUE}${NC}"
echo -e "${BLUE}│  Kit:      ${GREEN}v${KIT_VERSION}${BLUE}${NC}"
echo -e "${BLUE}│                                                          │${NC}"
echo -e "${BLUE}│  ${YELLOW}Next Steps:${BLUE}                                             │${NC}"
echo -e "${BLUE}│                                                          │${NC}"
echo -e "${BLUE}│  ${GREEN}1.${NC} cd ${PROJECT_DIR}"
echo -e "${BLUE}│  ${GREEN}2.${NC} bash scripts/start-sdlc.sh"
echo -e "${BLUE}│  ${GREEN}3.${NC} /sdlc init ${PROJECT_NAME}"
echo -e "${BLUE}│                                                          │${NC}"
echo -e "${BLUE}│  ${YELLOW}Or basic mode (no Agent Teams):${BLUE}                         │${NC}"
echo -e "${BLUE}│  ${GREEN}1.${NC} cd ${PROJECT_DIR}"
echo -e "${BLUE}│  ${GREEN}2.${NC} claude"
echo -e "${BLUE}│  ${GREEN}3.${NC} /sdlc init ${PROJECT_NAME}"
echo -e "${BLUE}│                                                          │${NC}"
echo -e "${BLUE}└──────────────────────────────────────────────────────────┘${NC}"
echo ""
