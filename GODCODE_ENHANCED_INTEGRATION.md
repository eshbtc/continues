# GodCode Enhanced Integration: Model Registry + Cost Tracking + Presets

**Extension to the main integration plan focusing on GodCode's sophisticated model management system**

---

## GodCode's Superior Model Infrastructure

### 1. **Comprehensive Model Registry** (2136 lines!)

**What GodCode Has:**
```python
@dataclass
class ModelMetadata:
    provider: str                          # openai, anthropic, google, xai, etc.
    model_id: str                          # Internal identifier
    api_model_name: str                    # Actual API name
    display_name: str                      # User-friendly name
    
    # Capabilities
    capabilities: List[ModelCapability]    # VISION, TOOL_USE, REASONING, etc.
    supports_system_messages: bool
    supports_temperature: bool
    supports_streaming: bool
    
    # Limits
    limits: ModelLimits
      context_window: int                  # e.g., 128000
      max_output_tokens: int               # e.g., 16384
    
    # Costs (per 1M tokens!)
    costs: ModelCosts
      input: float                         # e.g., 3.0 = $3 per 1M tokens
      output: float                        # e.g., 15.0 = $15 per 1M tokens
      cache_read: Optional[float]          # e.g., 0.30 for cached reads
      cache_write: Optional[float]         # e.g., 3.75 for cache writes
    
    # Performance
    speed_tokens_per_sec: float            # e.g., 72.0 tokens/sec
    
    # Metadata
    status: "stable" | "beta" | "deprecated"
    release_date: str
    description: str
    recommended_for: List[str]             # ["coding", "debugging", "agents"]
    tags: List[str]                        # ["hybrid-reasoning", "premium"]
    alternate_sources: List[Dict]          # Fireworks, Cerebras alternatives
```

**Coverage:**
- **80+ models** across 15 providers
- **OpenAI**: GPT-4, GPT-5, o1, o3, o4, Codex, Image models
- **Anthropic**: Claude 3.7, 4, 4.5 (Sonnet, Opus, Haiku)
- **Google**: Gemini 2.5 Pro/Flash/Flash-Lite
- **xAI**: Grok 4 (LiveCodeBench leader at 79.4%!)
- **Chinese Models**: Kimi K2, GLM 4.6, Qwen3, DeepSeek, MiniMax
- **Meta**: Llama 4 Scout (10M context window!)
- **Fireworks**: Hosting service for many models

### 2. **Intelligent Preset System**

**What GodCode Has:**
```python
@dataclass
class Preset:
    name: str
    planner: str           # "provider:model_id"
    implementer: str       # "provider:model_id"
    reviewer: str          # "provider:model_id"
    backups: Dict[str, List[str]]  # Fallbacks per role!
    cost_sensitivity: str  # "low", "medium", "high"

PRESETS = {
    "preset_ultra_light": Preset(
        planner="moonshot:kimi-k2",          # $0.15/$2.5 per 1M
        implementer="openai:gpt-4o-mini",    # $0.15/$0.60 per 1M
        reviewer="xai:grok-4-fast",          # $0.20/$0.50 per 1M (2M context!)
        backups={
            "implementer": ["google:gemini-2.5-flash", "fireworks:qwen3-8b"]
        },
        cost_sensitivity="low"  # ~$0.50 per task
    ),
    
    "preset_flagship": Preset(
        planner="moonshot:kimi-k2",              # $0.15/$2.5 per 1M
        implementer="openai:gpt-5",              # $1.25/$10.0 per 1M
        reviewer="anthropic:claude-sonnet-4.5",  # $3.0/$15.0 per 1M
        backups={
            "implementer": ["anthropic:claude-sonnet-4.5", "openai:gpt-4.1"]
        },
        cost_sensitivity="high"  # ~$10+ per task
    ),
}
```

**Built-in Presets:**
1. `preset_ultra_light` - Cheap & fast (~$0.50/task)
2. `preset_reasoning` - Balanced (~$2/task)
3. `preset_flagship` - Premium quality (~$10/task)

