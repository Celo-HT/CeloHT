openapi: 1.0.0
info:
  title: CeloHT Public API
  description: >
    Official non-custodial public API for CeloHT.
    Supports Education, Agents coordination, and Reforestation reporting.
    No custodial services. No fund holding. No guarantees. No speculation.
  version: 1.0.0
  termsOfService: https://celoht.org/terms
  contact:
    name: CeloHT
    email: celoht3@gmail.com
  license:
    name: MIT
servers:
  - url: https://api.celoht.org/v1
    description: Production
  - url: https://sandbox.api.celoht.org/v1
    description: Sandbox
security:
  - ApiKeyAuth: []
paths:
  /health:
    get:
      tags:
        - Health
      summary: API health check
      description: Public endpoint to verify API availability
      operationId: getHealth
      security: []
      responses:
        '200':
          description: Service operational
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HealthResponse'
        '500':
          $ref: '#/components/responses/InternalError'
  /education/programs:
    get:
      tags:
        - Education
      summary: List education programs
      description: Retrieve available CeloHT education programs
      operationId: listEducationPrograms
      responses:
        '200':
          description: Programs list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/EducationProgram'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '429':
          $ref: '#/components/responses/RateLimited'
        '500':
          $ref: '#/components/responses/InternalError'
  /agents:
    get:
      tags:
        - Agents
      summary: List registered agents
      description: Retrieve registered community agents
      operationId: listAgents
      responses:
        '200':
          description: Agents list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Agent'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '429':
          $ref: '#/components/responses/RateLimited'
        '500':
          $ref: '#/components/responses/InternalError'
  /reforestation/projects:
    get:
      tags:
        - Reforestation
      summary: List reforestation projects
      description: Retrieve reforestation impact data
      operationId: listReforestationProjects
      responses:
        '200':
          description: Projects list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ReforestationProject'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '429':
          $ref: '#/components/responses/RateLimited'
        '500':
          $ref: '#/components/responses/InternalError'
components:
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-KEY
  schemas:
    HealthResponse:
      type: object
      required:
        - status
        - timestamp
      properties:
        status:
          type: string
          example: ok
        timestamp:
          type: string
          format: date-time
    EducationProgram:
      type: object
      required:
        - id
        - title
        - description
        - language
      properties:
        id:
          type: string
          example: edu-001
        title:
          type: string
          example: Introduction to Celo and cUSD
        description:
          type: string
          example: Basic education program about the Celo ecosystem
        language:
          type: string
          example: fr
    Agent:
      type: object
      required:
        - id
        - name
        - region
        - role
      properties:
        id:
          type: string
          example: agent-101
        name:
          type: string
          example: Community Agent Gonaives
        region:
          type: string
          example: HT-AR
        role:
          type: string
          example: Education Facilitator
    ReforestationProject:
      type: object
      required:
        - id
        - location
        - trees_planted
        - status
      properties:
        id:
          type: string
          example: tree-9001
        location:
          type: string
          example: Artibonite
        trees_planted:
          type: integer
          example: 5000
        status:
          type: string
          example: active
    ErrorResponse:
      type: object
      required:
        - error
        - message
      properties:
        error:
          type: string
          example: unauthorized
        message:
          type: string
          example: Invalid API key
  responses:
    Unauthorized:
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
    RateLimited:
      description: Too many requests
      headers:
        Retry-After:
          schema:
            type: integer
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
    InternalError:
      description: Internal server error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
tags:
  - name: Health
    description: API status
  - name: Education
    description: Educational programs and content
  - name: Agents
    description: Community agents coordination
  - name: Reforestation
    description: Environmental impact data
x-rate-limit:
  description: Standard rate limiting policy
  requestsPerMinute: 60
x-versioning:
  description: URI-based versioning
  current: v1
  next: v2