# **The Unified Agent Architecture: A Blueprint for Portable Copilot Plugins**

## **Executive Summary**

The software development landscape is currently undergoing a seismic shift, transitioning from the era of "AI-Assisted Autocomplete" to the age of "Agentic Orchestration." In this new paradigm, developers are no longer merely typing code while an AI suggests completions; they are defining goals, constraints, and operational parameters for autonomous agents that plan, execute, debug, and iterate on complex tasks. This shift has bifurcated the tooling landscape into two dominant architectural patterns: the CLI-centric, highly scriptable ecosystem represented by Anthropic's **Claude Code**, and the IDE-integrated, platform-centric ecosystem represented by **GitHub Copilot** within Visual Studio Code and Visual Studio.

For enterprise architects and Developer Experience (DevEx) teams, this bifurcation presents a critical interoperability challenge. Creating specialized workflows—such as a "Security Review Agent" that audits pull requests or a "Migration Assistant" that refactors legacy code—currently requires duplicating engineering effort: writing complex JSON manifests and Bash scripts for Claude Code, while simultaneously developing TypeScript-based VS Code extensions or C\#-based Visual Studio plugins for GitHub Copilot. This redundancy stifles innovation and creates fragmentation in developer tooling.

This report presents a comprehensive technical blueprint for a **"Portable Plugin System."** It defines a **Universal Agent Manifest (UAM)**—a platform-agnostic specification that captures the intent, tools, and lifecycle hooks of a coding agent. Furthermore, it details the implementation of a **"Bridge Architecture"**: a reference implementation for a VS Code extension that "polyfills" the advanced capabilities of Claude Code (specifically multi-agent orchestration, shell-based skills, and event hooks) into the GitHub Copilot environment. By leveraging the **Model Context Protocol (MCP)** as the unifying data layer and the **VS Code Language Model API** as the reasoning engine, we demonstrate that a "write-once, run-anywhere" agentic workflow is not only possible but necessary for scalable AI adoption in the enterprise.

## ---

**1\. The Divergence of Agentic Runtimes: Context and Theory**

To construct a portable plugin system, one must first rigorously deconstruct the two target environments. While both Claude Code and GitHub Copilot share the ultimate goal of automating software production, their underlying philosophies regarding context management, tool execution, and user interaction differ fundamentally. These differences create the "impedance mismatch" that our portable architecture must resolve.

### **1.1 The Claude Code Paradigm: The Terminal as an Operating System**

Claude Code operates as an "Agentic CLI." It treats the terminal as its native runtime environment, granting it inherent access to the operating system's primitives—the filesystem, system tools, pipes, and environment variables. Its plugin system is designed around **declarative composition** and **OS-level integration**.1

The architecture of Claude Code is reminiscent of the UNIX philosophy: small, modular tools composed to perform complex tasks. A Claude Code plugin is essentially a directory containing a .claude-plugin/plugin.json manifest that binds distinct components together. These components—Commands, Agents, Skills, and Hooks—interact directly with the shell. For instance, a "Skill" in Claude Code is often a wrapper around a Python or Bash script, executed in the user's active shell session.3 This design offers immense power and flexibility but assumes a high-trust environment where the user explicitly controls the execution context.

**Key Architectural Characteristics of Claude Code:**

* **Ephemerality:** Context is often session-based, loaded dynamically from files like CLAUDE.md or via "Tool Search" mechanisms.4  
* **Imperative Shell Access:** Tools have direct access to stdin/stdout and can pipe data between processes.3  
* **Event-Driven Hooks:** The system exposes a rich set of lifecycle events (e.g., PreToolUse, PostToolUse) that allow plugins to intercept and modify the agent's behavior in real-time.6

### **1.2 The GitHub Copilot Paradigm: The IDE as a Platform**

In contrast, GitHub Copilot operates within the highly structured, sandboxed environment of an Integrated Development Environment (IDE) like VS Code or Visual Studio. Here, the "operating system" is not the Linux kernel but the VS Code Extension Host.