### 3. **Real-Time Cost Tracking with Streaming**

**What GodCode Has:**
```python
class CostTrackingTools:
    """
    Complete cost tracking solution
    
    Features:
    - Real-time cost calculation (Decimal precision)
    - Budget enforcement (user + workspace level)
    - Cost analytics and reporting
    - Budget alerts with notifications
    - Multi-provider pricing management
    - In-memory pricing cache (1-hour refresh)
    - Fuzzy model name matching
    - Historical cost analysis
    """
    
    async def calculate_cost(
        self,
        provider: str,
        model: str,
        input_tokens: int,
        output_tokens: int,
        cached_tokens: int = 0,
    ) -> Decimal:
        """Calculate cost with exact Decimal precision"""
        
    async def track_llm_call(
        self,
        user_id: str,
        workspace_id: str,
        provider: str,
        model: str,
        input_tokens: int,
        output_tokens: int,
        cached_tokens: int = 0,
    ) -> ToolResult:
        """Track a single LLM call and update budgets"""
        
    async def stream_cost_update(
        self,
        session_id: str,
        cost_delta: Decimal,
    ) -> None:
        """Stream cost updates to UI in real-time"""
        
    async def get_user_costs(
        self,
        user_id: str,
        start_date: date,
        end_date: date,
    ) -> Dict[str, Any]:
        """Get historical cost analysis"""
```

**Database Schema:**
```sql
CREATE TABLE llm_api_calls (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    workspace_id VARCHAR(255),
    session_id VARCHAR(255),
    provider VARCHAR(100),
    model_name VARCHAR(255),
    input_tokens INTEGER,
    output_tokens INTEGER,
    cached_tokens INTEGER DEFAULT 0,
    cost DECIMAL(12, 6),
    timestamp TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_budgets (
    user_id VARCHAR(255) PRIMARY KEY,
    total_budget DECIMAL(12, 2),
    remaining_budget DECIMAL(12, 2),
    reset_period VARCHAR(20),
    last_reset_date DATE
);

CREATE TABLE workspace_budgets (
    workspace_id VARCHAR(255) PRIMARY KEY,
    total_budget DECIMAL(12, 2),
    remaining_budget DECIMAL(12, 2),
    alert_threshold DECIMAL(5, 2)
);

CREATE TABLE daily_cost_summaries (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    workspace_id VARCHAR(255),
    date DATE,
    total_cost DECIMAL(12, 6),
    total_calls INTEGER,
    UNIQUE(user_id, workspace_id, date)
);
```

### 4. **Automated Pricing Scraper**

**What GodCode Has:**
```python
#!/usr/bin/env python3
"""
Daily pricing scraper for LLM providers

Features:
- Scrapes OpenAI, Anthropic, Google, xAI pricing pages
- Handles JavaScript-rendered pages (Playwright)
- Normalizes to USD per 1M tokens
- Fuzzy model name matching
- Automatic database updates
- Backup to JSON for version control
"""

def fetch_rendered(url: str, wait_selector: str) -> str:
    """Use Playwright to render JS pricing pages"""
    
def scrape_openai_pricing() -> List[PricingEntry]:
    """Scrape OpenAI pricing page"""
    
def scrape_anthropic_pricing() -> List[PricingEntry]:
    """Scrape Anthropic pricing page"""
    
def update_database(entries: List[PricingEntry]) -> None:
    """Update model_pricing table with new data"""

# Run daily via cron:
# 0 2 * * * python scripts/pricing_scraper.py --persist
```

**Pricing Schema:**
```sql
CREATE TABLE model_pricing (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(100) NOT NULL,
    model_name VARCHAR(255) NOT NULL,
    input_price_per_1m DECIMAL(12, 6),
    output_price_per_1m DECIMAL(12, 6),
    cache_read_price_per_1m DECIMAL(12, 6),
    cache_write_price_per_1m DECIMAL(12, 6),
    effective_date DATE,
    end_date DATE,
    source_url TEXT,
    scraped_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(provider, model_name, effective_date)
);
```

