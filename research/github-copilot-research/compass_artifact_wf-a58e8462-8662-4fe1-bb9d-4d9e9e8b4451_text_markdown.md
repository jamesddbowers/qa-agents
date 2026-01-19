# Portable Plugin System Blueprint for AI Coding Copilots

**Claude Code + GitHub Copilot unification through MCP-based abstraction**

A portable plugin system is feasible today using **MCP (Model Context Protocol)** as the common runtime, with **adapter layers** for Claude Code and GitHub Copilot. Both platforms now support MCP, enabling a "write once, run everywhere" approach for tools, while agents, hooks, and commands require platform-specific adapters built on a shared manifest specification.

---

## Executive summary

Building portable plugins across Claude Code and GitHub Copilot is achievable through a three-layer architecture: a **portable plugin spec** defining capabilities in a model-agnostic format, an **MCP server layer** providing cross-platform tool execution, and **platform-specific adapters** that translate the spec into native constructs. MCP serves as the critical bridge—Anthropic created it, and GitHub now recommends it as the replacement for their deprecated Copilot Extensions platform.

The key insight is that **80% portability is realistic today**, with tools/skills achieving near-complete parity through MCP. The remaining 20%—multi-agent orchestration, semantic hooks, and deep IDE integration—requires adapter logic because Copilot lacks native equivalents to Claude Code's agent delegation and event system. The recommended approach uses TypeScript/Node.js for cross-platform compatibility, implements tools as MCP servers, and packages platform-specific adapters as a VS Code extension (Copilot) and native plugin (Claude Code).

**What works well today:** Tool definitions (MCP), slash commands (both platforms), file operations, terminal execution, basic context passing.

**What requires adapters:** Multi-agent coordination (Copilot has no native support), semantic hooks (must map to VS Code events), permission policies (different models), state synchronization across agents.

---

## Claude Code plugin architecture

### Component overview

Claude Code's plugin system consists of six primary components that work together to extend functionality. Understanding each component's role is essential for designing portable equivalents.

```
┌─────────────────────────────────────────────────────────────────┐
│                     CLAUDE CODE PLUGIN                          │
├─────────────────────────────────────────────────────────────────┤
│  .claude-plugin/                                                │
│    └── plugin.json          ← Manifest (name, version, meta)   │
│                                                                 │
│  agents/                                                        │
│    └── *.md                 ← Subagent definitions (YAML+MD)   │
│                                                                 │
│  commands/                                                      │
│    └── *.md                 ← Slash commands (/project:cmd)    │
│                                                                 │
│  skills/                                                        │
│    └── skill-name/                                              │
│        └── SKILL.md         ← Model-invoked capabilities       │
│                                                                 │
│  hooks/                                                         │
│    └── hooks.json           ← Event handlers                   │
│                                                                 │
│  .mcp.json                  ← MCP server configuration         │
└─────────────────────────────────────────────────────────────────┘
```

### Agents: isolated AI specialists

Agents in Claude Code are **isolated specialists** with dedicated context windows, tool permissions, and system prompts. They enable multi-agent workflows where different "experts" handle distinct aspects of a task.

**Agent definition format** (Markdown with YAML frontmatter):
```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and best practices
tools: Read, Glob, Grep
model: sonnet
permissionMode: default
---

You are a code reviewer. Analyze code and provide specific, actionable feedback on quality, security, and best practices. Focus on:
1. Security vulnerabilities
2. Performance issues  
3. Maintainability concerns
```

**Key agent properties:**
- **Isolated context**: Each agent operates in its own context window
- **Tool restrictions**: `tools` allowlist or `disallowedTools` denylist
- **Model selection**: Can specify `sonnet`, `opus`, or `haiku`
- **Permission modes**: `default`, `plan` (read-only), `acceptEdits`, `bypassPermissions`
- **Coordination**: Claude automatically delegates to appropriate agents via the Task tool

### Hooks: event-driven automation

Hooks fire at specific lifecycle events, enabling automated workflows like formatting on save or running tests after edits. They execute shell commands or scripts and can block, modify, or approve operations.

**Available hook events:**

| Event | Trigger | Common Use Cases |
|-------|---------|------------------|
| `PreToolUse` | Before tool execution | Block dangerous operations, validate inputs |
| `PostToolUse` | After tool completes | Auto-format, lint, run tests |
| `PermissionRequest` | Permission dialog shown | Auto-approve trusted patterns |
| `Notification` | Notification sent | Custom alerts |
| `UserPromptSubmit` | User submits prompt | Add context, validate prompts |
| `Stop` | Main agent finishes | Decide if work should continue |
| `SubagentStop` | Subagent finishes | Evaluate subagent completion |
| `SessionStart` | Session begins | Load context, setup environment |
| `SessionEnd` | Session ends | Cleanup, logging |

**Hook configuration example:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "./scripts/format.sh ${file_path}",
        "timeout": 30
      }]
    }]
  }
}
```

**Hook input/output contract:** Hooks receive JSON via stdin with session context (`session_id`, `cwd`, `tool_name`, `tool_input`, `tool_response`) and return exit codes (0=success, 2=blocking error) or JSON with `decision`, `reason`, and optional `updatedInput`.

### Commands: user-invoked workflows

Slash commands are stored prompts and workflows that users invoke explicitly. They support argument interpolation and can enable specific tools for execution.

**Command locations and namespacing:**
- `.claude/commands/` → `/project:command-name`
- `~/.claude/commands/` → `/user:command-name`
- `plugin-root/commands/` → `/plugin-name:command-name`

**Command file format:**
```markdown
---
description: Fix a GitHub issue with tests
argument-hint: [issue-number]
allowed-tools: Read, Grep, Bash(git:*), Bash(gh:*)
---

# Fix Issue #$1

1. Run !`gh issue view $1` to get issue details
2. Search codebase for relevant files
3. Implement fix following project conventions
4. Create tests that verify the fix
5. Run !`npm test` to ensure all tests pass
```

### Skills: model-invoked capabilities

Skills differ from commands in that **Claude autonomously invokes them** based on task context. They use progressive disclosure to efficiently manage context—only loading full instructions when relevant.

**SKILL.md format:**
```markdown
---
name: api-integration
description: Integrate with REST APIs. Use when working with HTTP requests, API clients, or external services.
allowed-tools: Read, Bash
context: fork
---