Extensibility in this environment is achieved through the **VS Code Extension API**, specifically deeply typed interfaces like ChatParticipant and LanguageModelTool.7 Unlike the loose contract of a CLI script, a Copilot extension interacts with the IDE's internal state—text buffers, diagnostic collections, and debug sessions—through a rigorous API surface.

**Key Architectural Characteristics of GitHub Copilot:**

* **Persistence:** The agent has access to long-lived workspace state, indexed codebases, and user settings.9  
* **Sandboxed Execution:** Direct shell execution is discouraged; interactions are mediated through APIs to ensure stability and security.10  
* **UI-Centricity:** Interaction occurs primarily through chat panels, inline decorations, and "Smart Actions," requiring plugins to render UI elements (Markdown, buttons) rather than raw text.7

### **1.3 The Portability Gap**

The challenge of portability lies in bridging these two divergent models. A script that runs grep in Claude Code cannot simply be "run" in VS Code without breaking the IDE's security model or user experience. Similarly, a VS Code extension that listens for vscode.workspace.onDidSaveTextDocument has no direct equivalent in a CLI tool unless explicitly programmed as a file watcher.

The following table summarizes the specific "translation layers" required for our blueprint:

| Feature Domain | Claude Code Implementation | GitHub Copilot (VS Code) Implementation | The Bridge Requirement |
| :---- | :---- | :---- | :---- |
| **Manifest** | JSON (plugin.json) | package.json contributions | A **Universal Agent Manifest (UAM)** compiler. |
| **Logic Unit** | Markdown Prompts (Agents) | ChatRequestHandler (TypeScript) | A generic **Agent Runner** that interprets prompts. |
| **Tooling** | Local Scripts / MCP | LanguageModelTool / MCP | An **MCP Adapter** to standardise tools. |
| **Orchestration** | Sub-agent chaining | Recursive sendRequest loops | A custom **ReAct Loop** implementation. |
| **Events** | hooks.json (Triggers) | VS Code Event Listeners | An **Event Bus** mapping IDE events to UAM hooks. |

## ---

**2\. The Universal Agent Manifest (UAM): Specification**

To decouple the agent definition from the runtime, we propose the **Universal Agent Manifest (UAM)**. This specification acts as the "Source of Truth" for any portable plugin. It draws inspiration from the "JSON Agents" standard 12 and the "Agent Definition Language" 13, but is specifically optimized for coding tasks.

The UAM is a YAML-based schema that defines the *What* (Identity), the *How* (Workflows), and the *With What* (Tools) of an agent.

### **2.1 The Schema Definition**

The UAM schema is divided into four primary sections: **Metadata**, **Agents**, **Tools**, and **Hooks**.

YAML

\# universal-agent.yaml  
apiVersion: "uam.ai/v1alpha1"  
kind: "AgentPlugin"  
metadata:  
  name: "security-sentinel"  
  version: "1.2.0"  
  description: "An autonomous security auditor that monitors code changes and enforces OWASP standards."  
  author: "SecOps Team"  
  license: "MIT"  
  icon: "shield-check" \# Mapped to VS Code product icons or terminal emojis

\# 1\. AGENTS: The "Personas" of the system  
\# Maps to Claude Sub-agents \[2\] and VS Code Chat Participants   
agents:  
  \- id: "auditor"  
    role: "Security Auditor"  
    description: "Reviews code diffs for vulnerabilities."  
    systemPrompt: "./prompts/auditor.md" \# Externalized for better editing  
    capabilities:   
      \- "code-reading"  
      \- "file-modification"  
    modelPreferences: \# Model-agnostic hints  
      reasoningLevel: "high" \# Suggests o1-preview or Opus  
      contextWindow: "128k"

\# 2\. TOOLS: The Capabilities  
\# Maps to Claude Skills  and VS Code LanguageModelTools   
tools:  
  \# Type A: Native Scripts (The challenge for portability)  
  \- name: "run-sast"  
    description: "Executes the Static Application Security Testing suite."  
    executor: "shell" \# Requires bridging  
    command: "./scripts/run-sast.sh"  
    inputSchema:  
      type: "object"  
      properties:  
        target\_dir: { type: "string" }  
      
  \# Type B: MCP Servers (The gold standard for portability)  
  \- name: "github-api"  
    type: "mcp"  
    source:   
      registry: "github" \# Pulls from standard registry  
      \# OR local definition  
      command: "npx"  
      args: \["-y", "@modelcontextprotocol/server-github"\]