### 5. **Profile System with Auto-Loading**

**What GodCode Has:**
```python
class ProfileLoader:
    """
    Load configuration profiles from YAML
    
    Features:
    - Load presets from codeact_models.yaml
    - Extract metadata (cost tier, speed tier, use case)
    - Merge into WorkflowConfig
    - Support custom user profiles
    """
    
    def list_profiles(self) -> List[str]:
        """List all available profiles"""
        
    def get_profile(self, name: str) -> Dict[str, Any]:
        """Get specific profile configuration"""
        
    def load_as_workflow_config(self, name: str) -> WorkflowConfig:
        """Load profile as WorkflowConfig for orchestrator"""
```

**Config File** (`codeact_models.yaml`):
```yaml
preset_ultra_light:
  planner_config:
    provider: "moonshot"
    model: "kimi-k2"
    temperature: 0.6
  implementer_config:
    provider: "openai"
    model: "gpt-4o-mini"
    temperature: 0.3
  reviewer_config:
    provider: "xai"
    model: "grok-4-fast"
    temperature: 0.4
  cost_sensitivity: "low"
  
preset_flagship:
  planner_config:
    provider: "moonshot"
    model: "kimi-k2"
    temperature: 0.6
  implementer_config:
    provider: "openai"
    model: "gpt-5"
    temperature: 0.3
  reviewer_config:
    provider: "anthropic"
    model: "claude-sonnet-4.5"
    temperature: 0.4
  cost_sensitivity: "high"
  role_backups:
    implementer: ["anthropic:claude-sonnet-4.5", "openai:gpt-4.1"]
```

---

## Integration Plan: Port to Continue

### Phase 1: Model Registry (Week 1)

**File**: `core/models/ModelRegistry.ts`

