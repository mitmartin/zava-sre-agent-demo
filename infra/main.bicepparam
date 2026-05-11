using './main.bicep'

param location = 'swedencentral'
param resourceGroupName = 'rg-zava-aks-postgres'

// AZD sets AZURE_ENV_NAME automatically (e.g. 'zava-oneshot-1514'). Read it
// here so the per-env SRE Agent suffix is derivable at deployment-plan time.
// When deploying without azd (raw `az deployment sub create`), this falls back
// to '' and the agent name keeps its legacy `sre-agent-${uniqueSuffix}` shape.
param environmentName = readEnvironmentVariable('AZURE_ENV_NAME', '')

// Toggle the inline SRE Agent module. Defaults to true (matches upstream lab
// behavior). MCAPS sandbox tenants gate Microsoft.App/agents/{connectors,
// skills,incidentFilters} with "Agent Extensions are not available for this
// tenant" — set DEPLOY_SRE_AGENT=false in the azd env to deploy the app +
// observability alone, then enable an SRE Agent against them from a tenant
// where the feature flag is on.
param deploySreAgent = readEnvironmentVariable('DEPLOY_SRE_AGENT', 'true') == 'true'

// When the agent itself is deploying, separately decide whether to deploy its
// extensions (connectors, skills, incident filters). MCAPS sandbox tenants let
// the agent shell + RBAC deploy fine but block the extensions; setting
// DEPLOY_SRE_AGENT_EXTENSIONS=false on those subs gives you an empty agent
// shell that you can configure interactively from the SRE Agent portal.
param deploySreAgentExtensions = readEnvironmentVariable('DEPLOY_SRE_AGENT_EXTENSIONS', 'true') == 'true'
