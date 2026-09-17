#!/usr/bin/env python3
"""
Generate QR Code assets for Global Jobs By Suhana Android App.
Target: Direct APK Download via GitHub Releases /latest/
"""
import os
import base64
import io
import qrcode
from qrcode.image.svg import SvgPathImage
from PIL import Image

TARGET_URL = "https://github.com/koushikrai/mena_mobile_recruitment_platform/releases/latest/download/app-release.apk"
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "download_assets")
ARTIFACT_DIR = r"C:\Users\khanz\.gemini\antigravity\brain\ef29a9eb-a2c2-42a6-8d6d-f3d842f614c4"

def generate_assets():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print(f"Target URL: {TARGET_URL}")
    
    # 1. Generate High-Res PNG (1024x1024) with Error Correction Q (25% tolerance)
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_Q,
        box_size=20,
        border=4,
    )
    qr.add_data(TARGET_URL)
    qr.make(fit=True)
    
    img = qr.make_image(fill_color="#990000", back_color="white")
    # Resize to exact 1024x1024
    img = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    png_path = os.path.join(OUTPUT_DIR, "app_download_qr.png")
    img.save(png_path, "PNG")
    print(f"Saved PNG: {png_path}")

    # Also save to conversation artifacts directory so it can be previewed/embedded
    if os.path.exists(ARTIFACT_DIR):
        artifact_png = os.path.join(ARTIFACT_DIR, "app_download_qr.png")
        img.save(artifact_png, "PNG")
        print(f"Saved to artifacts: {artifact_png}")

    # 2. Generate SVG (Scalable Vector for printing on banners/standees)
    svg_qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_Q,
        box_size=10,
        border=4,
        image_factory=SvgPathImage
    )
    svg_qr.add_data(TARGET_URL)
    svg_qr.make(fit=True)
    svg_img = svg_qr.make_image()
    svg_path = os.path.join(OUTPUT_DIR, "app_download_qr.svg")
    svg_img.save(svg_path)
    print(f"Saved SVG: {svg_path}")

    # 3. Generate base64 data URI for HTML card
    buffered = io.BytesIO()
    img.save(buffered, format="PNG")
    b64_qr = base64.b64encode(buffered.getvalue()).decode('utf-8')

    # 4. Generate Branded HTML Download Card
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Download Global Jobs By Suhana</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
  <style>
    * {{
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }}
    body {{
      min-height: 100vh;
      background: linear-gradient(135deg, #1E1B1B 0%, #3B1B1B 50%, #1E1B1B 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      color: #1E1B1B;
    }}
    .card {{
      background: #FFFFFF;
      max-width: 440px;
      width: 100%;
      border-radius: 24px;
      padding: 32px 28px;
      box-shadow: 0 24px 48px rgba(0,0,0,0.35);
      text-align: center;
      position: relative;
      overflow: hidden;
      border: 1px solid rgba(228, 190, 184, 0.4);
    }}
    .header-tag {{
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: #FEF2F2;
      border: 1px solid #FEE2E2;
      color: #990000;
      font-size: 11px;
      font-weight: 800;
      padding: 6px 12px;
      border-radius: 9999px;
      letter-spacing: 0.5px;
      margin-bottom: 16px;
    }}
    .brand-title {{
      font-size: 26px;
      font-weight: 800;
      color: #990000;
      letter-spacing: -0.5px;
      line-height: 1.1;
    }}
    .brand-sub {{
      font-size: 12px;
      font-weight: 700;
      color: #5B403C;
      letter-spacing: 1.2px;
      margin-top: 4px;
      margin-bottom: 20px;
    }}
    .qr-frame {{
      background: #FFFFFF;
      padding: 16px;
      border-radius: 20px;
      border: 2px solid #FEE2E2;
      display: inline-block;
      box-shadow: 0 8px 24px rgba(153, 0, 0, 0.08);
      margin-bottom: 20px;
    }}
    .qr-frame img {{
      width: 220px;
      height: 220px;
      display: block;
      border-radius: 8px;
    }}
    .qr-label {{
      font-size: 14px;
      font-weight: 700;
      color: #1E1B1B;
      margin-bottom: 4px;
    }}
    .qr-hint {{
      font-size: 11px;
      color: #64748B;
      margin-bottom: 20px;
    }}
    .btn-download {{
      display: block;
      width: 100%;
      background: #990000;
      color: #FFFFFF;
      text-decoration: none;
      font-weight: 800;
      font-size: 14px;
      padding: 14px;
      border-radius: 12px;
      transition: background 0.2s ease;
      box-shadow: 0 4px 14px rgba(153, 0, 0, 0.3);
    }}
    .btn-download:hover {{
      background: #7A0000;
    }}
    .instructions {{
      margin-top: 20px;
      text-align: left;
      background: #F8FAFC;
      border: 1px solid #E2E8F0;
      border-radius: 12px;
      padding: 14px 16px;
    }}
    .instructions-title {{
      font-size: 11px;
      font-weight: 800;
      color: #475569;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 8px;
    }}
    .step {{
      font-size: 11px;
      color: #475569;
      line-height: 1.5;
      margin-bottom: 4px;
      display: flex;
      align-items: flex-start;
      gap: 6px;
    }}
    .step span {{
      font-weight: 700;
      color: #990000;
    }}
  </style>
</head>
<body>
  <div class="card">
    <div class="header-tag">
      <span>🇸🇦</span> OFFICIAL ANDROID APP
    </div>
    <div class="brand-title">Global Jobs</div>
    <div class="brand-sub">BY SUHANA</div>

    <div class="qr-frame">
      <img src="data:image/png;base64,{b64_qr}" alt="Scan to Download APK">
    </div>

    <div class="qr-label">Scan Camera to Download APK</div>
    <div class="qr-hint">Always delivers the latest version automatically</div>

    <a href="{TARGET_URL}" class="btn-download">
      Direct Download APK (Latest Build)
    </a>

    <div class="instructions">
      <div class="instructions-title">Quick 3-Step Installation</div>
      <div class="step"><span>1.</span> Scan QR code with phone camera or click download button.</div>
      <div class="step"><span>2.</span> Tap <b>Download anyway</b> when Android browser prompts.</div>
      <div class="step"><span>3.</span> Open <b>app-release.apk</b> from notification and tap <b>Install</b>.</div>
    </div>
  </div>
</body>
</html>"""

    card_path = os.path.join(OUTPUT_DIR, "qr_download_card.html")
    with open(card_path, "w", encoding="utf-8") as f:
        f.write(html_content)
    print(f"Saved HTML Card: {card_path}")

    # Also save to conversation artifacts directory
    if os.path.exists(ARTIFACT_DIR):
        artifact_card = os.path.join(ARTIFACT_DIR, "qr_download_card.html")
        with open(artifact_card, "w", encoding="utf-8") as f:
            f.write(html_content)
        print(f"Saved HTML Card to artifacts: {artifact_card}")

if __name__ == "__main__":
    generate_assets()
