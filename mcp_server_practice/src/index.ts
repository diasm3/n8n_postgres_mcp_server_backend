import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js"
import {
  McpServer,
  ResourceTemplate,
} from "@modelcontextprotocol/sdk/server/mcp.js"
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js"
import { z } from "zod"
import express, { type Request, type Response } from "express"

// Create an MCP server
const server = new McpServer({
  name: "junggo backend mcp server",
  version: "1.0.0",
})

// Add an addition tool

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
    const response = await fetch(`http://backend:3000/users/${id}`)
    const data = (await response.json()) as Record<string, unknown>
    console.log(data)
    return {
      content: [{ type: "text", text: JSON.stringify(data) }],
      structuredContent: data,
    }
  }
)

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
    let url = `http://backend:3000/user-logs/user/${userId}`
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
      `http://backend:3000/user-logs/user/${userId}/stats`
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
    let url = "http://backend:3000/user-logs"
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
    let url = `http://backend:3000/user-logs/event/${eventType}`
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
      "Get complaints by category (가격정보, 상품정보, 배송구매, etc.)",
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

// Add prompts
server.registerPrompt(
  "process-complaint",
  {
    title: "Complaint Processing Assistant",
    description: "컴플레인 처리 프로세스를 단계별로 안내하고 분석합니다",
    argsSchema: {
      complaintId: z.string().describe("처리할 컴플레인의 ID"),
    },
  },
  async ({ complaintId }) => {
    return {
      messages: [
        {
          role: "user",
          content: {
            type: "text",
            text: `컴플레인 ID ${complaintId}에 대한 처리를 도와주세요.

다음 단계를 순차적으로 진행해주세요:

## 1단계: 컴플레인 상세 정보 조회
- fetch-complaint tool을 사용하여 컴플레인 전체 정보를 가져옵니다
- 티켓 번호, 고객 정보, 카테고리, 우선순위, 현재 상태를 확인합니다
- 관련 상품/주문/판매자 정보가 있는지 확인합니다

## 2단계: 사용자 로그 확인
- 컴플레인에 연결된 userId가 있다면 fetch-user-logs tool을 사용하여 최근 활동을 확인합니다
- 사용자의 최근 행동 패턴을 파악합니다 (로그인, 주문, 문의 등)
- 이전에도 유사한 문제가 있었는지 확인합니다

## 3단계: 처리 과정 확인
- fetch-complaint-responses tool을 사용하여 현재까지의 응답 이력을 확인합니다
- 담당자가 할당되었는지, 언제 첫 응답이 있었는지 확인합니다
- 에스컬레이션 레벨과 현재 진행 상태를 분석합니다
- SLA 준수 여부를 확인합니다 (첫 응답 24시간 이내)

## 4단계: 템플릿 확인 및 적용
- category와 subCategory를 기반으로 적절한 응답 템플릿이 있는지 확인합니다
- 컴플레인 내용(subject, description)을 분석하여 가장 적합한 템플릿을 찾습니다
- 템플릿이 있다면 고객에게 보낼 응답 초안을 작성합니다

## 5단계: 에스컬레이션 필요 여부 판단
템플릿이 없거나 다음 조건에 해당하면 에스컬레이션이 필요합니다:
- priority가 'high'인 경우
- 처리 시간이 오래 걸린 경우
- 기술적 이슈가 복잡한 경우
- 보상이 필요한 경우

에스컬레이션이 필요하다면:
- fetch-available-agents tool로 현재 업무 가능한 담당자를 확인합니다
- 적절한 팀과 담당자를 추천합니다
- JIRA 티켓 생성이 필요한지 판단합니다

## 6단계: 처리 권고사항 제시
위 분석을 바탕으로:
- 즉시 처리 가능한지, 에스컬레이션이 필요한지 판단
- 예상 처리 시간
- 고객에게 보낼 응답 초안
- 필요한 보상 조치 (있다면)
- 다음 액션 아이템

각 단계의 결과를 명확하게 정리하여 보고해주세요.`,
          },
        },
      ],
    }
  }
)