\# 3\. COMMANDS: Shortcuts for workflows  
\# Maps to Claude Slash Commands \[2\] and VS Code Slash Commands   
commands:  
  \- name: "audit"  
    agent: "auditor"  
    description: "Audits the currently active file."  
    template: "Please audit the file {{activeFile}} for security flaws."

\# 4\. HOOKS: Event-Driven Logic  
\# Maps to Claude Hooks  and VS Code Event Listeners  
hooks:  
  \- event: "PostToolUse"  
    matcher: "Write|Edit" \# Regex on tool name  
    action:  
      type: "tool"  
      name: "run-sast" \# Triggers the tool defined above  
      blocking: true   \# Waits for completion before returning control

### **2.2 Deep Dive: The Component Strategy**

#### **2.2.1 The "Agent" Abstraction**

In Claude Code, an "Agent" is effectively a system prompt and a set of allowed tools.14 In VS Code, a "Chat Participant" is a programmed entity. The UAM bridges this by treating the Agent as a **System Prompt Configuration**. The runtime (whether CLI or IDE) is responsible for injecting this prompt into the context window at the start of the session.

* **Portability Mechanism:** The systemPrompt field points to a Markdown file. Markdown is universally supported. The UAM compiler copies this file to agents/ for Claude Code and bundles it into the VS Code extension's dist/ folder.

#### **2.2.2 The "Tool" Abstraction & MCP**

The greatest barrier to portability has historically been tool definitions. Claude Code uses SKILL.md or direct script execution.3 VS Code uses vscode.lm.registerTool.15

The **Model Context Protocol (MCP)** 16 is the "Rosetta Stone" for tools.

* **Strategy:** The UAM encourages defining tools as MCP servers.  
* **Claude Implementation:** Claude Code has native MCP support. The build system simply generates an .mcp.json file pointing to the servers defined in the UAM.  
* **VS Code Implementation:** Since VS Code (and Visual Studio 2022\) now supports MCP 18, the Bridge Extension acts as an **MCP Client**. It reads the UAM, spawns the specified MCP servers (e.g., using npx), and registers them as tools available to the Chat Participant.

#### **2.2.3 The "Hook" Abstraction**

Hooks are critical for "Agentic" workflows—automated loops that run without user intervention.

* **Claude Code:** Supports hooks natively via hooks.json.  
* **VS Code:** Does *not* have a "PreToolUse" event exposed to extensions in the same way. The Bridge Extension must *simulate* this by wrapping the tool execution logic in a middleware layer (detailed in Chapter 4).

## ---

**3\. Target Environment A: Claude Code (Native Compilation)**

Since the UAM is heavily inspired by Claude Code's architecture, targeting this environment is primarily a matter of **transpilation**—converting the unified YAML into the specific directory structure and JSON manifests expected by Anthropic's CLI.

### **3.1 The Compilation Process**

We define a build tool, uam-compiler, which accepts the universal-agent.yaml and outputs a standard Claude Plugin directory.

**Directory Mapping:**

| UAM Component | Source Location | Destination (Claude Plugin) | Transformation Logic |
| :---- | :---- | :---- | :---- |
| **Manifest** | metadata | .claude-plugin/plugin.json | Maps name, version, description. |
| **Agents** | agents.systemPrompt | agents/\<id\>.md | Copies file; adds frontmatter for permissions. |
| **Tools (Script)** | tools.command | scripts/ | Copies script; generates skills/\<name\>.md wrapper. |
| **Tools (MCP)** | tools.config | .mcp.json | Extracts MCP config into global MCP manifest. |
| **Commands** | commands | commands/\<name\>.md | Generates Markdown with template injection. |
| **Hooks** | hooks | hooks/hooks.json | Direct JSON serialization of the hooks object. |

