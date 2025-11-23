import requests
import json
import base64

url = "http://127.0.0.1:7860/sdapi/v1/txt2img"

# 非常にシンプルなテスト
payload = {
    "prompt": "white cloud",
    "steps": 1,
    "width": 64,
    "height": 64
}

print("Testing Stable Diffusion API...")
print(f"Payload: {json.dumps(payload, indent=2)}")

try:
    response = requests.post(url, json=payload, timeout=120)
    print(f"Status code: {response.status_code}")

    if response.status_code == 200:
        data = response.json()
        print(f"Response keys: {list(data.keys())}")

        if 'images' in data and len(data['images']) > 0:
            print(f"Number of images: {len(data['images'])}")

            # 画像データの最初の100文字を表示
            image_b64 = data['images'][0]
            print(f"Image data length: {len(image_b64)} characters")
            print(f"Image data preview: {image_b64[:100]}...")

            # 画像をデコードして保存
            image_data = base64.b64decode(image_b64)
            with open('.tmp/test_output.png', 'wb') as f:
                f.write(image_data)
            print("Test image saved to .tmp/test_output.png")
            print(f"Image file size: {len(image_data)} bytes")
        else:
            print("No images in response!")
            print(f"Full response: {json.dumps(data, indent=2)}")
    else:
        print(f"Error response: {response.text}")

except Exception as e:
    print(f"Exception occurred: {type(e).__name__}: {e}")
