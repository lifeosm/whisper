FROM python:3.11-slim

LABEL author="OctoLab team <team@octolab.org>"
LABEL org.opencontainers.image.title="Whisper"
LABEL org.opencontainers.image.description="Docker image with OpenAI Whisper."
LABEL org.opencontainers.image.source="https://github.com/lifeosm/whisper"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /usr/src

RUN apt update && apt install -y ffmpeg
RUN pip install -U openai-whisper

ENTRYPOINT ["whisper"]