# API Integration

## Patterns
- Use axios for HTTP requests
- Implement retry logic with exponential backoff
- Store API keys in environment variables

## Error Handling
Always wrap API calls in try-catch and provide meaningful error messages.
```

**Key distinction:** Commands are explicit (`/cmd`), skills are implicit (Claude decides when to use them).

### Capability matrix

| Capability | Claude Code | Notes |
|------------|-------------|-------|
| Multiple agents | ✅ Full support | Isolated contexts, automatic delegation |
| Agent coordination | ✅ Task tool | Claude orchestrates via Task tool invocation |
| Event hooks | ✅ 10 hook types | Pre/Post tool use, session lifecycle |
| Slash commands | ✅ Namespaced | User/project/plugin scopes |
| Model-invoked skills | ✅ Progressive disclosure | Auto-loaded based on task context |
| Tool permissions | ✅ Allow/deny lists | Pattern matching (globs, regex) |
| MCP integration | ✅ Native | .mcp.json configuration |
| Secret handling | ✅ Deny patterns | Block access to .env, secrets/* |
| Script execution | ✅ Bash tool | Full shell access, user permissions |
| State persistence | ✅ CLAUDE.md | Project memory, transcript history |

---

## GitHub Copilot ecosystem capabilities

### Integration architecture

GitHub Copilot's extensibility spans three layers: **client-side** (VS Code extensions), **platform-level** (MCP servers), and **cloud-based** (GitHub Actions for coding agent). Understanding these layers is critical for mapping Claude Code concepts.

```
┌─────────────────────────────────────────────────────────────────┐
│                    COPILOT EXTENSIBILITY                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  CLIENT LAYER (VS Code)                                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Chat Participants│  │ Language Model  │  │   VS Code       │ │
│  │ (@mentions)      │  │ Tools API       │  │   Extension API │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
│                                                                 │
│  PLATFORM LAYER                                                 │
│  ┌─────────────────┐  ┌─────────────────┐                      │
│  │  MCP Servers    │  │  Copilot API    │                      │
│  │  (stdio/HTTP)   │  │  (LLM access)   │                      │
│  └─────────────────┘  └─────────────────┘                      │
│                                                                 │
│  CLOUD LAYER                                                    │
│  ┌─────────────────┐                                           │
│  │ GitHub Actions  │  (Copilot Coding Agent environment)       │
│  └─────────────────┘                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Chat participants: domain experts

Chat participants are the closest equivalent to Claude Code's concept of specialized agents. Users invoke them with `@participant-name` syntax. Built-in participants include `@workspace`, `@terminal`, `@vscode`, and `@github`.

**Registration and handler pattern:**
```typescript
// package.json contribution
"contributes": {
  "chatParticipants": [{
    "id": "myext.reviewer",
    "name": "reviewer", 
    "description": "Code review assistant",
    "commands": [
      { "name": "security", "description": "Security-focused review" },
      { "name": "perf", "description": "Performance-focused review" }
    ]
  }]
}

// Handler implementation
const handler: vscode.ChatRequestHandler = async (request, context, stream, token) => {
  stream.progress('Analyzing code...');
  
  const [model] = await vscode.lm.selectChatModels({ vendor: 'copilot', family: 'gpt-4o' });
  const messages = [vscode.LanguageModelChatMessage.User(request.prompt)];
  
  const response = await model.sendRequest(messages, {}, token);
  for await (const chunk of response.text) {
    stream.markdown(chunk);
  }
  
  return { metadata: { command: request.command } };
};
```

**Critical limitation:** Chat participants only work in **Ask mode**, not Agent mode. This means they cannot be invoked during autonomous multi-step operations—a significant gap compared to Claude Code's agent delegation.

### Language Model Tools API: function calling

The Tools API allows extensions to register functions that Copilot can invoke during chat. This maps directly to Claude Code's skills/tools concept.

**Tool definition:**
```json
"contributes": {
  "languageModelTools": [{
    "name": "myext_analyze_deps",
    "displayName": "Analyze Dependencies",
    "modelDescription": "Analyzes project dependencies for security vulnerabilities and outdated packages",
    "inputSchema": {
      "type": "object",
      "properties": {
        "path": { "type": "string", "description": "Path to package.json" },
        "checkSecurity": { "type": "boolean", "description": "Run security audit" }
      },
      "required": ["path"]
    }
  }]
}
```

