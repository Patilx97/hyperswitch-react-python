FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

# Install core utilities and add deadsnakes PPA
RUN apt update && \
    apt install -y software-properties-common curl gnupg lsb-release && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python3.12 python3.12-venv python3-pip build-essential git

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt install -y nodejs && \
    npm install -g npm && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the project files
COPY . .

# Set up Python venv
RUN python3.12 -m venv $VIRTUAL_ENV && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Install Node dependencies
RUN npm install

# Expose ports
EXPOSE 3000 5000

# Run both server and client (note JSON-form for CMD)
CMD ["bash", "-c", "npm run start-server & npm run start-client && wait"]
