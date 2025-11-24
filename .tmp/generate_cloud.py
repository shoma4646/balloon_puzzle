import requests
import json
import base64

url = "http://127.0.0.1:7860/sdapi/v1/txt2img"

payload = {
    "prompt": "bright sky background, light blue sky, white puffy cloud, cartoon style, game art, simple illustration, vibrant colors, cheerful, sunny day",
    "negative_prompt": "dark, black, night, shadow, realistic, photo, complex",
    "steps": 20,
    "width": 512,
    "height": 256,
    "cfg_scale": 7,
    "sampler_name": "Euler a",
    "seed": 42,
    "batch_size": 1,
    "n_iter": 1
}

print("Generating cloud image with prompt:")
print(payload["prompt"])
print("\nThis may take a few minutes...")

response = requests.post(url, json=payload)
data = response.json()

# Save the image
image_data = base64.b64decode(data['images'][0])
with open('assets/images/cloud_platform.png', 'wb') as f:
    f.write(image_data)

print("\nCloud platform image generated successfully!")
print(f"Saved to: assets/images/cloud_platform.png")
print(f"Parameters used: {payload['steps']} steps, {payload['width']}x{payload['height']}px")