### **3.2 Handling Script Execution**

Claude Code executes scripts natively on the host OS. This is a powerful feature but requires strict path management. The UAM compiler must ensure that all script paths in the generated SKILL.md files use the ${CLAUDE\_PLUGIN\_ROOT} environment variable.6

## **Example Generated Skill (skills/run-sast.md):**

## **name: run-sast description: Executes the Static Application Security Testing suite.**

# **Run SAST**

Run the following command to scan the codebase:bash  
"${CLAUDE\_PLUGIN\_ROOT}/scripts/run-sast.sh" \--target\_dir "$target\_dir"  
This ensures that regardless of where the user installs the plugin, the reference to the script remains valid.

## ---

**4\. Target Environment B: The GitHub Copilot Bridge (VS Code)**

Implementing the UAM in VS Code is significantly more complex. We cannot simply "generate" files; we must build a **Host Extension**—the "Bridge"—that reads the UAM at runtime and dynamically constructs the agentic environment.

### **4.1 The Bridge Extension Architecture**

The Bridge Extension (copilot-portable-bridge) consists of three core subsystems:

1. **The Dynamic Participant Registry:** Registers Chat Participants on the fly based on the manifest.  
2. **The Agentic Loop Engine:** A custom implementation of a Plan-and-Execute loop that handles orchestration.  
3. **The Tool/Hook Interceptor:** A middleware layer that manages tool execution and fires lifecycle events.

### **4.2 Subsystem 1: Dynamic Participant Registry**

When the extension activates, it scans the workspace (and global settings) for universal-agent.yaml files. For each valid manifest found, it calls vscode.chat.createChatParticipant.

Implementation Detail:  
The id of the participant is derived from the manifest name (e.g., @security-sentinel). The handler for this participant is a generic function handleAgentRequest that is parameterized with the specific agent's system prompt and toolset.

TypeScript

// registry.ts  
import \* as vscode from 'vscode';  
import { AgentManifest } from './uam-types';

