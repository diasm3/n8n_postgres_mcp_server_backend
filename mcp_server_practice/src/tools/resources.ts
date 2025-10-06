import {
  McpServer,
  ResourceTemplate,
} from "@modelcontextprotocol/sdk/server/mcp.js"

export function registerResources(server: McpServer) {
  server.registerResource(
    "greeting",
    new ResourceTemplate("greeting://{name}", { list: undefined }),
    {
      title: "Greeting Resource",
      description: "Dynamic greeting generator",
    },
    async (uri, { name }) => ({
      contents: [
        {
          uri: uri.href,
          text: `Hello, ${name}!`,
        },
      ],
    })
  )
}
