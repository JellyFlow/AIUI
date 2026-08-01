# Concept Introduction

This page is written for readers who are seeing AIUI for the first time.

If terms like `AIUI`, `intent`, `intent-driven`, `AI`, `AI glasses`, and `Rokid Glasses` feel unfamiliar, do not worry. You can treat this page as a beginner-friendly glossary. We will explain each term in simple language and connect it back to what it means in AIUI.

## What Is AIUI?

Here is the simplest way to understand it:

**AIUI is a way to build agents that combine AI with user interfaces.**

There are two key parts in that sentence:

- it has **AI**
- it also has **UI (user interface)**

When many people first think about AI products, they imagine "a chat box plus a large model that can answer questions". That is not wrong, but it is too narrow.

AIUI goes one step further:

- it is not only about making AI answer
- it is also about making AI participate in real interaction
- it lets users not only ask, but also see, tap, choose, and operate
- it lets the system not only reply, but also execute, update, and return feedback

So AIUI can be understood simply as:

**a framework that turns AI from something that can talk into something that can take part in agent interaction**

## What Is UI?

`UI` stands for `User Interface`.

You can think of UI as: **the part that users can directly see and operate**.

For example:

- text on a page
- a button
- a card
- a list
- an input box
- a status hint

All of these are UI.

In traditional software, UI mainly displays information and receives user actions.

In AIUI, UI goes further. It is not only for showing information. It also helps:

- carry the user's current need
- guide the next step of the interaction
- clearly show the current system state

So in AIUI, UI is not only about how something looks. It is also about whether the interaction is carried well.

## What Is AI?

`AI` stands for `Artificial Intelligence`.

In the simplest words, AI means:

**giving computers some abilities that look a bit like human understanding, judgment, generation, and decision-making**

In today's products, the AI people meet most often can do things like:

- understand what users say
- answer questions
- generate text, images, or speech
- recognize speech or visual content
- make limited decisions based on context

But it is important to remember that AI is not a magic brain that does everything automatically.

AI is better understood as one capability module. It is good at understanding, generating, and reasoning, but it still needs:

- clear product goals
- good interaction design
- clear system boundaries
- reliable engineering implementation

That is why AIUI does not talk only about AI. It also talks about interface, logic, and device capabilities.

## What Is an Agent?

An agent can be understood as:

**an AI system that keeps working toward a goal**

It usually does more than answer one question. It can:

- understand the user's goal
- complete tasks step by step
- adjust behavior when the situation changes
- keep returning feedback to the user

For example, a normal question-answering model might only answer "What is the weather today?"

But a weather agent might also:

- figure out your current city
- request weather data
- show temperature, air quality, and advice in a card
- remind you whether you should bring an umbrella

So an agent is not just an answering machine. It is more like a system that keeps handling things around a goal.

## What Is Intent?

`Intent` is one of the most important ideas in AIUI.

You can understand intent as:

**what the user is really trying to do right now**

Notice that this is not the same as the exact words the user typed. It is closer to the user's real goal.

Here are simple examples:

- The user says: "Is it hot in Shanghai today?"
  The intent may be: **check the weather in Shanghai**

- The user says: "Book a high-speed train for tomorrow morning."
  The intent may be: **complete a travel booking**

- The user says: "This button does not respond."
  The intent may be: **debug a problem or continue an unfinished task**

So intent is more important than the literal sentence, because it points to the user's real goal.

## What Does Intent-Driven Mean?

Once you understand intent, it becomes easier to understand `intent-driven`.

`Intent-driven` means:

**the system is designed and organized around what the user wants to do, not only around pages, buttons, or APIs**

That still sounds a little abstract, so let us compare two ways of thinking.

### When a system is not intent-driven

Many traditional systems are organized like this:

- first there is a page
- the page contains buttons
- the user taps a button
- the program runs fixed logic

This works fine, but the center of the system is still the page structure.

### When a system is intent-driven

The intent-driven way is closer to this:

- the user expresses a need
- the system figures out what the user really wants
- the system decides which capability should be used
- the system decides what kind of interface should carry the interaction
- the result is continuously returned to the user

Pages, buttons, and APIs still exist, but they are no longer the only main characters.

The main story becomes:

**What is the user's goal, and what is the best way for the system to help complete it?**

That is the core meaning of "intent-driven".

## Why Does AIUI Emphasize Intent-Driven Design?

