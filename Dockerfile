# 基於官方 Python 映像
FROM python:3.11-slim

# 安裝 Node.js（n8n 所需）
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g n8n

# 安裝 FFmpeg 和 Playwright 依賴
RUN apt-get install -y \
    ffmpeg \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Python 依賴
RUN pip install --no-cache-dir \
    playwright \
    && playwright install

# 設置工作目錄
WORKDIR /app

# 克隆TiktokAutoUploader儲存庫
RUN git clone https://github.com/carolyin111/TiktokAutoUploader.git /app/TiktokAutoUploader

# 複製應用程式檔案
COPY . /app

# 設置環境變數
ENV PYTHONUNBUFFERED=1
ENV N8N_HOST="0.0.0.0"
ENV N8N_PORT=5678

# 暴露 n8n 埠
EXPOSE 5678

# 啟動 n8n
CMD ["n8n"]