```typescript
export enum ModelCapability {
  VISION = "vision",
  TOOL_USE = "tool_use",
  REASONING = "reasoning",
  AUDIO = "audio",
  CODE_GENERATION = "code_generation",
  FUNCTION_CALLING = "function_calling",
  JSON_MODE = "json_mode",
}

export interface ModelLimits {
  contextWindow: number;
  maxOutputTokens: number;
  maxInputTokens?: number;
}

export interface ModelCosts {
  input: number;        // USD per 1M tokens
  output: number;       // USD per 1M tokens
  cacheRead?: number;   // USD per 1M cached tokens
  cacheWrite?: number;  // USD per 1M cache writes
}

export interface ModelMetadata {
  // Identification
  provider: string;
  modelId: string;
  apiModelName: string;
  displayName: string;
  
  // Capabilities
  capabilities: ModelCapability[];
  supportsSystemMessages: boolean;
  supportsTemperature: boolean;
  supportsStreaming: boolean;
  
  // Limits
  limits: ModelLimits;
  
  // Costs
  costs: ModelCosts;
  
  // Performance
  speedTokensPerSec?: number;
  
  // Status
  status: "stable" | "beta" | "alpha" | "deprecated";
  releaseDate?: string;
  deprecationDate?: string;
  
  // Metadata
  description?: string;
  recommendedFor: string[];
  tags: string[];
  alternateSources?: Array<{provider: string; modelId: string}>;
}

export class ModelRegistry {
  private static instance: ModelRegistry;
  private models: Map<string, Map<string, ModelMetadata>>;
  
  private constructor() {
    this.models = new Map();
    this.loadDefaultModels();
  }
  
  static getInstance(): ModelRegistry {
    if (!ModelRegistry.instance) {
      ModelRegistry.instance = new ModelRegistry();
    }
    return ModelRegistry.instance;
  }
  
  private loadDefaultModels() {
    // Port GodCode's model_registry.py data
    this.registerModel({
      provider: "anthropic",
      modelId: "claude-sonnet-4.5",
      apiModelName: "claude-sonnet-4-5-20250929",
      displayName: "Claude Sonnet 4.5",
      capabilities: [
        ModelCapability.VISION,
        ModelCapability.TOOL_USE,
        ModelCapability.CODE_GENERATION,
        ModelCapability.REASONING,
      ],
      limits: {
        contextWindow: 200000,
        maxOutputTokens: 64000,
      },
      costs: {
        input: 3.0,
        output: 15.0,
        cacheRead: 0.30,
        cacheWrite: 3.75,
      },
      speedTokensPerSec: 72.0,
      status: "stable",
      releaseDate: "2025-09-29",
      description: "Hybrid reasoning, repo-level reliability, SWE-bench 77%+",
      recommendedFor: ["coding", "debugging", "autonomous agents", "review"],
      tags: ["hybrid-reasoning", "claude4.5", "premium"],
    });
    
    // Register 80+ more models from GodCode registry...
  }
  
  getModel(provider: string, modelId: string): ModelMetadata | undefined {
    return this.models.get(provider)?.get(modelId);
  }
  
  listProviders(): string[] {
    return Array.from(this.models.keys());
  }
  
  listProviderModels(provider: string): ModelMetadata[] {
    const providerModels = this.models.get(provider);
    return providerModels ? Array.from(providerModels.values()) : [];
  }
  
  findModels(criteria: {
    hasCapability?: ModelCapability;
    maxCostPerMillion?: number;
    minSpeed?: number;
    status?: string[];
    tags?: string[];
  }): ModelMetadata[] {
    const allModels = this.listAllModels();
    
    return allModels.filter(model => {
      if (criteria.hasCapability && 
          !model.capabilities.includes(criteria.hasCapability)) {
        return false;
      }
      
      if (criteria.maxCostPerMillion && 
          model.costs.output > criteria.maxCostPerMillion) {
        return false;
      }
      
      if (criteria.minSpeed && 
          model.speedTokensPerSec && 
          model.speedTokensPerSec < criteria.minSpeed) {
        return false;
      }
      
      if (criteria.status && 
          !criteria.status.includes(model.status)) {
        return false;
      }
      
      if (criteria.tags && 
          !criteria.tags.some(tag => model.tags.includes(tag))) {
        return false;
      }
      
      return true;
    });
  }
  
  listAllModels(): ModelMetadata[] {
    const allModels: ModelMetadata[] = [];
    for (const providerModels of this.models.values()) {
      allModels.push(...providerModels.values());
    }
    return allModels;
  }
  
  registerModel(metadata: ModelMetadata) {
    if (!this.models.has(metadata.provider)) {
      this.models.set(metadata.provider, new Map());
    }
    this.models.get(metadata.provider)!.set(metadata.modelId, metadata);
  }
}
```

### Phase 2: Preset System (Week 1)

**File**: `core/models/ModelPresets.ts`

