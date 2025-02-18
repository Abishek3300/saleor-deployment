FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Install system dependencies (only the necessary ones)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies in one step for cache efficiency
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir graphql-core==3.2.3 python-json-logger

# Copy the entire project to the container (assuming your project is in the same folder)
COPY . /app/

# Set environment variable for the project
ENV PYTHONPATH /app/backend

# Expose the application port (this can be adjusted based on your needs)
EXPOSE 8000

# Use Gunicorn with Uvicorn worker class for ASGI support
CMD ["gunicorn", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000", "saleor.asgi:application"]

