# AI-Native SDLC Factory

An opinionated kit that transforms [Claude Code](https://docs.anthropic.com/en/docs/claude-code) into a complete software development team. Ships with 11 specialized AI agents, 10 orchestrated skills, and 9 SDLC phases with enforced quality gates.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Angular 17+ (standalone components, NgRx, signals) |
| Backend | Spring Boot 3.x (Java 17+, DDD architecture) |
| Database | PostgreSQL (primary), Redis (cache) |
| Messaging | Kafka / RabbitMQ |
| Search | Elasticsearch |
| VCS | GitHub + GitHub Projects |
| Architecture | Domain-Driven Design (DDD) |

## Prerequisites

- **Claude Code CLI** (latest) — `npm install -g @anthropic-ai/claude-code`
- **Node.js 18+** and npm
- **Java 17+** and Maven 3.9+
- **Git 2.x+** configured with your credentials
- **GitHub CLI** (`gh`) — `brew install gh` then `gh auth login`
- **Python 3.x** (for state management scripts)
- **tmux** (recommended) — `brew install tmux` for agent team split-pane view

## Quick Start

```bash
# 1. Clone the kit
git clone https://github.com/YOUR_USERNAME/ai-sdlc-factory.git
cd ai-sdlc-factory

# 2. Scaffold a new project
bash create-project.sh my-awesome-app ~/projects

# 3. Navigate to your project
cd ~/projects/my-awesome-app

# 4. Launch the SDLC Factory
bash scripts/start-sdlc.sh

# 5. Inside Claude Code — initialize your project
/sdlc init my-awesome-app
```

## What's Included

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 11 | Specialized AI agents with Opus/Sonnet/Haiku model assignments |
| Skills | 10 | SDLC phase commands (`/sdlc`, `/ideate`, `/hld`, `/develop`, etc.) |
| Rules | 5 | Coding standards (general, quality gates, Java, Angular, security) |
| Hooks | 2 | Agent team lifecycle hooks (TaskCompleted, TeammateIdle) |
| Scripts | 3 | Gate-check, setup, session launcher |

## SDLC Phases

```
1. IDEATION         /ideate [topic]                    Research Agent (Opus)
       |
2. REQUIREMENTS     /enterprise-prd [project]          Product Agent (Opus)
       |
3. PROJECT SETUP    /github-project-setup [repo]       DevOps Agent (Haiku)
       |
4. DESIGN           /hld + /lld + /ddd-architect       Architect Agent (Opus)
       |
5. DEVELOPMENT      /develop backend + frontend        Backend + Frontend (Sonnet)
       |
6. TESTING          /test-suite all                    QA Agent (Sonnet)
       |
7. SECURITY         /security-review                   Security Agent (Opus)
       |
8. CODE REVIEW      /pr-review create + review         Review + Validator (Opus)
       |
9. RELEASE          /release tag [version]             DevOps Agent (Haiku)
```

Quality gates are enforced between each phase via `/sdlc next`.

## Agent Architecture

```
THINKERS (Opus):    research, product, architect, security, review, validator
BUILDERS (Sonnet):  backend, frontend, qa
EXECUTORS (Haiku):  devops, memory
```

| Agent | Model | Role | Read-Only? |
|-------|-------|------|-----------|
| research-agent | Opus | Market research, interactive discovery | Yes |
| product-agent | Opus | PRD, epics, user stories, roadmap | No |
| architect-agent | Opus | HLD, LLD, DDD, contracts, diagrams | No |
| backend-agent | Sonnet | Spring Boot DDD implementation | No |
| frontend-agent | Sonnet | Angular 17+ feature modules | No |
| qa-agent | Sonnet | JUnit5, Jest, Playwright tests | No |
| security-agent | Opus | OWASP Top 10 audit | Yes |
| devops-agent | Haiku | Git, gh CLI, CI/CD, releases | Yes (code) |
| review-agent | Opus | PR diff analysis, architecture compliance | Yes |
| validator-agent | Opus | DDD governance, drift detection, health score | Yes |
| memory-agent | Haiku | Sprint summaries, context compression | No |

## Project Structure (After Scaffold)

```
my-awesome-app/
├── .claude/
│   ├── agents/              # 11 agent definitions
│   ├── skills/              # 10 SDLC phase skills
│   ├── rules/               # 5 coding standard rules
│   ├── hooks/               # 2 agent team hooks
│   └── settings.local.json  # Tool permissions
├── .sdlc/
│   ├── state.json           # Project state (phase, artifacts, GitHub)
│   └── phases/              # Phase metadata
├── docs/                    # Generated artifacts output
│   ├── ideation/            # Product vision
│   ├── prd/                 # PRD, backlog, roadmap
│   ├── architecture/        # HLD + LLD
│   ├── ddd/                 # Context maps, aggregates
│   ├── tech-specs/          # OpenAPI, schema, configs
│   ├── sprints/             # Sprint plans + summaries
│   ├── security/            # Security review + compliance
│   ├── testing/             # Coverage + test reports
│   └── releases/            # Release notes
├── scripts/
│   ├── sdlc-gate-check.sh  # Quality gate validation
│   ├── setup-agents.sh     # One-time agent config
│   └── start-sdlc.sh       # Session launcher
├── CLAUDE.md                # Master project documentation
├── USAGE-GUIDE.md           # Comprehensive user guide
└── kit.json                 # Kit version metadata
```

## Updating Existing Projects

To update a previously scaffolded project with the latest kit files:

```bash
bash /path/to/ai-sdlc-factory/update-kit.sh /path/to/my-project
```

This updates agents, skills, rules, hooks, and scripts while preserving your project state, generated docs, and source code.

## Detailed Documentation

See [USAGE-GUIDE.md](USAGE-GUIDE.md) for comprehensive documentation including:

- Complete skill reference with arguments and examples
- Multi-agent architecture deep dive
- Agent team walkthrough (phase-by-phase with tmux examples)
- Quality gate definitions and thresholds
- Contract-first development patterns
- Tips and best practices

## License

MIT (or your preferred license)
