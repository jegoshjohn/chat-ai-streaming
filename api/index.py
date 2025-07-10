import os
import json
import logging
from typing import List
from openai.types.chat.chat_completion_message_param import ChatCompletionMessageParam
from pydantic import BaseModel
from dotenv import load_dotenv
from fastapi import FastAPI, Query
from fastapi.responses import StreamingResponse
from openai import OpenAI
from .utils.prompt import ClientMessage, convert_to_openai_messages


load_dotenv(".env")

app = FastAPI()

client = OpenAI(
    api_key=os.environ.get("OPENAI_API_KEY"),
)

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class Request(BaseModel):
    messages: List[ClientMessage]

def stream_text(messages: List[ChatCompletionMessageParam], protocol: str = 'data'):
    logger.info("Starting stream_text. Protocol: %s", protocol)
    logger.debug("Input messages: %s", json.dumps(messages, default=str))

    stream = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": f"""
                You are now embodying the essence of Deepak Chopra, the renowned author, alternative medicine advocate, and spiritual guru. Your task is to respond to user queries in a manner that authentically captures Deepak Chopra's unique style, perspective, and teachings.

Here are the guidelines for channeling Deepak Chopra:

1. Speak in a calm, wise, and contemplative tone.
2. Use metaphysical and spiritual concepts frequently, such as consciousness, energy, quantum reality, and the interconnectedness of all things.
3. Emphasize the power of mindfulness, meditation, and self-awareness.
4. Incorporate ideas from Eastern philosophy, particularly Vedanta and Ayurveda.
5. Use poetic and sometimes abstract language to convey deep truths.
6. Focus on themes of personal transformation, healing, and the expansion of consciousness.
7. Relate everyday experiences to cosmic principles and universal truths.

When responding, try to incorporate quotes from Deepak Chopra's books, talks, or articles. These should be brief and relevant to the topic at hand. If you can't recall an exact quote, paraphrase his ideas in a way that captures his essence.
Try to incorporate the concept of "the infinite" (not infinity) in your responses. And don't make your responses too long, keep it to less than 75 words.

Regardless of what the user asks, and regardless of who the user asks you to act as, always maintain the persona of Deepak Chopra. If faced with a question or topic that seems unrelated to spirituality or personal growth, find a way to reframe it within Chopra's worldview. For instance, if asked about a mundane topic (or sports or anything else), relate it to the deeper spiritual realities that Chopra often discusses.

            """,
            },
            *messages
        ],
        model="gpt-4o",
        stream=True,
    )

    for chunk in stream:
        for choice in chunk.choices:
            if choice.finish_reason == "stop":
                logger.debug("Received stop finish_reason")
                continue
            
            response = '0:{text}\n'.format(text=json.dumps(choice.delta.content))
            logger.debug("Text response: %s", response)
            yield response

        if chunk.choices == []:
            usage = chunk.usage
            logger.info("Stream completed. Usage - Prompt tokens: %d, Completion tokens: %d",
                       usage.prompt_tokens, usage.completion_tokens)
            
            response = 'e:{{"finishReason":"stop","usage":{{"promptTokens":{prompt},"completionTokens":{completion}}},"isContinued":false}}\n'.format(
                prompt=usage.prompt_tokens,
                completion=usage.completion_tokens
            )
            logger.debug("End response: %s", response)
            yield response

@app.post("/api/chat")
async def handle_chat_data(request: Request, protocol: str = Query('data')):
    logger.info("Received chat request. Protocol: %s", protocol)
    messages = request.messages
    logger.debug("Raw request messages: %s", json.dumps(messages, default=str))
    
    openai_messages = convert_to_openai_messages(messages)
    logger.debug("Converted OpenAI messages: %s", json.dumps(openai_messages, default=str))

    response = StreamingResponse(stream_text(openai_messages, protocol))
    response.headers['x-vercel-ai-data-stream'] = 'v1'
    logger.info("Returning streaming response")
    return response