```typescript
export interface ModelPreset {
  name: string;
  planner: string;      // "provider:modelId"
  implementer: string;
  reviewer: string;
  debugger?: string;
  backups?: {
    [role: string]: string[];  // Role -> fallback models
  };
  costSensitivity: "low" | "medium" | "high";
}

export class ModelPresetManager {
  private presets: Map<string, ModelPreset>;
  
  constructor() {
    this.presets = new Map();
    this.loadBuiltInPresets();
  }
  
  private loadBuiltInPresets() {
    // Port GodCode's PRESETS
    this.registerPreset({
      name: "preset_ultra_light",
      planner: "moonshot:kimi-k2",
      implementer: "openai:gpt-4o-mini",
      reviewer: "xai:grok-4-fast",
      backups: {
        planner: ["fireworks:deepseek-v3.1"],
        implementer: [
          "fireworks:qwen3-8b",
          "google:gemini-2.5-flash"
        ],
        reviewer: ["fireworks:qwen3-8b", "xai:grok-4"],
      },
      costSensitivity: "low",
    });
    
    this.registerPreset({
      name: "preset_reasoning",
      planner: "moonshot:kimi-k2",
      implementer: "anthropic:claude-haiku-4.5",
      reviewer: "openai:gpt-4.1-mini",
      backups: {
        planner: ["openai:gpt-4.1-mini"],
        implementer: [
          "fireworks:deepseek-v3.1",
          "fireworks:qwen3-235b-instruct"
        ],
        reviewer: ["xai:grok-4", "fireworks:qwen3-8b"],
      },
      costSensitivity: "medium",
    });
    
    this.registerPreset({
      name: "preset_flagship",
      planner: "moonshot:kimi-k2",
      implementer: "openai:gpt-5",
      reviewer: "anthropic:claude-sonnet-4.5",
      backups: {
        planner: ["openai:gpt-4.1"],
        implementer: [
          "anthropic:claude-sonnet-4.5",
          "openai:gpt-4.1"
        ],
        reviewer: ["openai:gpt-4.1", "openai:gpt-4o"],
      },
      costSensitivity: "high",
    });
  }
  
  getPreset(name: string): ModelPreset | undefined {
    return this.presets.get(name);
  }
  
  listPresets(): string[] {
    return Array.from(this.presets.keys());
  }
  
  registerPreset(preset: ModelPreset) {
    this.presets.set(preset.name, preset);
  }
  
  // Parse "provider:modelId" format
  parseModelString(modelStr: string): {provider: string; modelId: string} {
    const [provider, modelId] = modelStr.split(":");
    return { provider, modelId };
  }
  
  // Get LLMS instance for a role from a preset
  async getModelForRole(
    presetName: string,
    role: "planner" | "implementer" | "reviewer" | "debugger",
    configHandler: ConfigHandler,
  ): Promise<LLMS | undefined> {
    const preset = this.getPreset(presetName);
    if (!preset) return undefined;
    
    const modelStr = preset[role];
    if (!modelStr) return undefined;
    
    const { provider, modelId } = this.parseModelString(modelStr);
    
    // Try to get model from config
    const { config } = await configHandler.loadConfig();
    if (!config) return undefined;
    
    // Find model in config by provider and ID
    const model = config.models?.find(
      m => m.provider === provider && 
           (m.model === modelId || m.title.includes(modelId))
    );
    
    return model;
  }
}
```

### Phase 3: Cost Tracking (Week 2)

**File**: `core/costs/CostTracker.ts`