**Tool implementation with confirmation:**
```typescript
class AnalyzeDependenciesTool implements vscode.LanguageModelTool<IParams> {
  async prepareInvocation(options, token) {
    return {
      invocationMessage: 'Analyzing dependencies...',
      confirmationMessages: {
        title: 'Analyze Dependencies',
        message: new vscode.MarkdownString(`Analyze \`${options.input.path}\`?`)
      }
    };
  }
  
  async invoke(options, token): Promise<vscode.LanguageModelToolResult> {
    const results = await analyzeDeps(options.input.path, options.input.checkSecurity);
    return new vscode.LanguageModelToolResult([
      new vscode.LanguageModelTextPart(JSON.stringify(results))
    ]);
  }
}
```

### MCP servers: the portability bridge

MCP is the **critical unification point**. Both Claude Code and Copilot support MCP servers, enabling truly portable tool definitions. MCP uses JSON-RPC 2.0 over stdio or HTTP.

**VS Code MCP configuration** (`.vscode/mcp.json`):
```json
{
  "inputs": [
    { "type": "promptString", "id": "api-key", "description": "API Key", "password": true }
  ],
  "servers": {
    "my-tools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@myorg/mcp-server"],
      "env": { "API_KEY": "${input:api-key}" }
    }
  }
}
```

**MCP tool definition (server-side):**
```typescript
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [{
    name: 'analyze_code',
    description: 'Analyzes code for issues and improvements',
    inputSchema: {
      type: 'object',
      properties: {
        filePath: { type: 'string', description: 'File to analyze' },
        checks: { type: 'array', items: { type: 'string' } }
      },
      required: ['filePath']
    }
  }]
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === 'analyze_code') {
    const result = await analyzeCode(request.params.arguments);
    return { content: [{ type: 'text', text: JSON.stringify(result) }] };
  }
});
```

### Agent mode limitations

Copilot's Agent Mode provides autonomous coding but has **no native multi-agent support**. A single agent handles all tasks with access to configured tools. This is fundamentally different from Claude Code's agent delegation model.

**Key Agent Mode characteristics:**
- Single autonomous agent (no delegation)
- Tool invocation via Language Model Tools + MCP
- Cannot invoke Chat Participants
- Background Agents (preview) lack MCP/extension tool access
- GitHub Copilot Extensions (GitHub Apps) work only in Ask mode

### Copilot capability matrix

| Capability | Copilot VS Code | Copilot (Platform) | Notes |
|------------|-----------------|-------------------|-------|
| Multiple agents | ❌ No | ❌ No | Single agent model only |
| Agent coordination | ❌ No | ❌ No | Must emulate via orchestrator |
| Event hooks | ⚠️ Via VS Code API | ❌ No | No semantic hooks, only VS Code events |
| Slash commands | ✅ Chat commands | ✅ Skillsets | Within chat participants |
| Model-invoked tools | ✅ Tools API | ✅ MCP | Full support |
| Tool permissions | ✅ Confirmation prompts | ✅ MCP trust | User approval model |
| MCP integration | ✅ Native | ✅ Native | Primary extensibility path |
| Secret handling | ✅ VS Code Secrets API | ⚠️ Limited | OAuth, PAT support |
| Script execution | ✅ Terminal API | ✅ Actions | Via terminal or GitHub Actions |
| State persistence | ✅ VS Code State API | ⚠️ Limited | globalState, workspaceState |

---

## Capability matrix: side-by-side comparison

| Feature | Claude Code | Copilot VS Code | Portable Spec | Mapping Strategy |
|---------|-------------|-----------------|---------------|------------------|
| **Multiple Agents** | ✅ Native (Task tool) | ❌ None | ✅ Defined | Copilot: Orchestrator agent emulates |
| **Agent Isolation** | ✅ Separate contexts | ❌ N/A | ✅ Defined | Copilot: Session/state isolation in adapter |
| **Agent Tool Restrictions** | ✅ Per-agent allow/deny | ❌ Global | ✅ Defined | Copilot: Adapter filters tool calls |
| **Semantic Hooks** | ✅ Pre/PostToolUse, Stop | ❌ None | ✅ Defined | Copilot: VS Code events + custom dispatcher |
| **File Save Hook** | ✅ PostToolUse(Write) | ⚠️ onDidSaveTextDocument | ✅ Defined | Near parity via VS Code API |
| **Permission Hooks** | ✅ PermissionRequest | ⚠️ Tool confirmation | ⚠️ Partial | Different models, partial mapping |
| **Session Lifecycle** | ✅ SessionStart/End | ⚠️ Extension activate/deactivate | ⚠️ Partial | Approximate via extension lifecycle |
| **Slash Commands** | ✅ /scope:command | ✅ /command via participant | ✅ Full | Near-complete parity |
| **Model-Invoked Skills** | ✅ SKILL.md | ✅ Language Model Tools | ✅ Full | MCP unifies |
| **Tool Schemas** | ✅ MCP format | ✅ MCP format | ✅ Full | Identical via MCP |
| **Script Execution** | ✅ Bash tool | ✅ Terminal + Tasks | ✅ Full | Cross-platform parity |
| **File Operations** | ✅ Read/Write/Edit | ✅ workspace.fs | ✅ Full | Cross-platform parity |
| **Project Context** | ✅ CLAUDE.md | ✅ .github/copilot-instructions.md | ✅ Full | Both support context files |
| **MCP Servers** | ✅ .mcp.json | ✅ .vscode/mcp.json | ✅ Full | Primary portability mechanism |
| **Secrets** | ✅ Deny patterns | ✅ Secrets API | ✅ Full | Different approaches, both secure |
| **Enterprise Policies** | ✅ Managed settings | ✅ GitHub org policies | ✅ Full | Platform-specific enforcement |

---

## Portable plugin specification

### Design principles

The portable spec follows these principles:
1. **MCP-first tools**: All tool definitions use MCP schema, native to both platforms
2. **Declarative over imperative**: Manifest describes capabilities; adapters handle execution
3. **Graceful degradation**: Plugins work with reduced functionality where features are unavailable
4. **Security by default**: Explicit permissions required for sensitive operations

### Manifest schema (portable-plugin.yaml)

```yaml
# portable-plugin.yaml - Portable Plugin Specification v1.0
apiVersion: portable-plugin/v1
kind: Plugin

metadata:
  name: code-quality-suite
  version: 1.2.0
  description: Comprehensive code quality tools with multi-agent review
  author:
    name: Example Team
    email: team@example.com
  license: MIT
  homepage: https://github.com/example/code-quality-suite
  keywords: [code-quality, review, testing, linting]

# Runtime requirements
requirements:
  runtime: node  # node | python | any
  minVersion: "18.0.0"
  platforms: [linux, darwin, win32]
  
# Agent definitions (Claude Code: native, Copilot: orchestrator emulation)
agents:
  - name: planner
    description: Analyzes tasks and creates execution plans
    systemPrompt: |
      You are a planning specialist. When given a task:
      1. Break it into discrete, actionable steps
      2. Identify which specialist agent should handle each step
      3. Define success criteria for each step
    tools: [read_file, list_files, search_code]
    model: default  # sonnet | opus | haiku | default
    permissions:
      allowedOperations: [read]
      
  - name: implementer
    description: Implements code changes following plans
    systemPrompt: |
      You are an implementation specialist. Follow plans precisely.
      Write clean, tested code. Ask for clarification if needed.
    tools: [read_file, write_file, edit_file, run_command]
    model: default
    permissions:
      allowedOperations: [read, write]
      filePatterns: ["src/**", "tests/**"]
      
  - name: reviewer
    description: Reviews code for quality and security
    systemPrompt: |
      You are a code reviewer. Check for:
      - Security vulnerabilities
      - Performance issues
      - Code style violations
      - Test coverage gaps
    tools: [read_file, list_files, search_code, run_tests]
    model: default
    permissions:
      allowedOperations: [read]

