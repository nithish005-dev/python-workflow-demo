# Build stage - Install dependencies and run SonarQube analysis
FROM python:3.10-slim as builder

# Install Java and other dependencies needed for SonarQube Scanner
RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download and install SonarQube Scanner
RUN curl -o sonar-scanner.zip \
    -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
    && unzip -q sonar-scanner.zip \
    && rm sonar-scanner.zip \
    && mv sonar-scanner-5.0.1.3006-linux sonar-scanner

# Copy project files
COPY requirements.txt sonar-project.properties ./
COPY app.py .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set SonarQube Scanner path
ENV PATH="/app/sonar-scanner/bin:$PATH"

# Runtime stage - Run the application
FROM python:3.10-slim

WORKDIR /app

# Copy only the necessary files from builder
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["python", "app.py"]
