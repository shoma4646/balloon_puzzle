from PIL import Image, ImageDraw
import math

# 画像サイズ
width = 512
height = 256

# 新しい画像を作成（透明背景）
image = Image.new('RGBA', (width, height), (0, 0, 0, 0))
draw = ImageDraw.Draw(image)

# 雲の色（白）
cloud_color = (255, 255, 255, 255)
cloud_shadow = (230, 230, 240, 255)

# 雲を楕円の組み合わせで描画
# 中央の大きな楕円
draw.ellipse([width*0.2, height*0.3, width*0.8, height*0.9], fill=cloud_color)

# 左側の楕円
draw.ellipse([width*0.05, height*0.4, width*0.4, height*0.85], fill=cloud_color)

# 右側の楕円
draw.ellipse([width*0.6, height*0.4, width*0.95, height*0.85], fill=cloud_color)

# 上部の小さな楕円（ふわふわ感を出す）
draw.ellipse([width*0.3, height*0.15, width*0.5, height*0.5], fill=cloud_color)
draw.ellipse([width*0.5, height*0.2, width*0.7, height*0.55], fill=cloud_color)

# 影の部分（下部を少し暗く）
draw.ellipse([width*0.25, height*0.7, width*0.75, height*0.95], fill=cloud_shadow)

# 保存
image.save('assets/images/cloud_platform.png')
print("Cloud image created successfully!")
print("Size: 512x256px")
print("Format: PNG with transparency")
