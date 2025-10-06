# MCP Server Setup Guide

## Prerequisites
- Node.js v18 or higher
- npm

## Installation

1. Install dependencies:
```bash
npm install
```

2. Build the project:
```bash
npm run build
```

## Claude Desktop Configuration

1. Open Claude Desktop config file:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`

2. Add your MCP server configuration:
```json
{
  "mcpServers": {
    "my_custom_mcp": {
      "command": "node",
      "args": [
        "/installed_folder/.mcp_server/dist/index.js"
      ]
    }
  }
}
```

3. Restart Claude Desktop

## Development

Run in development mode with auto-reload:
```bash
npm run dev
```

## Project Structure

- `src/` - TypeScript source files
- `dist/` - Compiled JavaScript files
- `package.json` - Project configuration
- `tsconfig.json` - TypeScript configuration