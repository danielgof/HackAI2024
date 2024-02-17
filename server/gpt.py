from openai import OpenAI
import requests

# OpenAI API Key
api_key = ""

headers = {
  "Content-Type": "application/json",
  "Authorization": f"Bearer {api_key}"
}

base64_image = ""
payload = {
  "model": "gpt-4-vision-preview",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "Answer first question as 1 or 0. Is this food? Are there potential sources of allregies? What are they?"
        },
        {
          "type": "image_url",
          "image_url": {
            "url": f"data:image/jpeg;base64,{base64_image}"
          }
        }
      ]
    }
  ],
  "max_tokens": 300
}

response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
print(response.json())