# Coordination workflow (defines how agents collaborate)
workflows:
  - name: review-and-fix
    description: Multi-agent code review and fix workflow
    steps:
      - agent: planner
        action: analyze
        input: "${userRequest}"
        output: plan
        
      - agent: reviewer
        action: review
        input: "${plan.files}"
        output: reviewResults
        
      - agent: implementer
        action: implement
        input: "${reviewResults.recommendations}"
        condition: "${reviewResults.hasIssues}"
        output: changes
        
      - agent: reviewer
        action: verify
        input: "${changes}"
        output: verification

# Tool/Skill definitions (MCP-compatible schema)
tools:
  - name: analyze_complexity
    description: Analyzes code complexity metrics (cyclomatic, cognitive, LOC)
    category: analysis
    inputSchema:
      type: object
      properties:
        filePath:
          type: string
          description: Path to file or directory to analyze
        metrics:
          type: array
          items:
            type: string
            enum: [cyclomatic, cognitive, loc, maintainability]
          description: Metrics to calculate
        threshold:
          type: object
          properties:
            cyclomatic: { type: number, default: 10 }
            cognitive: { type: number, default: 15 }
      required: [filePath]
    outputSchema:
      type: object
      properties:
        results: { type: array }
        summary: { type: object }
    implementation:
      type: script
      entrypoint: tools/analyze-complexity.ts
      
  - name: run_tests
    description: Executes test suite and returns results
    category: testing
    inputSchema:
      type: object
      properties:
        testPattern:
          type: string
          description: Glob pattern for test files
        coverage:
          type: boolean
          default: true
    implementation:
      type: command
      command: npm test -- --coverage=${coverage} ${testPattern}
      parseOutput: json

# Slash commands
commands:
  - name: review
    description: Start a code review session
    argumentHint: "[files or directory]"
    workflow: review-and-fix
    
  - name: complexity
    description: Analyze code complexity
    argumentHint: "[path] [--threshold=N]"
    tool: analyze_complexity
    
  - name: fix-issue
    description: Fix a GitHub issue
    argumentHint: "<issue-number>"
    template: |
      Analyze and fix GitHub issue #${args[0]}.
      1. Fetch issue details
      2. Understand the problem
      3. Implement a fix
      4. Write tests
      5. Verify the fix

# Hook definitions
hooks:
  - event: postFileWrite
    description: Run linter after file edits
    matcher:
      filePatterns: ["**/*.ts", "**/*.js"]
    action:
      type: command
      command: npx eslint --fix ${filePath}
      timeout: 30
      
  - event: postFileWrite  
    description: Run formatter after edits
    matcher:
      filePatterns: ["**/*.ts", "**/*.tsx", "**/*.js"]
    action:
      type: command
      command: npx prettier --write ${filePath}
      
  - event: preToolUse
    description: Block writes to protected files
    matcher:
      tools: [write_file, edit_file]
      filePatterns: ["*.lock", ".env*", "secrets/**"]
    action:
      type: block
      message: "Cannot modify protected file: ${filePath}"

# Policies and permissions
policies:
  permissions:
    fileAccess:
      allow: ["src/**", "tests/**", "docs/**", "*.md", "*.json"]
      deny: [".env*", "secrets/**", "*.pem", "*.key"]
    networkAccess:
      allow: ["api.github.com", "registry.npmjs.org"]
      deny: ["*"]  # Deny all except allowed
    commandExecution:
      allow: ["npm test*", "npm run lint*", "git status", "git diff*"]
      deny: ["rm -rf*", "curl*", "wget*"]
      
  secrets:
    sources: ["env", "keychain", "vscode-secrets"]
    variables: ["GITHUB_TOKEN", "NPM_TOKEN"]
    
  enterprise:
    requireApproval: [write_file, run_command]
    auditLog: true
    telemetryOptIn: false

# Observability
observability:
  logging:
    level: info  # debug | info | warn | error
    format: json
    destination: ${pluginDir}/logs/
  metrics:
    enabled: true
    export: prometheus  # prometheus | statsd | none
  tracing:
    enabled: true
    sampleRate: 0.1
```

### Tool implementation specification

Tools are implemented as TypeScript/JavaScript modules with a standard interface:

```typescript
// tools/analyze-complexity.ts
import { ToolContext, ToolResult } from '@portable-plugin/sdk';

interface AnalyzeComplexityInput {
  filePath: string;
  metrics?: ('cyclomatic' | 'cognitive' | 'loc' | 'maintainability')[];
  threshold?: { cyclomatic?: number; cognitive?: number };
}

export async function execute(
  input: AnalyzeComplexityInput,
  context: ToolContext
): Promise<ToolResult> {
  const { filePath, metrics = ['cyclomatic'], threshold = {} } = input;
  
  // Read file(s)
  const files = await context.fs.glob(filePath);
  const results = [];
  
  for (const file of files) {
    const content = await context.fs.readFile(file);
    const analysis = analyzeComplexity(content, metrics);
    
    results.push({
      file,
      metrics: analysis,
      violations: checkThresholds(analysis, threshold)
    });
  }
  
  return {
    success: true,
    data: {
      results,
      summary: summarize(results)
    }
  };
}

