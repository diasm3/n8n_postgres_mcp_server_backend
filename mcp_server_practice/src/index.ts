import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js"
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import express from "express"
import { registerTools } from "./tools/tools.js"
import { registerPrompts } from "./tools/prompts.js"
import { registerResources } from "./tools/resources.js"

// Create an MCP server
const server = new McpServer({
  name: "junggo backend mcp server",
  version: "1.0.0",
})

// Register all tools, prompts, and resources
registerTools(server)
registerPrompts(server)
registerResources(server)

// Set up Express and HTTP transport
const app = express()

app.use(express.json())

app.post("/mcp", async (req, res) => {
  // Create a new transport for each request to prevent request ID collisions
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
    enableJsonResponse: true,
  })

  res.on("close", () => {
    transport.close()
  })

  await server.connect(transport)
  await transport.handleRequest(req, res, req.body)
})

const port = parseInt(process.env.PORT || "3000")
app
  .listen(port, () => {
    console.log(`Demo MCP Server running on http://localhost:${port}/mcp`)
  })
  .on("error", (error: Error) => {
    console.error("Server error:", error)
    process.exit(1)
  })
