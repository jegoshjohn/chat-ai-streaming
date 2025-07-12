# ChatDPT

A prompt engineering hello world project demonstrating how to build a conversational AI with a custom persona. 
This example builds a custom persona that embodies Deepak Chopra's signature woo-woo "spiritual wisdom".

## Key Features

- Real-time streaming chat completions with OpenAI API
- Custom persona implementation through prompt engineering

## Tech Stack

- **Frontend**: Next.js 14, TypeScript, Tailwind CSS, AI SDK
- **Backend**: Python FastAPI, OpenAI API
- **Deployment**: Vercel

## Quick Start

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env
# Add your OPENAI_API_KEY to .env

# Run development server
pnpm dev
```

Visit `http://localhost:3000` to see the persona in action and examine the prompt engineering implementation.
