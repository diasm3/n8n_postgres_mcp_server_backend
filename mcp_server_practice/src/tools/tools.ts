import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { z } from "zod"

export function registerTools(server: McpServer) {
  // User Tools
  server.registerTool(
    "fetch-user",
    {
      title: "User Fetcher",
      description: "Get user data by ID",
      inputSchema: { id: z.string() },
      outputSchema: {
        id: z.string(),
        email: z.string(),
        password: z.string(),
        firstName: z.string(),
        lastName: z.string(),
        phoneNumber: z.string(),
        birthDate: z.string(),
        role: z.string(),
        isActive: z.boolean(),
        profileImageUrl: z.string().nullable(),
        preferences: z.object({
          language: z.string(),
          newsletter: z.boolean(),
          notifications: z.boolean(),
        }),
        address: z.object({
          city: z.string(),
          street: z.string(),
          zipCode: z.string(),
        }),
        loginCount: z.number(),
        lastLoginAt: z.string(),
        lastLoginIp: z.string(),
        metadata: z.object({
          source: z.string(),
          version: z.string(),
        }),
        createdAt: z.string(),
        updatedAt: z.string(),
      },
    },
    async ({ id }) => {
      const response = await fetch(`http://backend:3000/customer-users/${id}`)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  // Internal User Tools
  server.registerTool(
    "fetch-internal-user",
    {
      title: "Internal User Fetcher",
      description: "Get internal user (employee) data by ID",
      inputSchema: { id: z.string() },
    },
    async ({ id }) => {
      const response = await fetch(`http://backend:3000/internal-users/${id}`)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-internal-user-by-employee-id",
    {
      title: "Internal User Fetcher by Employee ID",
      description: "Get internal user by employee ID (e.g., CS-0001, DEV-0001)",
      inputSchema: { employeeId: z.string() },
    },
    async ({ employeeId }) => {
      const response = await fetch(
        `http://backend:3000/internal-users/employee/${employeeId}`
      )
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-all-internal-users",
    {
      title: "All Internal Users Fetcher",
      description:
        "Get all internal users with optional filters (department, role)",
      inputSchema: {
        department: z.string().optional(),
        role: z.string().optional(),
      },
    },
    async ({ department, role }) => {
      let url = "http://backend:3000/internal-users"
      const params = new URLSearchParams()
      if (department) params.append("department", department)
      if (role) params.append("role", role)
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-available-agents",
    {
      title: "Available CS Agents Fetcher",
      description: "Get all available CS agents sorted by workload",
      inputSchema: {},
    },
    async () => {
      const response = await fetch(
        "http://backend:3000/internal-users/available-agents"
      )
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  // User Log Tools
  server.registerTool(
    "fetch-user-logs",
    {
      title: "User Logs Fetcher",
      description: "Get user logs by user ID with pagination",
      inputSchema: {
        userId: z.string(),
        limit: z.number().optional(),
        offset: z.number().optional(),
      },
    },
    async ({ userId, limit, offset }) => {
      let url = `http://backend:3000/customer-user-logs/user/${userId}`
      const params = new URLSearchParams()
      if (limit) params.append("limit", limit.toString())
      if (offset) params.append("offset", offset.toString())
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-user-log-stats",
    {
      title: "User Log Statistics Fetcher",
      description: "Get user log statistics by user ID",
      inputSchema: { userId: z.string() },
    },
    async ({ userId }) => {
      const response = await fetch(
        `http://backend:3000/customer-user-logs/user/${userId}/stats`
      )
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-all-user-logs",
    {
      title: "All User Logs Fetcher",
      description: "Get all user logs with pagination",
      inputSchema: {
        limit: z.number().optional(),
        offset: z.number().optional(),
      },
    },
    async ({ limit, offset }) => {
      let url = "http://backend:3000/customer-user-logs"
      const params = new URLSearchParams()
      if (limit) params.append("limit", limit.toString())
      if (offset) params.append("offset", offset.toString())
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-logs-by-event-type",
    {
      title: "User Logs by Event Type Fetcher",
      description: "Get user logs by event type with pagination",
      inputSchema: {
        eventType: z.string(),
        limit: z.number().optional(),
        offset: z.number().optional(),
      },
    },
    async ({ eventType, limit, offset }) => {
      let url = `http://backend:3000/customer-user-logs/event/${eventType}`
      const params = new URLSearchParams()
      if (limit) params.append("limit", limit.toString())
      if (offset) params.append("offset", offset.toString())
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  // Complaint Tools
  server.registerTool(
    "fetch-all-complaints",
    {
      title: "All Complaints Fetcher",
      description: "Get all customer complaints with optional filters",
      inputSchema: {
        category: z.string().optional(),
        status: z.string().optional(),
        priority: z.string().optional(),
        assignedTo: z.string().optional(),
        limit: z.number().optional(),
        offset: z.number().optional(),
      },
    },
    async ({ category, status, priority, assignedTo, limit, offset }) => {
      let url = "http://backend:3000/complaints"
      const params = new URLSearchParams()
      if (category) params.append("category", category)
      if (status) params.append("status", status)
      if (priority) params.append("priority", priority)
      if (assignedTo) params.append("assignedTo", assignedTo)
      if (limit) params.append("limit", limit.toString())
      if (offset) params.append("offset", offset.toString())
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-complaint",
    {
      title: "Complaint Fetcher",
      description: "Get complaint by ID",
      inputSchema: { id: z.string() },
    },
    async ({ id }) => {
      const response = await fetch(`http://backend:3000/complaints/${id}`)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-complaint-by-ticket-number",
    {
      title: "Complaint Fetcher by Ticket Number",
      description: "Get complaint by ticket number (e.g., CS-2025-01-00001)",
      inputSchema: { ticketNumber: z.string() },
    },
    async ({ ticketNumber }) => {
      const response = await fetch(
        `http://backend:3000/complaints/ticket/${ticketNumber}`
      )
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-complaints-by-user",
    {
      title: "User Complaints Fetcher",
      description: "Get complaints by user ID",
      inputSchema: {
        userId: z.string(),
        limit: z.number().optional(),
        offset: z.number().optional(),
      },
    },
    async ({ userId, limit, offset }) => {
      let url = `http://backend:3000/complaints/user/${userId}`
      const params = new URLSearchParams()
      if (limit) params.append("limit", limit.toString())
      if (offset) params.append("offset", offset.toString())
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-complaints-by-category",
    {
      title: "Category Complaints Fetcher",
      description:
        "Get complaints by category ( ��, ���, 0�l�, etc.)",
      inputSchema: {
        category: z.string(),
        limit: z.number().optional(),
        offset: z.number().optional(),
      },
    },
    async ({ category, limit, offset }) => {
      let url = `http://backend:3000/complaints/category/${category}`
      const params = new URLSearchParams()
      if (limit) params.append("limit", limit.toString())
      if (offset) params.append("offset", offset.toString())
      if (params.toString()) url += `?${params.toString()}`

      const response = await fetch(url)
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-pending-complaints",
    {
      title: "Pending Complaints Fetcher",
      description: "Get all pending complaints (not resolved or closed)",
      inputSchema: {},
    },
    async () => {
      const response = await fetch("http://backend:3000/complaints/pending")
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-complaint-stats",
    {
      title: "Complaint Statistics Fetcher",
      description:
        "Get complaint statistics (total, by status, by category, by priority)",
      inputSchema: {},
    },
    async () => {
      const response = await fetch("http://backend:3000/complaints/stats")
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "fetch-complaint-responses",
    {
      title: "Complaint Responses Fetcher",
      description: "Get all responses for a complaint",
      inputSchema: { complaintId: z.string() },
    },
    async ({ complaintId }) => {
      const response = await fetch(
        `http://backend:3000/complaints/${complaintId}/responses`
      )
      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [{ type: "text", text: JSON.stringify(data) }],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "assign-complaint",
    {
      title: "Complaint Assigner",
      description: "Assign a complaint to an agent by complaint ID and agent ID",
      inputSchema: {
        complaintId: z.string().describe("The UUID of the complaint to assign"),
        agentId: z.string().describe("The UUID of the agent to assign the complaint to"),
        assignedTeam: z.string().optional().describe("The team name (e.g., 'CS 1팀', '기술 지원팀')"),
      },
    },
    async ({ complaintId, agentId, assignedTeam }) => {
      const updateData: Record<string, unknown> = {
        assignedTo: agentId,
        status: "처리중",
      }

      if (assignedTeam) {
        updateData.assignedTeam = assignedTeam
      }

      const response = await fetch(
        `http://backend:3000/complaints/${complaintId}`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(updateData),
        }
      )

      if (!response.ok) {
        const error = await response.text()
        throw new Error(`Failed to assign complaint: ${error}`)
      }

      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [
          {
            type: "text",
            text: `Successfully assigned complaint ${complaintId} to agent ${agentId}${assignedTeam ? ` (${assignedTeam})` : ""}. Status changed to '처리중'. Full data: ${JSON.stringify(data)}`,
          },
        ],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "update-complaint-jira-ticket",
    {
      title: "Update Complaint JIRA Ticket",
      description: "Update the JIRA ticket key for a complaint",
      inputSchema: {
        complaintId: z.string().describe("The UUID of the complaint to update"),
        jiraTicketKey: z.string().describe("The JIRA ticket key (e.g., 'JIRA-123', 'TECH-456')"),
      },
    },
    async ({ complaintId, jiraTicketKey }) => {
      const updateData = {
        jiraTicketKey: jiraTicketKey,
      }

      const response = await fetch(
        `http://backend:3000/complaints/${complaintId}`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(updateData),
        }
      )

      if (!response.ok) {
        const error = await response.text()
        throw new Error(`Failed to update JIRA ticket: ${error}`)
      }

      const data = (await response.json()) as Record<string, unknown>
      return {
        content: [
          {
            type: "text",
            text: `Successfully updated complaint ${complaintId} with JIRA ticket key: ${jiraTicketKey}. Full data: ${JSON.stringify(data)}`,
          },
        ],
        structuredContent: data,
      }
    }
  )

  server.registerTool(
    "update-complaint",
    {
      title: "Update Complaint",
      description: "Update complaint fields (status, priority, urgency, jiraTicketKey, etc.)",
      inputSchema: {
        complaintId: z.string().describe("The UUID of the complaint to update"),
        status: z.string().optional().describe("Status (접수, 처리중, 보류, 해결완료, 종료)"),
        priority: z.enum(["high", "medium", "low"]).optional().describe("Priority level"),
        urgency: z.enum(["urgent", "normal", "low"]).optional().describe("Urgency level"),
        jiraTicketKey: z.string().optional().describe("JIRA ticket key"),
        assignedTo: z.string().optional().describe("Agent UUID"),
        assignedTeam: z.string().optional().describe("Team name"),
        escalationLevel: z.number().optional().describe("Escalation level (1-4)"),
        isEscalated: z.boolean().optional().describe("Escalation flag"),
      },
    },
    async ({
      complaintId,
      status,
      priority,
      urgency,
      jiraTicketKey,
      assignedTo,
      assignedTeam,
      escalationLevel,
      isEscalated,
    }) => {
      const updateData: Record<string, unknown> = {}

      if (status) updateData.status = status
      if (priority) updateData.priority = priority
      if (urgency) updateData.urgency = urgency
      if (jiraTicketKey) updateData.jiraTicketKey = jiraTicketKey
      if (assignedTo) updateData.assignedTo = assignedTo
      if (assignedTeam) updateData.assignedTeam = assignedTeam
      if (escalationLevel !== undefined) updateData.escalationLevel = escalationLevel
      if (isEscalated !== undefined) updateData.isEscalated = isEscalated

      if (Object.keys(updateData).length === 0) {
        throw new Error("No fields provided to update")
      }

      const response = await fetch(
        `http://backend:3000/complaints/${complaintId}`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(updateData),
        }
      )

      if (!response.ok) {
        const error = await response.text()
        throw new Error(`Failed to update complaint: ${error}`)
      }

      const data = (await response.json()) as Record<string, unknown>

      const updatedFields = Object.keys(updateData).join(", ")
      return {
        content: [
          {
            type: "text",
            text: `Successfully updated complaint ${complaintId}. Updated fields: ${updatedFields}. Full data: ${JSON.stringify(data)}`,
          },
        ],
        structuredContent: data,
      }
    }
  )
}