// Export metadata for runtime discovery
export const metadata = {
  name: 'analyze_complexity',
  version: '1.0.0'
};
```

---

## Adapter architecture

### Overview

The adapter architecture translates the portable spec into platform-native constructs. Each adapter implements a common interface but generates platform-specific outputs.

```
┌─────────────────────────────────────────────────────────────────────┐
│                     PORTABLE PLUGIN RUNTIME                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              portable-plugin.yaml (Manifest)                 │   │
│  │    Agents | Tools | Commands | Hooks | Policies | Workflows  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    MCP Server (Shared)                       │   │
│  │         Tools implemented as MCP tool handlers               │   │
│  │              Runs locally via stdio or HTTP                  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│           ┌──────────────────┴──────────────────┐                  │
│           ▼                                      ▼                  │
│  ┌─────────────────────┐            ┌─────────────────────┐        │
│  │   Claude Adapter    │            │   Copilot Adapter   │        │
│  │                     │            │                     │        │
│  │ • Generates plugin  │            │ • VS Code extension │        │
│  │   directory struct  │            │ • Chat participant  │        │
│  │ • Native agents.md  │            │ • Orchestrator for  │        │
│  │ • Native hooks.json │            │   multi-agent       │        │
│  │ • Native commands/  │            │ • Event dispatcher  │        │
│  │ • .mcp.json config  │            │ • .vscode/mcp.json  │        │
│  └─────────────────────┘            └─────────────────────┘        │
│           │                                      │                  │
│           ▼                                      ▼                  │
│  ┌─────────────────────┐            ┌─────────────────────┐        │
│  │    Claude Code      │            │  GitHub Copilot     │        │
│  │   (Native Runtime)  │            │   (VS Code)         │        │
│  └─────────────────────┘            └─────────────────────┘        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Claude Code adapter

The Claude adapter generates native plugin structure:

```typescript
// adapters/claude/generator.ts
export async function generateClaudePlugin(manifest: PortableManifest): Promise<void> {
  const outputDir = path.join(process.cwd(), 'dist', 'claude-plugin');
  
  // 1. Generate plugin.json manifest
  await fs.writeFile(
    path.join(outputDir, '.claude-plugin', 'plugin.json'),
    JSON.stringify({
      name: manifest.metadata.name,
      version: manifest.metadata.version,
      description: manifest.metadata.description,
      author: manifest.metadata.author
    }, null, 2)
  );
  
  // 2. Generate agent files
  for (const agent of manifest.agents) {
    const agentMd = generateAgentMarkdown(agent);
    await fs.writeFile(
      path.join(outputDir, 'agents', `${agent.name}.md`),
      agentMd
    );
  }
  
  // 3. Generate hooks.json
  const hooksConfig = translateHooksToClaudeFormat(manifest.hooks);
  await fs.writeFile(
    path.join(outputDir, '.claude', 'settings.json'),
    JSON.stringify({ hooks: hooksConfig }, null, 2)
  );
  
  // 4. Generate commands
  for (const command of manifest.commands) {
    const commandMd = generateCommandMarkdown(command);
    await fs.writeFile(
      path.join(outputDir, 'commands', `${command.name}.md`),
      commandMd
    );
  }
  
  // 5. Generate MCP config pointing to shared MCP server
  await fs.writeFile(
    path.join(outputDir, '.mcp.json'),
    JSON.stringify({
      mcpServers: {
        [manifest.metadata.name]: {
          command: 'node',
          args: ['./mcp-server/index.js']
        }
      }
    }, null, 2)
  );
}

function generateAgentMarkdown(agent: AgentDefinition): string {
  return `---
name: ${agent.name}
description: ${agent.description}
tools: ${agent.tools.join(', ')}
model: ${agent.model === 'default' ? 'sonnet' : agent.model}
permissionMode: default
---

${agent.systemPrompt}
`;
}
```

### Copilot adapter (VS Code extension)

The Copilot adapter generates a VS Code extension with:
1. **Chat Participant** for user interaction
2. **Orchestrator Agent** for multi-agent emulation
3. **Event Dispatcher** for hook emulation
4. **MCP Server Configuration**

```typescript
// adapters/copilot/extension.ts
import * as vscode from 'vscode';
import { PortableManifest, AgentDefinition } from '@portable-plugin/sdk';

export function activate(context: vscode.ExtensionContext) {
  const manifest = loadManifest();
  
  // 1. Register Chat Participant
  const participant = vscode.chat.createChatParticipant(
    `${manifest.metadata.name}.assistant`,
    createHandler(manifest)
  );
  
  // Register slash commands from manifest
  for (const cmd of manifest.commands) {
    // Commands are defined in package.json, handled in createHandler
  }
  
  // 2. Register Language Model Tools for non-MCP tools
  for (const tool of manifest.tools.filter(t => t.implementation.type !== 'mcp')) {
    const toolImpl = createToolImplementation(tool);
    context.subscriptions.push(
      vscode.lm.registerTool(`${manifest.metadata.name}_${tool.name}`, toolImpl)
    );
  }
  
  // 3. Setup Event Dispatcher for hooks
  setupEventDispatcher(context, manifest.hooks);
  
  context.subscriptions.push(participant);
}

// Multi-agent orchestration via single handler
function createHandler(manifest: PortableManifest): vscode.ChatRequestHandler {
  const orchestrator = new AgentOrchestrator(manifest.agents, manifest.workflows);
  
  return async (request, context, stream, token) => {
    // Check for explicit command
    if (request.command) {
      const cmd = manifest.commands.find(c => c.name === request.command);
      if (cmd?.workflow) {
        return orchestrator.executeWorkflow(cmd.workflow, request, stream, token);
      }
      if (cmd?.tool) {
        return executeToolCommand(cmd, request, stream, token);
      }
    }
    
    // Default: use orchestrator to select and coordinate agents
    return orchestrator.process(request, stream, token);
  };
}

// Orchestrator emulates multi-agent via sequential LLM calls
class AgentOrchestrator {
  private agents: Map<string, AgentDefinition>;
  private workflows: Map<string, WorkflowDefinition>;
  
  async process(request: vscode.ChatRequest, stream: vscode.ChatResponseStream, token: vscode.CancellationToken) {
    // 1. Planning phase - determine which agents needed
    stream.progress('Planning approach...');
    const plan = await this.plan(request.prompt);
    
    // 2. Execute each step, switching "agent context" via system prompts
    for (const step of plan.steps) {
      stream.progress(`${step.agent}: ${step.action}...`);
      
      const agent = this.agents.get(step.agent);
      const result = await this.executeAgentStep(agent, step, token);
      
      // Stream intermediate results
      stream.markdown(`### ${agent.name}\n${result.summary}\n\n`);
    }
    
    return { metadata: { workflow: plan.name } };
  }
  
  private async executeAgentStep(agent: AgentDefinition, step: WorkflowStep, token: vscode.CancellationToken) {
    const [model] = await vscode.lm.selectChatModels({ vendor: 'copilot' });
    
    // Construct agent-specific context
    const messages = [
      vscode.LanguageModelChatMessage.User(
        `${agent.systemPrompt}\n\n---\n\nTask: ${step.input}`
      )
    ];
    
    // Filter tools to only those allowed for this agent
    const allowedTools = vscode.lm.tools.filter(t => 
      agent.tools.includes(t.name.replace(`${this.manifest.metadata.name}_`, ''))
    );
    
    const response = await model.sendRequest(messages, { tools: allowedTools }, token);
    return this.processResponse(response);
  }
}