server.registerPrompt(
  "analyze-complaint-trend",
  {
    title: "Complaint Trend Analyzer",
    description: "컴플레인 트렌드를 분석하고 인사이트를 제공합니다",
    argsSchema: {
      category: z.string().optional().describe("특정 카테고리 분석 (선택)"),
      days: z.string().optional().describe("분석할 일수 (기본: 7일)"),
    },
  },
  async ({ category, days = "7" }) => {
    const categoryFilter = category ? ` (카테고리: ${category})` : ""
    return {
      messages: [
        {
          role: "user",
          content: {
            type: "text",
            text: `최근 ${days}일간의 컴플레인 트렌드를 분석해주세요${categoryFilter}.

## 분석 단계:

### 1. 전체 통계 확인
- fetch-complaint-stats tool을 사용하여 전체 통계를 가져옵니다
- 총 컴플레인 수, 상태별 분포, 카테고리별 분포, 우선순위별 분포를 확인합니다

### 2. 미처리 컴플레인 분석
- fetch-pending-complaints tool을 사용하여 미처리 컴플레인을 확인합니다
- 가장 오래된 미처리 건은 언제부터인지 확인합니다
- 우선순위가 높은 미처리 건이 있는지 확인합니다

### 3. 카테고리별 상세 분석
${
  category
    ? `- fetch-complaints-by-category tool로 ${category} 카테고리의 컴플레인들을 분석합니다`
    : "- 각 주요 카테고리(가격정보, 상품정보, 배송구매, 리뷰평점, 회원개인정보, 시스템기술)별로 컴플레인 수를 확인합니다"
}
- 어떤 카테고리에 문제가 집중되어 있는지 파악합니다
- 반복되는 이슈 패턴을 찾습니다

### 4. 처리 효율성 분석
- 평균 응답 시간과 해결 시간을 계산합니다
- SLA 준수율을 확인합니다
- 담당자별 처리 현황을 파악합니다 (가능한 경우)

### 5. 인사이트 및 권고사항
분석 결과를 바탕으로:
- 주요 문제점 3가지
- 개선이 필요한 영역
- 우선적으로 처리해야 할 항목
- 프로세스 개선 제안

각 분석 결과를 구체적인 수치와 함께 정리해주세요.`,
          },
        },
      ],
    }
  }
)

server.registerPrompt(
  "assign-complaint-to-agent",
  {
    title: "Complaint Assignment Assistant",
    description: "컴플레인을 적절한 담당자에게 할당하는 것을 돕습니다",
    argsSchema: {
      complaintId: z.string().describe("할당할 컴플레인의 ID"),
    },
  },
  async ({ complaintId }) => {
    return {
      messages: [
        {
          role: "user",
          content: {
            type: "text",
            text: `컴플레인 ID ${complaintId}를 적절한 담당자에게 할당하는 것을 도와주세요.

## 할당 프로세스:

### 1. 컴플레인 정보 확인
- fetch-complaint tool로 컴플레인 정보를 가져옵니다
- category, subCategory, priority, urgency를 확인합니다
- 기술적 이슈인지, 고객 응대 이슈인지 파악합니다

### 2. 현재 상태 확인
- 이미 담당자가 할당되어 있는지 확인합니다
- 할당되어 있다면 현재 진행 상태를 확인합니다
- 재할당이 필요한 상황인지 판단합니다

### 3. 가용 담당자 조회
- fetch-available-agents tool로 현재 업무 가능한 CS 담당자를 조회합니다
- 각 담당자의 현재 워크로드를 확인합니다
- specialties 정보를 확인하여 해당 카테고리 전문가를 찾습니다

### 4. 최적 담당자 추천
다음 기준으로 담당자를 추천합니다:
- 전문성: 해당 카테고리(category)에 대한 전문성이 있는가?
- 가용성: 현재 워크로드가 적절한가?
- 우선순위 처리 능력: priority가 high인 경우 시니어 담당자 우선
- 평균 만족도: satisfaction_rating이 높은 담당자 우선

### 5. 할당 권고사항 제시
- 추천 담당자 정보 (이름, 직급, 전문분야, 현재 워크로드)
- 할당 이유
- 예상 처리 시간
- 특별히 주의해야 할 사항

최종적으로 가장 적합한 담당자 1-3명을 순위별로 추천해주세요.`,
          },
        },
      ],
    }
  }
)

// Add a dynamic greeting resource
server.registerResource(
  "greeting",
  new ResourceTemplate("greeting://{name}", { list: undefined }),
  {
    title: "Greeting Resource", // Display name for UI
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

// Set up Express and SSE transport
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

const port = parseInt(process.env.PORT || "4000")
app
  .listen(port, () => {
    console.log(`Demo MCP Server running on http://localhost:${port}/mcp`)
  })
  .on("error", (error: Error) => {
    console.error("Server error:", error)
    process.exit(1)
  })
