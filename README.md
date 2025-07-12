# ChatDPT

A hello world app for prompt engineering that lets users have conversations with an AI persona of Deepak Chopra. Built with Next.js frontend and Python FastAPI backend for streaming chat completions.

## Features

- Real-time streaming chat interface
- AI persona of Deepak Chopra with spiritual wisdom responses
- Markdown rendering for formatted responses
- File attachment support
- Responsive design with modern UI

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

Visit `http://localhost:3000` to start chatting with Deepak Chopra.