```typescript
import { ModelRegistry } from "../models/ModelRegistry";

export interface CostCalculation {
  inputCost: number;
  outputCost: number;
  cacheCost: number;
  totalCost: number;
  currency: "USD";
}

export interface LLMCallRecord {
  id: string;
  userId: string;
  workspaceId: string;
  sessionId: string;
  provider: string;
  model: string;
  inputTokens: number;
  outputTokens: number;
  cachedTokens: number;
  cost: number;
  timestamp: Date;
}

export class CostTracker {
  private static instance: CostTracker;
  private registry: ModelRegistry;
  private db: any; // SQLite or DevDataSqliteDb
  
  private constructor() {
    this.registry = ModelRegistry.getInstance();
  }
  
  static getInstance(): CostTracker {
    if (!CostTracker.instance) {
      CostTracker.instance = new CostTracker();
    }
    return CostTracker.instance;
  }
  
  async initialize(dbPath: string) {
    // Initialize SQLite database
    // Create tables: llm_api_calls, user_budgets, workspace_budgets, daily_cost_summaries
  }
  
  calculateCost(
    provider: string,
    model: string,
    inputTokens: number,
    outputTokens: number,
    cachedTokens: number = 0,
  ): CostCalculation {
    const metadata = this.registry.getModel(provider, model);
    
    if (!metadata) {
      console.warn(`Model not found in registry: ${provider}:${model}`);
      return {
        inputCost: 0,
        outputCost: 0,
        cacheCost: 0,
        totalCost: 0,
        currency: "USD",
      };
    }
    
    const inputCost = (inputTokens / 1_000_000) * metadata.costs.input;
    const outputCost = (outputTokens / 1_000_000) * metadata.costs.output;
    const cacheCost = metadata.costs.cacheRead
      ? (cachedTokens / 1_000_000) * metadata.costs.cacheRead
      : 0;
    
    return {
      inputCost,
      outputCost,
      cacheCost,
      totalCost: inputCost + outputCost + cacheCost,
      currency: "USD",
    };
  }
  
  async trackLLMCall(
    userId: string,
    workspaceId: string,
    sessionId: string,
    provider: string,
    model: string,
    inputTokens: number,
    outputTokens: number,
    cachedTokens: number = 0,
  ): Promise<LLMCallRecord> {
    const cost = this.calculateCost(
      provider,
      model,
      inputTokens,
      outputTokens,
      cachedTokens,
    );
    
    const record: LLMCallRecord = {
      id: uuidv4(),
      userId,
      workspaceId,
      sessionId,
      provider,
      model,
      inputTokens,
      outputTokens,
      cachedTokens,
      cost: cost.totalCost,
      timestamp: new Date(),
    };
    
    // Insert into database
    await this.db.insert("llm_api_calls", record);
    
    // Update daily summary
    await this.updateDailySummary(userId, workspaceId, cost.totalCost);
    
    // Check budget
    await this.checkBudget(userId, workspaceId);
    
    return record;
  }
  
  async getUserCosts(
    userId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<{
    totalCost: number;
    totalCalls: number;
    breakdown: Array<{
      provider: string;
      model: string;
      calls: number;
      cost: number;
    }>;
  }> {
    // Query database for cost analysis
  }
  
  async getWorkspaceCosts(
    workspaceId: string,
    startDate: Date,
    endDate: Date,
  ): Promise<any> {
    // Similar to getUserCosts
  }
  
  async streamCostUpdate(
    sessionId: string,
    costDelta: number,
    messenger: IMessenger,
  ) {
    // Stream cost updates to UI
    messenger.send("costUpdate", {
      sessionId,
      delta: costDelta,
      timestamp: new Date().toISOString(),
    });
  }
  
  private async updateDailySummary(
    userId: string,
    workspaceId: string,
    cost: number,
  ) {
    const today = new Date().toISOString().split("T")[0];
    
    await this.db.upsert("daily_cost_summaries", {
      userId,
      workspaceId,
      date: today,
      totalCost: cost,
      totalCalls: 1,
    });
  }
  
  private async checkBudget(userId: string, workspaceId: string) {
    // Check if user/workspace has exceeded budget
    // Send alert if needed
  }
}
```

### Phase 4: Integration with Multi-Agent System (Week 2)

**File**: `core/orchestrator/CodeActOrchestrator.ts` (enhanced)