Because in AI products, the entry point is often not a fixed button. It is often a sentence, a request, a question, or even a vague expression.

For example, a user might say:

- "Can you help me see whether today is good for running outside?"
- "I want to know whether this device is connected now."
- "Please quickly organize this content for me."

These inputs are not standard button operations. They are closer to real needs.

If a system only follows fixed page flows, it can feel rigid.

But if the system first understands intent and then decides the interaction form, the experience becomes much more natural.

That is why AIUI places intent in such an important position.

## What Are AI Glasses?

You can understand `AI glasses` simply as:

**a new kind of glasses device with AI capabilities**

What makes them different from normal glasses is not the lens itself, but the kinds of capabilities they may include:

- voice interaction
- camera perception
- information display
- network connection
- AI service access
- collaboration with phones or other devices

You can think of AI glasses as a smart terminal that is closer to real daily-life situations.

On this kind of device, users may not always stare at a large screen and tap slowly, so the interaction style can be very different from phones and computers.

This is one reason frameworks like AIUI matter: they need to support not only traditional app pages, but also more natural, lightweight, and always-available interaction experiences.

## What Is AR?

`AR` stands for `Augmented Reality`.

It does not mean putting people into a fully virtual world. It means:

**adding digital information on top of the real world**

For example:

- you look at a real street, but see navigation arrows in front of you
- you look at an object, and the system shows information about it
- you wear a device where the real world and digital content appear together

So the key point of AR is: the real world stays there, and digital information is added on top of it.

AIUI fits AI + AR scenarios because those scenarios often need:

- more natural interaction
- continuous state feedback
- coordination between interface and environment
- AI that understands context

## What Does Interaction on AI Glasses Feel Like?

On a phone, users are used to doing things like:

- open an app
- find a page
- tap a button

On AI glasses, interaction more often becomes:

- say one sentence
- glance at one prompt
- tap once to confirm
- receive continuous feedback

That means interaction on the device can be more fragmented, more real-time, and more context-dependent.

So AIUI is not simply about moving phone pages onto glasses. It also asks:

- what is the most convenient input method right now?
- should feedback be text, voice, or a card?
- does the user need a full page, or only a lightweight interaction block?

## What Is Rokid Glasses?

`Rokid Glasses` refers to smart glasses devices made by Rokid.

If you know nothing about them yet, that is fine. At this stage, you can simply think of them as:

**a real AI glasses / smart glasses device that may run AIUI agents**

Why are they mentioned in the documentation?

Because many of AIUI's design goals are closely related to this kind of device scenario, such as:

- lighter interaction
- more natural input and output
- stronger use of voice, cards, and status feedback
- more continuous use in real-world situations

You do not need to understand Rokid hardware details at the beginning. For now, it is enough to know:

- it represents a real device scenario
- AIUI is not designed only for traditional mobile apps
- AIUI also wants to support AI glasses, AR terminals, and similar new-device experiences

That is enough for a beginner.

## What Is the Difference Between "Can Answer" and "Can Interact"?

This difference is very important for understanding AIUI.

### Can answer

This means:

- the user asks a question
- the system gives one answer
- the interaction is mostly over

This is the most common chat-style AI experience.

### Can interact

This means:

- the user expresses a need
- the system understands what the user wants
- the system shows a suitable way to operate
- the user keeps tapping, choosing, confirming, or entering information
- the system continuously updates results and status

At this point, the system is no longer only saying one sentence. It is completing a process together with the user.

AIUI is much closer to the second type.

## How Can You Remember These Concepts?

If you want a quick summary, remember them like this:

- **AIUI**: a framework that combines AI with interface-driven interaction
- **AI**: gives the system some ability to understand, generate, and judge
- **UI**: the interactive layer users can see and operate
- **Agent**: a system that keeps working toward a goal
- **Intent**: what the user really wants to do
- **Intent-driven**: the system is organized around user goals first
- **AI glasses**: new glasses devices with AI capabilities
- **Rokid Glasses**: one real smart-glasses device scenario

## Suggested Next Step

If these terms are now clearer, the next good reading order is:

1. **Overview**: understand what AIUI is for from a bigger picture
2. **Project Structure**: see what files exist in an AIUI project
3. **Agent Framework**: understand how intent becomes interaction and interface feedback

If some terms still feel unfamiliar after reading this page, that is completely normal. For beginners, building a simple first understanding matters more than memorizing every term at once. As you continue reading examples and documentation, these ideas will become much clearer.
