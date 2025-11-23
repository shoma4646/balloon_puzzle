import requests
import json
import base64
from PIL import Image
import io

url = "http://127.0.0.1:7860/sdapi/v1/txt2img"

# 元のプロンプトを再現
payload = {
    "prompt": "bright sky background, light blue sky, white puffy cloud, cartoon style, game art, simple illustration, vibrant colors, cheerful, sunny day",
    "negative_prompt": "dark, black, night, shadow, realistic, photo, complex",
    "steps": 20,
    "width": 512,
    "height": 256,
    "cfg_scale": 7,
    "sampler_name": "Euler a",
    "seed": 42
}

print("Analyzing Stable Diffusion generation...")
print(f"Prompt: {payload['prompt']}")

response = requests.post(url, json=payload, timeout=300)
data = response.json()

if 'images' in data and len(data['images']) > 0:
    image_data = base64.b64decode(data['images'][0])

    # 画像を分析
    img = Image.open(io.BytesIO(image_data))
    print(f"\nImage info:")
    print(f"  Size: {img.size}")
    print(f"  Mode: {img.mode}")
    print(f"  Format: {img.format}")

    # ピクセルデータを分析
    pixels = list(img.getdata())
    print(f"  Total pixels: {len(pixels)}")

    # 色の統計
    if img.mode == 'RGB':
        avg_r = sum(p[0] for p in pixels) / len(pixels)
        avg_g = sum(p[1] for p in pixels) / len(pixels)
        avg_b = sum(p[2] for p in pixels) / len(pixels)
        print(f"  Average RGB: ({avg_r:.1f}, {avg_g:.1f}, {avg_b:.1f})")

        # 黒いピクセルの割合
        black_pixels = sum(1 for p in pixels if p[0] < 10 and p[1] < 10 and p[2] < 10)
        black_ratio = black_pixels / len(pixels) * 100
        print(f"  Black pixels: {black_ratio:.1f}%")

    # 画像を保存
    img.save('.tmp/sd_debug_output.png')
    print(f"\nDebug image saved to .tmp/sd_debug_output.png")

    # info フィールドを確認
    if 'info' in data:
        info = json.loads(data['info'])
        print(f"\nGeneration info:")
        for key in ['prompt', 'negative_prompt', 'sampler_name', 'steps', 'cfg_scale', 'seed']:
            if key in info:
                print(f"  {key}: {info[key]}")