// Event dispatcher maps portable hooks to VS Code events
function setupEventDispatcher(context: vscode.ExtensionContext, hooks: HookDefinition[]) {
  const postWriteHooks = hooks.filter(h => h.event === 'postFileWrite');
  const preWriteHooks = hooks.filter(h => h.event === 'preFileWrite');
  
  // Map postFileWrite to onDidSaveTextDocument
  if (postWriteHooks.length > 0) {
    context.subscriptions.push(
      vscode.workspace.onDidSaveTextDocument(async (document) => {
        for (const hook of postWriteHooks) {
          if (matchesPattern(document.uri.fsPath, hook.matcher.filePatterns)) {
            await executeHookAction(hook.action, { filePath: document.uri.fsPath });
          }
        }
      })
    );
  }
  
  // Note: preToolUse hooks cannot be directly mapped - must use tool wrapper
}
```

### Generated package.json for VS Code extension

```json
{
  "name": "code-quality-suite-copilot",
  "displayName": "Code Quality Suite",
  "version": "1.2.0",
  "engines": { "vscode": "^1.100.0" },
  "extensionDependencies": ["github.copilot-chat"],
  "categories": ["AI", "Linters", "Testing"],
  "contributes": {
    "chatParticipants": [{
      "id": "code-quality-suite.assistant",
      "name": "quality",
      "fullName": "Code Quality Suite",
      "description": "Multi-agent code quality analysis and fixes",
      "isSticky": true,
      "commands": [
        { "name": "review", "description": "Start a code review session" },
        { "name": "complexity", "description": "Analyze code complexity" },
        { "name": "fix-issue", "description": "Fix a GitHub issue" }
      ]
    }],
    "languageModelTools": [{
      "name": "cqs_analyze_complexity",
      "displayName": "Analyze Complexity",
      "modelDescription": "Analyzes code complexity metrics",
      "inputSchema": {
        "type": "object",
        "properties": {
          "filePath": { "type": "string" },
          "metrics": { "type": "array", "items": { "type": "string" } }
        },
        "required": ["filePath"]
      }
    }]
  },
  "main": "./dist/extension.js"
}
```

---

## Reference implementation plan

### Repository structure

```
portable-plugin-system/
├── packages/
│   ├── sdk/                          # Core SDK
│   │   ├── src/
│   │   │   ├── manifest/             # Manifest parsing & validation
│   │   │   │   ├── schema.ts         # JSON Schema definitions
│   │   │   │   ├── parser.ts         # YAML/JSON parser
│   │   │   │   └── validator.ts      # Validation logic
│   │   │   ├── runtime/              # Shared runtime
│   │   │   │   ├── tool-executor.ts  # Tool execution engine
│   │   │   │   ├── hook-dispatcher.ts # Hook dispatch logic
│   │   │   │   └── context.ts        # Execution context
│   │   │   ├── mcp/                  # MCP server implementation
│   │   │   │   ├── server.ts         # MCP server core
│   │   │   │   └── handlers.ts       # Tool handlers
│   │   │   └── types/                # TypeScript definitions
│   │   └── package.json
│   │
│   ├── adapter-claude/               # Claude Code adapter
│   │   ├── src/
│   │   │   ├── generator.ts          # Plugin structure generator
│   │   │   ├── agents.ts             # Agent file generator
│   │   │   ├── hooks.ts              # Hook config generator
│   │   │   └── commands.ts           # Command file generator
│   │   └── package.json
│   │
│   ├── adapter-copilot/              # VS Code/Copilot adapter
│   │   ├── src/
│   │   │   ├── extension.ts          # VS Code extension entry
│   │   │   ├── participant.ts        # Chat participant
│   │   │   ├── orchestrator.ts       # Multi-agent orchestrator
│   │   │   ├── event-dispatcher.ts   # Hook → VS Code event mapping
│   │   │   └── tools.ts              # Tool registration
│   │   └── package.json
│   │
│   └── cli/                          # CLI tool
│       ├── src/
│       │   ├── commands/
│       │   │   ├── init.ts           # Initialize new plugin
│       │   │   ├── build.ts          # Build for target platform
│       │   │   ├── validate.ts       # Validate manifest
│       │   │   └── test.ts           # Run plugin tests
│       │   └── index.ts
│       └── package.json
│
├── examples/
│   └── code-quality-suite/           # Example plugin
│       ├── portable-plugin.yaml      # Manifest
│       ├── tools/                    # Tool implementations
│       │   ├── analyze-complexity.ts
│       │   └── run-tests.ts
│       ├── tests/                    # Plugin tests
│       │   ├── tools.test.ts
│       │   └── workflows.test.ts
│       └── package.json
│
├── docs/
│   ├── getting-started.md
│   ├── manifest-reference.md
│   ├── adapter-development.md
│   └── security-guide.md
│
└── package.json                      # Monorepo root
```

### Hello World plugin example

**portable-plugin.yaml:**
```yaml
apiVersion: portable-plugin/v1
kind: Plugin

metadata:
  name: hello-world
  version: 0.1.0
  description: Minimal portable plugin demonstrating all features

agents:
  - name: planner
    description: Creates simple plans
    systemPrompt: You are a helpful planner. Break tasks into steps.
    tools: [read_file, list_files]
    
  - name: implementer
    description: Implements planned changes
    systemPrompt: You implement code changes carefully and correctly.
    tools: [read_file, write_file]
    
  - name: reviewer
    description: Reviews implementations
    systemPrompt: You review code for correctness and style.
    tools: [read_file]

