import "dotenv/config"
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js"
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import express from "express"
import type { Request, Response, NextFunction } from "express"
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

// Authentication middleware
const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization

  if (!authHeader) {
    return res.status(401).json({ error: "Missing authorization header" })
  }

  // Bearer token format: "Bearer <token>"
  const token = authHeader.split(" ")[1]

  if (!token) {
    return res.status(401).json({ error: "Invalid authorization format" })
  }

  // Verify token against environment variable or your auth service
  const validToken = process.env.MCP_API_KEY

  if (!validToken) {
    console.error("MCP_API_KEY not set in environment variables")
    return res.status(500).json({ error: "Server configuration error" })
  }

  if (token !== validToken) {
    return res.status(403).json({ error: "Invalid or expired token" })
  }

  // Token is valid, proceed
  next()
}

app.post("/mcp", authMiddleware, async (req, res) => {
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

const port = parseInt(process.env.PORT || "3005")
app
  .listen(port, () => {
    console.log(`Demo MCP Server running on http://localhost:${port}/mcp`)
  })
  .on("error", (error: Error) => {
    console.error("Server error:", error)
    process.exit(1)
  })
