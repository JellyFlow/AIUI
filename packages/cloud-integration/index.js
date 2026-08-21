const DEFAULT_ENDPOINT = 'https://rcs.rokid.com/metis/callback/message'

export class CloudIntegrationError extends Error {
  constructor(message, { cause, response, payload } = {}) {
    super(message, cause === undefined ? undefined : { cause })
    this.name = 'CloudIntegrationError'
    this.response = response
    this.payload = payload
  }
}

export class CloudIntegrationValidationError extends CloudIntegrationError {
  constructor(message) {
    super(message)
    this.name = 'CloudIntegrationValidationError'
  }
}

export class CloudIntegration {
  constructor({ token, endpoint = DEFAULT_ENDPOINT, fetch = globalThis.fetch } = {}) {
    if (typeof token !== 'string' || token.length === 0) {
      throw new CloudIntegrationValidationError('token is required')
    }
    if (typeof endpoint !== 'string' || endpoint.length === 0) {
      throw new CloudIntegrationValidationError('endpoint must be a non-empty string')
    }
    if (typeof fetch !== 'function') {
      throw new CloudIntegrationValidationError('fetch must be available')
    }

    this.token = token
    this.endpoint = endpoint
    this.fetch = fetch
  }

  async sendNotification({ messageId, accountId, message } = {}) {
    validateString(messageId, 'messageId')
    validateString(accountId, 'accountId')
    validateMessage(message)

    const body = {
      message_id: messageId,
      account_id: accountId,
      message: {
        agent_id: message.agentId,
        content: message.content,
      },
    }

    if (message.tool !== undefined) {
      validateTool(message.tool)
      body.message.tool = {
        name: message.tool.name,
        parameters: {
          type: message.tool.parameters.type,
          properties: message.tool.parameters.properties,
        },
      }
    }

    let response
    try {
      response = await this.fetch(this.endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.token}`,
        },
        body: JSON.stringify(body),
      })
    } catch (error) {
      throw new CloudIntegrationError('notification request failed', { cause: error })
    }

    let payload
    try {
      payload = await response.json()
    } catch (error) {
      throw new CloudIntegrationError('notification response was not valid JSON', {
        cause: error,
        response,
      })
    }

    if (!response.ok) {
      throw new CloudIntegrationError(`notification request returned HTTP ${response.status}`, {
        response,
        payload,
      })
    }
    if (payload?.code !== 1) {
      throw new CloudIntegrationError(`notification request failed: ${payload?.msg ?? 'unknown error'}`, {
        response,
        payload,
      })
    }
    if (payload?.data?.success !== true) {
      throw new CloudIntegrationError('notification was not delivered successfully', {
        response,
        payload,
      })
    }

    return payload
  }
}

function validateString(value, name) {
  if (typeof value !== 'string' || value.length === 0) {
    throw new CloudIntegrationValidationError(`${name} is required`)
  }
}

function validateMessage(message) {
  if (!message || typeof message !== 'object') {
    throw new CloudIntegrationValidationError('message is required')
  }
  validateString(message.agentId, 'message.agentId')
  validateString(message.content, 'message.content')
}

function validateTool(tool) {
  if (!tool || typeof tool !== 'object') {
    throw new CloudIntegrationValidationError('message.tool must be an object')
  }
  validateString(tool.name, 'message.tool.name')
  if (!tool.parameters || typeof tool.parameters !== 'object') {
    throw new CloudIntegrationValidationError('message.tool.parameters is required')
  }
  if (tool.parameters.type !== 'object') {
    throw new CloudIntegrationValidationError('message.tool.parameters.type must be "object"')
  }
  if (!tool.parameters.properties || typeof tool.parameters.properties !== 'object' || Array.isArray(tool.parameters.properties)) {
    throw new CloudIntegrationValidationError('message.tool.parameters.properties must be an object')
  }
}

export { DEFAULT_ENDPOINT }