```typescript
export class CodeActOrchestrator {
  private agentFactory: AgentFactory;
  private presetManager: ModelPresetManager;
  private costTracker: CostTracker;
  
  constructor(
    private configHandler: ConfigHandler,
    private ide: IDE,
    private messenger: IMessenger,
  ) {
    this.agentFactory = new AgentFactory(configHandler);
    this.presetManager = new ModelPresetManager();
    this.costTracker = CostTracker.getInstance();
  }
  
  async executeTask(
    task: string,
    options: OrchestrationOptions = {},
  ): Promise<OrchestrationResult> {
    // Get preset if specified
    const preset = options.preset 
      ? this.presetManager.getPreset(options.preset)
      : undefined;
    
    // Create agents with preset models
    const planner = preset
      ? await this.createAgentFromPreset(preset, "planner")
      : await this.agentFactory.createAgent(AgentRole.PLANNER);
    
    const implementer = preset
      ? await this.createAgentFromPreset(preset, "implementer")
      : await this.agentFactory.createAgent(AgentRole.IMPLEMENTER);
    
    const reviewer = preset
      ? await this.createAgentFromPreset(preset, "reviewer")
      : await this.agentFactory.createAgent(AgentRole.REVIEWER);
    
    // Execute with cost tracking
    const sessionId = uuidv4();
    const startTime = Date.now();
    
    try {
      // Planning phase
      const planResponse = await planner.execute(context);
      await this.trackAgentCost(sessionId, "planner", planResponse);
      
      // Implementation phase
      const implResponse = await implementer.execute(context);
      await this.trackAgentCost(sessionId, "implementer", implResponse);
      
      // Review phase
      const reviewResponse = await reviewer.execute(context);
      await this.trackAgentCost(sessionId, "reviewer", reviewResponse);
      
      const totalCost = await this.getSessionCost(sessionId);
      
      return {
        success: true,
        plan: planResponse,
        implementation: implResponse,
        review: reviewResponse,
        totalCost,
        duration: Date.now() - startTime,
      };
      
    } catch (error) {
      // Track error and costs
      throw error;
    }
  }
  
  private async createAgentFromPreset(
    preset: ModelPreset,
    role: "planner" | "implementer" | "reviewer",
  ): Promise<Agent> {
    const model = await this.presetManager.getModelForRole(
      preset.name,
      role,
      this.configHandler,
    );
    
    if (!model) {
      // Try backup models
      const backups = preset.backups?.[role] || [];
      for (const backupStr of backups) {
        const { provider, modelId } = this.presetManager.parseModelString(backupStr);
        const backupModel = this.registry.getModel(provider, modelId);
        if (backupModel) {
          return this.agentFactory.createAgent(role as AgentRole, backupModel);
        }
      }
      
      throw new Error(`No model available for role: ${role}`);
    }
    
    return this.agentFactory.createAgent(role as AgentRole, model);
  }
  
  private async trackAgentCost(
    sessionId: string,
    role: string,
    response: AgentResponse,
  ) {
    await this.costTracker.trackLLMCall(
      "current_user",
      "current_workspace",
      sessionId,
      response.model.provider,
      response.model.model,
      response.inputTokens,
      response.outputTokens,
      response.cachedTokens,
    );
    
    // Stream cost update to UI
    const cost = this.costTracker.calculateCost(
      response.model.provider,
      response.model.model,
      response.inputTokens,
      response.outputTokens,
      response.cachedTokens,
    );
    
    await this.costTracker.streamCostUpdate(
      sessionId,
      cost.totalCost,
      this.messenger,
    );
  }
  
  private async getSessionCost(sessionId: string): Promise<number> {
    // Query database for total session cost
    return 0; // TODO
  }
}
```

### Phase 5: UI Integration (Week 3)

**Protocol Messages** (`core/protocol/core.ts`):

```typescript
export interface ToCoreProtocol {
  // ... existing messages
  
  // Model registry
  "models/list": [{ provider?: string }, ModelMetadata[]];
  "models/search": [
    {
      hasCapability?: string;
      maxCost?: number;
      minSpeed?: number;
    },
    ModelMetadata[]
  ];
  
  // Presets
  "presets/list": [void, string[]];
  "presets/get": [{ name: string }, ModelPreset];
  
  // Cost tracking
  "costs/session": [{ sessionId: string }, number];
  "costs/user": [
    { startDate: string; endDate: string },
    { totalCost: number; breakdown: any[] }
  ];
}

export interface FromCoreProtocol {
  // ... existing messages
  
  // Real-time cost updates
  costUpdate: [
    {
      sessionId: string;
      delta: number;
      total: number;
      timestamp: string;
    },
    void
  ];
  
  // Budget alerts
  budgetAlert: [
    {
      userId: string;
      remaining: number;
      threshold: number;
    },
    void
  ];
}
```

**VS Code Extension UI**:

