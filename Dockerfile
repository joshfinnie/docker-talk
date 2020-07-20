FROM python:3-slim as base

ENV PYTHONUNBUFFERED=1

WORKDIR /code

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.0.9

RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN poetry export -f requirements.txt | /venv/bin/pip install -r /dev/stdin

FROM base as final

COPY --from=builder /venv /venv
COPY . /code
RUN chmod +x /code/docker-entrypoint.sh
CMD ["./docker-entrypoint.sh"]
