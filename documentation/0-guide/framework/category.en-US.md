# Categories

Within the AIUI framework, agents can be categorized by how user intent is carried through the product experience. In practice, the two main forms are `Conversational AIUI` and `Immersive AIUI`. The core difference is not "page complexity," but whether intent is handled inside the chat flow or whether a standalone interface carries the complete interaction loop.

## 1. Conversational AIUI

Conversational AIUI means that the UI appears directly in the chat flow, embedded in the current context as cards, result blocks, forms, or tool panels. Users express intent in conversation, and the agent returns structured UI in the same context so users can continue to click, confirm, provide additional input, or view results inside the message.

The key point of this kind of AIUI is: **keep intent handling inside the conversation**. Users do not need to jump to another standalone interface or interrupt the current session to complete viewing, confirmation, filtering, or lightweight operations.

Suitable scenarios include:

- Weather cards
- Search result cards
- Itinerary confirmation panels
- To-do confirmation and supplemental forms
- Quick queries and lightweight task feedback

Its typical characteristics include:

- **Interaction carrier**: The interface is attached to the chat flow and is naturally continuous with the message context.
- **Context characteristics**: It usually shares the current session context and is well suited to taking over the next action after a user question.
- **Development focus**: Design the intent trigger, parameter structure, and card interaction well, so the model knows when it should return this kind of UI.
- **Experience goal**: Fast feedback, low interruption, and completing the task in one step.

The example below shows what conversational AIUI typically looks like: after the user asks a question, the AI directly inserts a weather card into the message flow, and the user can continue interacting around that card.

<in-chat-interaction-demo></in-chat-interaction-demo>

## 2. Immersive AIUI

Immersive AIUI means that the UI is no longer attached to chat messages. Instead, a standalone interface carries the complete interaction flow. The user's attention mainly stays on the current interface, while the AI continuously participates in collaboration around the state, operations, and feedback of that interface.

The key point of this kind of AIUI is: **make the interface itself the primary space for carrying intent**. Chat, voice, or other input methods can still exist, but they serve the interface more than they replace it.

Suitable scenarios include:

- Landlord or other turn-based mini-games
- Complex workflow panels
- Device control interfaces
- Long-running task execution interfaces
- Tools or assistants that need continuous state feedback

Its typical characteristics include:

- **Interaction carrier**: The interface is the main stage, and chat is no longer the only container.
- **Context characteristics**: It usually maintains state and flow through an independently running context, making it more suitable for long-lived sessions.
- **Development focus**: You need to organize interface state, intent transitions, and the event loop yourself, and when necessary, integrate capabilities such as `SSE`, `WebSocket`, and `fetch` to build a complete interaction pipeline.
- **Experience goal**: Continuous collaboration, stable state, and complete operation space.

The example below shows what immersive AIUI typically looks like: the main interaction takes place in a Landlord interface, and the AI continuously collaborates around the current game state and the user's actions.

<standalone-interaction-demo></standalone-interaction-demo>

## How Should You Choose?

- If you want intent handling to stay lightweight, fast, and inside the current chat context, choose **Conversational AIUI** first.
- If you want the interface itself to become the primary operating space and carry a long-running intent loop around continuous state, choose **Immersive AIUI** first.
- Many real products use both forms at the same time: conversational AIUI handles lightweight intent fulfillment, while immersive AIUI carries complete scenario experiences.