workflows:
  - name: plan-implement-review
    steps:
      - agent: planner
        action: plan
        input: "${userRequest}"
        output: plan
      - agent: implementer
        action: implement
        input: "${plan}"
        output: changes
      - agent: reviewer
        action: review
        input: "${changes}"
        output: review

tools:
  - name: get_greeting
    description: Returns a greeting message
    inputSchema:
      type: object
      properties:
        name: { type: string, description: "Name to greet" }
      required: [name]
    implementation:
      type: script
      entrypoint: tools/greeting.ts

commands:
  - name: hello
    description: Say hello with multi-agent workflow
    argumentHint: "[name]"
    workflow: plan-implement-review

hooks:
  - event: postFileWrite
    description: Log file saves
    matcher:
      filePatterns: ["**/*"]
    action:
      type: command
      command: echo "File saved: ${filePath}"
```

**tools/greeting.ts:**
```typescript
import { ToolContext, ToolResult } from '@portable-plugin/sdk';

interface GreetingInput {
  name: string;
}

export async function execute(input: GreetingInput, context: ToolContext): Promise<ToolResult> {
  const greeting = `Hello, ${input.name}! 👋`;
  
  // Optionally write to file
  if (context.options.writeToFile) {
    await context.fs.writeFile('greeting.txt', greeting);
  }
  
  return {
    success: true,
    data: { greeting, timestamp: new Date().toISOString() }
  };
}
```

### Build commands

```bash
# Initialize new plugin
npx @portable-plugin/cli init my-plugin

# Validate manifest
npx @portable-plugin/cli validate

# Build for Claude Code
npx @portable-plugin/cli build --target claude --output dist/claude

# Build for VS Code/Copilot
npx @portable-plugin/cli build --target copilot --output dist/copilot

# Build MCP server (shared)
npx @portable-plugin/cli build --target mcp --output dist/mcp-server

# Run tests
npx @portable-plugin/cli test

# Package for distribution
npx @portable-plugin/cli package --all
```

---

## Security and compliance

### Secrets handling

**Portable spec approach:**
```yaml
policies:
  secrets:
    sources: [env, keychain, vscode-secrets]
    variables: [GITHUB_TOKEN, API_KEY]
    redactFromLogs: true
