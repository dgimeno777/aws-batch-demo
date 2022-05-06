FROM python:3.10-slim as base

# Make and set workdir
WORKDIR /src/

# Install poetry
RUN pip install --upgrade pip \
 && pip install poetry

# Copy poetry files & install
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
 && poetry install --no-interaction

# Copy code
COPY ./wait/ ./wait/
