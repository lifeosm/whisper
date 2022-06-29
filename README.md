# Docker for Whisper

Docker image with [Whisper](https://github.com/openai/whisper)
from [OpenAI](https://openai.com/).

## Quick start

You can pull the pre-built image

```bash
docker pull ghcr.io/lifeosm/whisper:latest # or v20231117
```

or build your own by

```bash
docker build -t whisper:local .
```

The image does not contain any models, so you need to download them first.

```bash
docker volume create whisper-models
docker run --rm -it \
  --entrypoint python \
  -v whisper-models:/root/.cache/whisper \
  ghcr.io/lifeosm/whisper:latest \
    -c 'import whisper; whisper.load_model("tiny")'
```

Full list of available models and languages can be found [here][models].

With the model you car run a required command, e.g.,

```bash
docker run --rm -it \
  -v whisper-models:/root/.cache/whisper \
  -v audio.wav:/usr/src/audio.wav \
  ghcr.io/lifeosm/whisper:latest \
    --model tiny \
    --task transcribe \
    audio.wav
```

The full list of commands can be found here

```bash
docker run --rm -it ghcr.io/lifeosm/whisper:latest --help
```

Don't forget about memory limits, e.g., to run the medium model
you could use the following command

```bash
docker run --rm -it \
  -m 8g \
  -v whisper-models:/root/.cache/whisper \
  -v audio.wav:/usr/src/audio.wav \
  ghcr.io/lifeosm/whisper:latest \
    --model medium \
    --task transcribe \
    audio.wav
```

## Advanced

If you need simplicity you could investigate [Taskfile](./Taskfile).

```bash
run help
run load large
run whisper -f json audio.mp3
```

```bash
whisper() {
  local model=small memory args=("${@}")
  while [[ $# -gt 0 ]]; do
    case "${1}" in
    --model) model=${2} && shift 2 ;;
    *) shift 1 ;;
    esac
  done
  IFS=' ' read -r -a memory <<<"$(@size "${model}")"
  docker run --rm -it \
    "${memory[@]}" \
    -v whisper-models:/root/.cache/whisper \
    -v "$(pwd)":/usr/src \
    ghcr.io/lifeosm/whisper:latest "${args[@]}"
}

@size() {
  case "${1}" in
  tiny|tiny.en) echo -m 1g ;;
  base|base.en) echo -m 1g ;;
  small|small.en) echo -m 2g ;;
  medium|medium.en) echo -m 5g ;;
  large) echo -m 10g ;;
  *) echo "unknown size: ${1}" >&2 && exit 1 ;;
  esac
}
```

## Resources

- https://openai.com/
- https://github.com/openai
- https://github.com/openai/whisper
- https://openai.com/research/whisper
- https://pypi.org/project/openai-whisper/

## Alternatives

- https://hub.docker.com/r/liquidinvestigations/openai-whisper-gradio

[models]: https://github.com/openai/whisper?tab=readme-ov-file#available-models-and-languages