```

**Claude Code adapter:**
- Generates deny patterns for `.env*`, `secrets/**`, `*.key`
- Secrets accessed via environment variables

**Copilot adapter:**
- Uses `context.secrets` API for storage
- Registers as VS Code extension with `secretStorage` capability
- Prompts user for secrets on first use

**Implementation:**
```typescript
// SDK secret access abstraction
class SecretProvider {
  async get(key: string): Promise<string | undefined> {
    if (this.platform === 'claude') {
      return process.env[key];
    } else if (this.platform === 'copilot') {
      return this.vscodeSecrets.get(key);
    }
  }
}
```

### Permission model

| Operation | Claude Code | Copilot | Portable Spec |
|-----------|-------------|---------|---------------|
| File read | Allow by default | Allow by default | Define in policies.fileAccess.allow |
| File write | Requires approval | Requires confirmation | Define in policies.fileAccess.allow |
| Command execution | Pattern matching | Tool confirmation | Define in policies.commandExecution |
| Network requests | Allow by default | Allow by default | Define in policies.networkAccess |
| Secret access | Deny patterns | Secrets API | Define in policies.secrets |

**Enforcement strategy:**
- **Claude Code**: Native permission system with allow/deny lists
- **Copilot**: Tool `prepareInvocation` confirmation + adapter-level filtering
- **Shared MCP**: Tool handlers validate against policy before execution

### Logging and PII

```yaml
observability:
  logging:
    level: info
    redaction:
      patterns: ["Bearer \\w+", "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b"]
      fields: [password, token, secret, key]
    retention: 7d
```

**Implementation:**
```typescript
class SecureLogger {
  private redactionPatterns: RegExp[];
  
  log(level: string, message: string, context?: object) {
    const sanitized = this.redact(message);
    const sanitizedContext = context ? this.redactObject(context) : undefined;
    
    this.output.write({
      timestamp: new Date().toISOString(),
      level,
      message: sanitized,
      context: sanitizedContext
    });
  }
  
  private redact(text: string): string {
    let result = text;
    for (const pattern of this.redactionPatterns) {
      result = result.replace(pattern, '[REDACTED]');
    }
    return result;
  }
}
```

### Enterprise controls

```yaml
policies:
  enterprise:
    requireApproval: [write_file, run_command, network_request]
    auditLog: true
    allowedModels: [gpt-4o, claude-sonnet]
    disabledFeatures: [autonomous_mode]
    maxTokensPerRequest: 8000
```

**Enforcement:**
- **Claude Code**: Via managed settings (`/etc/claude-code/managed-settings.json`)
- **Copilot**: Via GitHub org policies + VS Code settings policies
- **Portable**: Adapter checks policy before operations

---

## Implementation timeline

### Week 1: Foundation and MCP core

**Goals:** Establish project structure, implement MCP server, validate basic tool execution

**Tasks:**
- [ ] Initialize monorepo with Turborepo/Nx
- [ ] Define TypeScript interfaces for manifest schema
- [ ] Implement YAML/JSON manifest parser with validation
- [ ] Build MCP server skeleton with stdio transport
- [ ] Implement 2-3 basic tools (read_file, write_file, run_command)
- [ ] Create Hello World example plugin
- [ ] Test MCP server with Claude Code and VS Code Copilot

**Deliverable:** MCP server running identical tools in both environments

### Week 2: Multi-agent orchestration

**Goals:** Implement agent orchestration for Copilot, validate multi-agent workflows

**Tasks:**
- [ ] Design orchestrator state machine
- [ ] Implement agent context switching (system prompt injection)
- [ ] Build workflow executor for sequential/conditional steps
- [ ] Implement tool filtering per agent
- [ ] Create Claude adapter agent file generator
- [ ] Create Copilot adapter chat participant with orchestrator
- [ ] Test multi-agent workflow (planner → implementer → reviewer)

**Deliverable:** Same multi-agent workflow running in both environments

### Week 3: Hooks, commands, and packaging

**Goals:** Complete hook system, slash commands, and build/package tooling

**Tasks:**
- [ ] Implement hook dispatcher for portable spec
- [ ] Create Claude adapter hooks.json generator
- [ ] Create Copilot adapter VS Code event mapping
- [ ] Implement slash command generation for both platforms
- [ ] Build CLI with init, build, validate, test commands
- [ ] Implement package command for distribution
- [ ] Create installation scripts

**Deliverable:** Complete CLI and end-to-end plugin packaging

### Week 4: Stabilization, security, and documentation

**Goals:** Harden security, comprehensive testing, documentation

**Tasks:**
- [ ] Implement policy enforcement layer
- [ ] Add secret handling abstraction
- [ ] Implement audit logging
- [ ] Write unit tests for all components (>80% coverage)
- [ ] Create integration tests for both platforms
- [ ] Write getting-started guide
- [ ] Write manifest reference documentation
- [ ] Write security guide
- [ ] Create video walkthrough

**Deliverable:** Production-ready v1.0 release

---

## Risks, limitations, and alternatives

### What cannot be done in Copilot today

| Limitation | Impact | Workaround |
|------------|--------|------------|
| **No native multi-agent** | Cannot delegate to specialized agents | Orchestrator emulates via sequential LLM calls with different system prompts |
| **No semantic hooks** | Cannot intercept tool calls directly | Map to VS Code events (onDidSave, etc.) + wrapper functions |
| **No agent isolation** | All tools visible to single agent | Adapter filters tool list based on current "agent role" |
| **Chat participants only in Ask mode** | Cannot use participants in Agent mode | Use Language Model Tools instead |
| **128 tool limit** | Large plugin suites may exceed | Group related tools, use virtual tools feature |
| **No PreToolUse blocking** | Cannot prevent tool execution | Implement validation in tool's prepareInvocation |
| **Background Agents limited** | Cannot use MCP/extension tools | Use foreground agent mode only |

### Critical risks

**Risk 1: API instability**
- Both platforms are evolving rapidly
- Mitigation: Abstract platform APIs behind stable SDK interfaces; version pin dependencies

**Risk 2: Feature divergence**
- Platforms may add incompatible features
- Mitigation: Design for graceful degradation; maintain capability matrix

**Risk 3: Performance overhead**
- Multi-agent emulation in Copilot adds latency
- Mitigation: Optimize orchestrator; cache agent contexts; allow single-agent fallback

**Risk 4: Enterprise adoption barriers**
- Different enterprise policy models
- Mitigation: Implement policy abstraction; document compliance requirements

### Alternative approaches

**Option A: MCP-only (Recommended)**
- Use MCP for all tools, minimal platform-specific code
- Pros: Maximum portability, single tool implementation
- Cons: Limited hook/agent support

**Option B: VS Code Extension + Local Service**
- Extension handles UI/events, local service runs tools
- Pros: Full VS Code API access, clean separation
- Cons: Additional process management, port conflicts

**Option C: Remote Service**
- Tools run on remote server, both platforms call via HTTP
- Pros: Centralized, platform-agnostic
- Cons: Latency, network dependency, enterprise restrictions

**Recommendation:** Start with Option A (MCP-only) for tools, add Option B patterns for hooks/commands where needed.

---

## Decision tree: choosing your approach

```
┌─────────────────────────────────────────────────────────────────┐
│                  CHOOSING YOUR APPROACH                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Q1: Do you need multi-agent coordination?                       │
│  ├─ YES → Use portable spec with orchestrator adapter            │
│  └─ NO  → Q2                                                     │
│                                                                  │
│  Q2: Do you need hooks (event triggers)?                         │
│  ├─ YES → Use VS Code extension adapter + Claude hooks.json      │
│  └─ NO  → Q3                                                     │
│                                                                  │
│  Q3: Are you building only tools?                                │
│  ├─ YES → MCP server only (simplest path)                        │
│  └─ NO  → Full portable spec                                     │
│                                                                  │
│  Q4: Do you have enterprise/network restrictions?                │
│  ├─ YES → Local execution only (stdio MCP, no remote)            │
│  └─ NO  → Can use HTTP MCP for remote deployment                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Fastest path to end-to-end demo

1. **Create MCP server** with 1-2 tools (30 minutes)
2. **Configure Claude Code** with .mcp.json (5 minutes)
3. **Configure VS Code** with .vscode/mcp.json (5 minutes)
4. **Test tool invocation** in both environments (15 minutes)
5. **Add chat participant** for slash commands (45 minutes)
6. **Total: ~2 hours** for working portable tool

### Plugin portability checklist

- [ ] Manifest validates against portable-plugin schema
- [ ] All tools have MCP-compatible inputSchema/outputSchema
- [ ] Tools use SDK context abstraction (not direct fs/process)
- [ ] Secrets accessed via SDK secret provider
- [ ] Hooks use portable event names (not platform-specific)
- [ ] Commands define argumentHint and description
- [ ] Policies explicitly list allowed/denied patterns
- [ ] Tests run in both target environments
- [ ] No hardcoded platform-specific paths

---

## Conclusion

Building a portable plugin system across Claude Code and GitHub Copilot is achievable today using **MCP as the unification layer** and **platform-specific adapters** for higher-level constructs like agents and hooks. The key findings:

**MCP is the bridge.** Both platforms have embraced MCP, making tool portability straightforward. Write your tools once as MCP handlers, and they work everywhere.

**Multi-agent requires emulation.** Copilot lacks native multi-agent support, but an orchestrator pattern with system prompt switching provides a reasonable approximation. The experience differs slightly, but the functionality is preserved.

**Hooks need translation.** Claude Code's semantic hooks (PreToolUse, PostToolUse) don't map directly to Copilot. The adapter must translate to VS Code events and wrapper functions, accepting some fidelity loss.

**Start simple, iterate.** Begin with MCP-only tools to validate portability. Add agents and hooks incrementally. The 80/20 rule applies—80% of value comes from portable tools and commands.

The recommended implementation path is a TypeScript/Node.js SDK with a monorepo structure, starting with the MCP server core in week 1, adding agent orchestration in week 2, and completing with hooks and packaging in weeks 3-4. This approach minimizes risk while delivering incremental value throughout development.