```typescript
// extensions/vscode/src/CostTrackingPanel.tsx

export function CostTrackingPanel() {
  const [sessionCost, setSessionCost] = useState(0);
  const [totalCost, setTotalCost] = useState(0);
  
  useEffect(() => {
    // Listen for cost updates
    const listener = messenger.on("costUpdate", (data) => {
      setSessionCost(prev => prev + data.delta);
    });
    
    return () => listener.dispose();
  }, []);
  
  return (
    <div className="cost-tracking">
      <h3>Cost Tracking</h3>
      <div className="session-cost">
        Session: ${sessionCost.toFixed(4)}
      </div>
      <div className="total-cost">
        Total Today: ${totalCost.toFixed(2)}
      </div>
    </div>
  );
}
```

---

## Configuration Example

**`~/.continue/config.json`**:

```json
{
  "experimental": {
    "multiAgentMode": true,
    "costTracking": true,
    "modelRegistry": true
  },
  
  "multiAgentMode": {
    "enabled": true,
    "preset": "preset_reasoning",
    
    "costTracking": {
      "enabled": true,
      "database": "~/.continue/costs.db",
      "streamUpdates": true,
      "budgets": {
        "daily": 10.0,
        "monthly": 100.0,
        "alertThreshold": 0.8
      }
    }
  }
}
```

---

## Benefits of This Integration

### 1. **80+ Models Instantly Available**
- OpenAI, Anthropic, Google, xAI, Chinese models
- Comprehensive metadata (costs, limits, capabilities)
- Automatic fallbacks per role

### 2. **Smart Cost Management**
- Real-time tracking with streaming updates
- Budget enforcement (prevent overspending)
- Historical analytics
- Per-agent cost breakdown

### 3. **Intelligent Presets**
- `ultra_light`: ~$0.50/task (dev testing)
- `reasoning`: ~$2/task (production)
- `flagship`: ~$10/task (critical tasks)

### 4. **Automatic Pricing Updates**
- Daily scraper keeps prices current
- No manual config updates needed
- Version controlled pricing history

### 5. **Provider Flexibility**
- Mix any models: GPT-4 + Claude + Gemini + Grok
- Automatic fallbacks if primary fails
- Support for Fireworks/Cerebras alternatives

### 6. **Performance Tracking**
- Token speed metrics (72 tokens/sec for Claude 4.5)
- Model comparison for same task
- ROI analysis (cost vs quality)

---

## Migration Path

### Week 1: Core Infrastructure
- Port ModelRegistry (Day 1-2)
- Port ModelPresetManager (Day 3)
- Create database schema (Day 4-5)

### Week 2: Cost Tracking
- Port CostTracker (Day 1-2)
- Integrate with orchestrator (Day 3-4)
- Add streaming updates (Day 5)

### Week 3: UI & Polish
- Add UI panels for costs (Day 1-2)
- Add preset selector (Day 3)
- Testing & documentation (Day 4-5)

### Week 4: Pricing Scraper
- Port scraper script (Day 1-2)
- Set up cron job (Day 3)
- Create admin dashboard (Day 4-5)

---

## Success Metrics

### Cost Savings
- **Preset Selection**: 5-10x cost variation per task
- **Budget Enforcement**: Prevent runaway costs
- **Model Fallbacks**: Use cheaper alternatives when possible

### Transparency
- **Real-time Tracking**: See costs as they happen
- **Historical Analysis**: Understand spending patterns
- **Per-Agent Breakdown**: Identify expensive operations

### Flexibility
- **80+ Models**: Choose best model per role
- **Smart Fallbacks**: Never blocked by rate limits
- **Provider Diversity**: Not locked to single vendor

---

## Summary

GodCode's model infrastructure is **production-grade**:

✅ **80+ models** from 15 providers  
✅ **Complete metadata** (costs, limits, capabilities, performance)  
✅ **Smart presets** with cost-aware configurations  
✅ **Real-time cost tracking** with streaming to UI  
✅ **Automated pricing scraper** keeps data current  
✅ **Budget enforcement** prevents overspending  
✅ **Fuzzy matching** handles model name variations  
✅ **Fallback chains** ensure reliability  

Porting this to Continue will give it **best-in-class model management** far beyond any other IDE extension!