export function registerAgent(manifest: AgentManifest, context: vscode.ExtensionContext) {  
    const participant \= vscode.chat.createChatParticipant(  
        \`bridge.${manifest.metadata.name}\`,  
        (request, context, stream, token) \=\> handleAgentRequest(request, context, stream, token, manifest)  
    );  
    participant.iconPath \= vscode.Uri.file(manifest.metadata.icon);  
    context.subscriptions.push(participant);  
}

### **4.3 Subsystem 2: The Agentic Loop Engine**

VS Code's "Agent Mode" is still evolving.20 To ensure our plugins support multi-step reasoning *today*, the Bridge must implement its own loop using the vscode.lm API. This allows us to replicate Claude Code's "Sub-agent" behavior.

**The Loop Logic:**

1. **Context Construction:** The Bridge constructs a messages array starting with the Agent's systemPrompt (loaded from the Markdown file defined in UAM).  
2. **User Input:** The user's chat prompt is added.  
3. **Inference:** model.sendRequest(messages) is called.  
4. **Tool Detection:** The Bridge inspects the response for tool calls (using LanguageModelChatResponse).  
5. **Recursion:** If a tool is called, the Bridge executes it (see Subsystem 3), appends the result to messages, and calls model.sendRequest again.

Model Agnosticism:  
The prompt asks for the system to be "model-agnostic." The Bridge achieves this by using the vscode.lm.selectChatModels API.21

* The UAM modelPreferences field allows the plugin author to request "high reasoning" or "fast" models.  
* The Bridge maps "high reasoning" to families like gpt-4o or claude-3-5-sonnet (if available via Copilot), and "fast" to gpt-4o-mini.  
* This abstraction insulates the plugin code from specific model versions.

### **4.4 Subsystem 3: The Tool/Hook Interceptor (The "Secret Sauce")**

This is the most critical component for feature parity. In Claude Code, hooks like PreToolUse allow a plugin to block or modify a tool call. Standard VS Code extensions don't expose this level of control to *other* extensions easily. However, since the Bridge *owns* the Loop, it can enforce hooks.

**The Hook Execution Flow:**

1. **Event: Tool Call Detected** (by the Loop Engine).  
2. **Check: PreToolUse Hook:** The Bridge checks the UAM hooks list.  
   * Does a hook match PreToolUse for this tool name?  
   * **Yes:** Execute the Hook Action (e.g., run a validation script).  
   * **Decision:** Did the hook return "Deny"? If so, inject a "Tool Denied" message into the context and skip execution.  
3. **Action: Execute Tool:**  
   * If the tool is **MCP**: The Bridge routes the call to the internal MCP Client.23  
   * If the tool is **Shell Script**: The Bridge executes it via a **Task Provider** (see Section 4.5).  
4. **Event: Tool Completed.**  
5. **Check: PostToolUse Hook:** The Bridge checks for post-execution hooks (e.g., "Run Linter after Write").  
   * **Yes:** Execute the Hook Action.  
   * **Feedback:** If the hook fails (linter error), inject the error into the context so the Agent can self-correct in the next loop iteration.

### **4.5 Safe Script Execution via Task Providers**

Executing arbitrary shell scripts (defined in the UAM) within VS Code requires handling the "Sandbox" constraint. Simply spawning a child process is invisible to the user and can be blocked by security settings.

The "Task" Strategy:  
Instead of hidden processes, the Bridge registers a vscode.TaskProvider.24

* When an agent wants to run ./scripts/run-sast.sh, the Bridge creates a vscode.Task.  
* **Execution:** vscode.tasks.executeTask(task).  
* **Visibility:** This opens a Terminal pane, showing the user exactly what command is running. This creates transparency and trust—critical for a "Copilot" experience.  
* **Output Capture:** The Bridge utilizes vscode.window.onDidWriteTerminalData (or shell integration APIs) to capture the command output and feed it back to the LLM.8

## ---

**5\. Adapting for Visual Studio (The IDE)**

While VS Code and Visual Studio (VS 2022\) share the "GitHub Copilot" branding, their extensibility architectures are distinct. VS 2022 uses.NET/C\# and the Managed Extensibility Framework (MEF), whereas VS Code uses TypeScript/Node.js.

### **5.1 The Visual Studio Gap**

Visual Studio 2022's support for the "Chat Participant" API is newer and less functionally complete than VS Code's. As of early 2026, creating a custom "Loop" within VS 2022 is restricted.

### **5.2 The MCP Solution for VS 2022**

However, Visual Studio 2022 has introduced robust, native support for **MCP**.18 It allows users to configure MCP servers via a GUI, which are then exposed to the standard Copilot Chat.

The Strategy:  
For Visual Studio 2022, we cannot (yet) fully replicate the "Agentic Loop" or "Hooks" via a Bridge Extension without significant complexity. Therefore, the implementation for VS 2022 focuses on Tool Portability via MCP.

* **Mechanism:** The uam-compiler generates a .mcp.json file.  
* **Usage:** The user imports this .mcp.json into Visual Studio's "MCP Server Manager".19  
* **Result:** The tools defined in the UAM become available to the standard Copilot Agent. While the *orchestration* (Sub-agents, Hooks) is lost, the *capabilities* (Tools) are preserved. This is a "Graceful Degradation" strategy.

## ---

**6\. Model-Agnosticism and the Future of Context**

A key requirement is model agnosticism. The portable system must not lock the user into a specific LLM provider.

### **6.1 The "Model Preferences" Abstraction**

The UAM introduces a modelPreferences section that avoids naming specific models (e.g., "gpt-4"). Instead, it uses **Capability Profiles**:

| Profile | Definition | Mapping (VS Code) | Mapping (Claude Code) |
| :---- | :---- | :---- | :---- |
| fast | Low latency, lower reasoning | gpt-4o-mini | claude-3-haiku |
| balanced | Standard reasoning | gpt-4o | claude-3-5-sonnet |
| reasoning | High-compute, chain-of-thought | o1 / o3 | claude-3-opus |

The Bridge Extension reads this preference and utilizes vscode.lm.selectChatModels({ family:... }) to find the best matching model available in the user's active subscription.21 This ensures that if a user switches from GitHub Copilot to another provider (e.g., a local LLM via an extension), the plugin continues to function.

### **6.2 Managing Context Window Pressure**

Claude Code and Copilot manage context differently. Claude Code aggressively "summarizes" and "compacts" context.26 Copilot relies on a rolling window.

The "Context Manager" Component:  
The Bridge Extension implements a sliding window algorithm.

* **Token Counting:** Using vscode.lm.countTokens 27, the Bridge monitors the conversation size.  
* **Pruning:** When the context approaches the model's limit (defined in the profile), the Bridge summarizes older "Tool Result" messages into a concise string (e.g., "Tool run-sast executed successfully with 0 errors").  
* **Persistence:** For long-running agents, the Bridge serializes the "Memory" (key facts learned) to a .vscode/agent-memory.json file, mimicking Claude Code's project memory features.28

## ---

**7\. Security and Governance: The "Sandbox" Problem**

Portability introduces significant security risks. A plugin that is safe in a CLI (where the user sees every command) can be dangerous in an IDE (where background processes are common).

### **7.1 Threat Modeling**

* **Risk:** A malicious plugin defines a hook on Save that exfiltrates code to a remote server via curl.  
* **Risk:** Prompt Injection in the Agent Loop causes the LLM to ignore safety constraints.

### **7.2 The "Permission Manifest" Strategy**

The UAM requires a strict permissions block.

YAML

permissions:  
  filesystem:  
    \- read: "./src"  
    \- write: "./src/logs"  
  network:  
    \- "api.github.com"  
  shell:  
    \- "npm test"

**Implementation in the Bridge:**

1. **Pre-Flight Authorization:** When a new UAM is loaded, the Bridge parses the permissions. It displays a "Plugin Authorization" dialog to the user listing requested capabilities.29  
2. **Runtime Enforcement:**  
   * **Network:** The Bridge wraps fetch calls or MCP connections. If a tool tries to access a disallowed domain, it is blocked.  
   * **Shell:** The TaskProvider only allows commands that match the allowlist patterns.  
3. **Restricted Mode:** If the VS Code workspace is in "Restricted Mode" (Untrusted Workspace), the Bridge **disables all Hooks and Shell Tools** automatically.30 Only "Pure Logic" agents (Chat only) are allowed to run.

## ---

**8\. Case Studies and Reference Implementations**

To validate this architecture, we examine two common "Agent Patterns" and their realization in this system.

### **8.1 Case Study 1: The "Code Review Sentinel"**

**Goal:** Automatically run a linter and suggest fixes whenever a file is saved.

* **UAM Definition:** A PostToolUse hook matching "Write" operations.  
* **Claude Code Behavior:** The CLI pauses after writing, runs the linter script, and if errors are found, the agent automatically triggers a "Fix" sub-agent.  
* **VS Code Bridge Behavior:** The extension listens for onDidSaveTextDocument. It triggers the linter Task. It captures the output. If errors exist, it creates a "Diagnostic" in the editor (red squiggly lines) and populates the Chat Panel with a "Fix this?" button.  
* **Insight:** This demonstrates how the Bridge translates an *Agentic Loop* (CLI) into a *UI Interaction* (IDE), maintaining the intent while respecting the medium.

### **8.2 Case Study 2: The "Migration Architect"**

**Goal:** Scan the entire codebase, plan a migration from Python 2 to 3, and execute it file-by-file.

* **UAM Definition:** A "Planner" agent (high reasoning) and an "Executor" agent (fast). A tool list-files.  
* **Claude Code Behavior:** The Planner runs list-files, generates a plan, and loops through the Executor for each file.  
* **VS Code Bridge Behavior:** The Bridge instantiates the Planner. Upon receiving the plan (structured JSON), the Bridge's Loop Engine iterates through the list, invoking the Executor for each item. It updates a progress bar in the VS Code Status Bar.  
* **Insight:** This highlights the need for the Bridge to support **Structured Output** (JSON mode) to enable reliable hand-offs between agents.31

## ---

**9\. Conclusion**

The "Portable Plugin System" is an architectural imperative for the next generation of AI development. By standardizing on the **Universal Agent Manifest (UAM)**, organizations can define their development workflows once and deploy them across the fragmented landscape of agentic runtimes.

While **Claude Code** offers a "native" home for these definitions with its OS-level integration, **GitHub Copilot** (via VS Code) requires a sophisticated **Bridge Extension** to emulate these capabilities. This Bridge—built on the pillars of **MCP** for tools, **Task Providers** for execution, and a custom **ReAct Loop** for orchestration—effectively "polyfills" the missing agentic features into the IDE.

Strategic Recommendation:  
Organizations should adopt MCP immediately as the standard for all internal tools. Following this, they should deploy the Universal Agent Manifest and the Bridge Extension to decouple their workflow logic from specific vendor implementations. This ensures that as AI models evolve and IDEs change, the core intellectual property—the codified knowledge of how to build software—remains portable, secure, and enduring.

### **References**

* 1 Claude Code Plugin Architecture & Manifests.  
* 7 VS Code Chat Participant & Extension API.  
* 16 Model Context Protocol (MCP) Standards & Integrations.  
* 6 Claude Code Hooks & Lifecycle Events.  
* 20 VS Code Agent Mode & Loop Architectures.  
* 12 JSON Agents & Agent Definition Language Standards.  
* 10 VS Code Security & Trust Models.  
* 24 VS Code Task Provider API.  
* 21 VS Code Language Model API.  
* 3 Claude Code Skills & Scripting.

#### **Works cited**

1. Create plugins \- Claude Code Docs, accessed January 19, 2026, [https://code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins)  
2. Plugins reference \- Claude Code Docs, accessed January 19, 2026, [https://code.claude.com/docs/en/plugins-reference](https://code.claude.com/docs/en/plugins-reference)  
3. Agent Skills \- Claude Code Docs, accessed January 19, 2026, [https://code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills)  
4. Claude Code: Best practices for agentic coding \- Anthropic, accessed January 19, 2026, [https://www.anthropic.com/engineering/claude-code-best-practices](https://www.anthropic.com/engineering/claude-code-best-practices)  
5. Introducing advanced tool use on the Claude Developer Platform \- Anthropic, accessed January 19, 2026, [https://www.anthropic.com/engineering/advanced-tool-use](https://www.anthropic.com/engineering/advanced-tool-use)  
6. Hooks reference \- Claude Code Docs, accessed January 19, 2026, [https://code.claude.com/docs/en/hooks](https://code.claude.com/docs/en/hooks)  
7. Chat Participant API \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/api/extension-guides/ai/chat](https://code.visualstudio.com/api/extension-guides/ai/chat)  
8. September 2024 (version 1.94) \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/updates/v1\_94](https://code.visualstudio.com/updates/v1_94)  
9. About GitHub Copilot coding agent, accessed January 19, 2026, [https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)  
10. Security \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/docs/copilot/security](https://code.visualstudio.com/docs/copilot/security)  
11. Extension runtime security \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/docs/configure/extensions/extension-runtime-security](https://code.visualstudio.com/docs/configure/extensions/extension-runtime-security)  
12. JSON-Agents/Standard: JSON Agents \- A universal JSON ... \- GitHub, accessed January 19, 2026, [https://github.com/JSON-AGENTS/Standard](https://github.com/JSON-AGENTS/Standard)  
13. Agent Definition Language: The open standard AI agents have been missing | We Love Open Source, accessed January 19, 2026, [https://allthingsopen.org/articles/agent-definition-language-open-standard-ai-agents](https://allthingsopen.org/articles/agent-definition-language-open-standard-ai-agents)  
14. Create custom subagents \- Claude Code Docs, accessed January 19, 2026, [https://code.claude.com/docs/en/sub-agents](https://code.claude.com/docs/en/sub-agents)  
15. October 2024 (version 1.95) \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/updates/v1\_95](https://code.visualstudio.com/updates/v1_95)  
16. Anthropic's Model Context Protocol (MCP): A Deep Dive for Developers \- Medium, accessed January 19, 2026, [https://medium.com/@amanatulla1606/anthropics-model-context-protocol-mcp-a-deep-dive-for-developers-1d3db39c9fdc](https://medium.com/@amanatulla1606/anthropics-model-context-protocol-mcp-a-deep-dive-for-developers-1d3db39c9fdc)  
17. Connect Claude Code to tools via MCP, accessed January 19, 2026, [https://code.claude.com/docs/en/mcp](https://code.claude.com/docs/en/mcp)  
18. Use MCP Servers \- Visual Studio (Windows) | Microsoft Learn, accessed January 19, 2026, [https://learn.microsoft.com/en-us/visualstudio/ide/mcp-servers?view=visualstudio](https://learn.microsoft.com/en-us/visualstudio/ide/mcp-servers?view=visualstudio)  
19. Model Context Protocol (MCP) is Now Generally Available in Visual Studio, accessed January 19, 2026, [https://devblogs.microsoft.com/visualstudio/mcp-is-now-generally-available-in-visual-studio/](https://devblogs.microsoft.com/visualstudio/mcp-is-now-generally-available-in-visual-studio/)  
20. Agent mode: available to all users and supports MCP \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/blogs/2025/04/07/agentMode](https://code.visualstudio.com/blogs/2025/04/07/agentMode)  
21. Language Model API \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/api/extension-guides/ai/language-model](https://code.visualstudio.com/api/extension-guides/ai/language-model)  
22. Tutorial: Generate AI-powered code annotations by using the Language Model API, accessed January 19, 2026, [https://code.visualstudio.com/api/extension-guides/ai/language-model-tutorial](https://code.visualstudio.com/api/extension-guides/ai/language-model-tutorial)  
23. Use MCP servers in VS Code, accessed January 19, 2026, [https://code.visualstudio.com/docs/copilot/customization/mcp-servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)  
24. VS Code API | Visual Studio Code Extension API, accessed January 19, 2026, [https://code.visualstudio.com/api/references/vscode-api](https://code.visualstudio.com/api/references/vscode-api)  
25. Tasks \- Theia IDE, accessed January 19, 2026, [https://theia-ide.org/docs/tasks/](https://theia-ide.org/docs/tasks/)  
26. Get started with Claude Code hooks, accessed January 19, 2026, [https://code.claude.com/docs/en/hooks-guide](https://code.claude.com/docs/en/hooks-guide)  
27. Language Model Chat Provider API \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/api/extension-guides/ai/language-model-chat-provider](https://code.visualstudio.com/api/extension-guides/ai/language-model-chat-provider)  
28. Build Your First Claude Code Agent Skill: A Simple Project Memory System That Saves Hours | by Rick Hightower \- Medium, accessed January 19, 2026, [https://medium.com/@richardhightower/build-your-first-claude-code-skill-a-simple-project-memory-system-that-saves-hours-1d13f21aff9e](https://medium.com/@richardhightower/build-your-first-claude-code-skill-a-simple-project-memory-system-that-saves-hours-1d13f21aff9e)  
29. Safeguarding VS Code against prompt injections \- The GitHub Blog, accessed January 19, 2026, [https://github.blog/security/vulnerability-research/safeguarding-vs-code-against-prompt-injections/](https://github.blog/security/vulnerability-research/safeguarding-vs-code-against-prompt-injections/)  
30. Workspace Trust \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/docs/editing/workspaces/workspace-trust](https://code.visualstudio.com/docs/editing/workspaces/workspace-trust)  
31. JSON-based Agents With Ollama & LangChain \- Neo4j, accessed January 19, 2026, [https://neo4j.com/blog/developer/json-agents-ollama-langchain/](https://neo4j.com/blog/developer/json-agents-ollama-langchain/)  
32. Introducing GitHub Copilot agent mode (preview) \- Visual Studio Code, accessed January 19, 2026, [https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode)