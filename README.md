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

The image contains no models, so you need to download them first.

```bash
docker volume create whisper-models
docker run --rm -it \
  --entrypoint python \
  -v whisper-models:/root/.cache/whisper \
  ghcr.io/lifeosm/whisper:latest \
    -c 'import whisper; whisper.load_model("tiny")'
```

Full list of available models and languages can be found [here][models].

With the model, you can run a required command, e.g.,

```bash
docker run --rm -it \
  -v whisper-models:/root/.cache/whisper \
  -v audio.wav:/usr/src/audio.wav \
  ghcr.io/lifeosm/whisper:latest \
    --model tiny \
    --task transcribe \
    audio.wav
```

The complete list of commands can be found here

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

<details>
  <summary>💼 Real example of usage</summary>

Details are [here][example],

```bash
whisper() {
  local model=small memory args=("${@}")

  while [[ $# -gt 0 ]]; do
    case "${1}" in
    --model) model=${2} && shift 2 ;;
    *) shift 1 ;;
    esac
  done

  case "${model}" in
  tiny | tiny.en) memory=(-m 1g) ;;
  base | base.en) memory=(-m 1g) ;;
  small | small.en) memory=(-m 2g) ;;
  medium | medium.en) memory=(-m 5g) ;;
  large) memory=(-m 10g) ;;
  *) echo "unknown size: ${model}" >&2 && return 1 ;;
  esac

  docker run --rm -it \
    "${memory[@]}" \
    -v whisper-models:/root/.cache/whisper \
    -v "$(pwd)":/usr/src \
    ghcr.io/lifeosm/whisper:latest "${args[@]}"
}

transcribe() {
  whisper \
    --model small \
    --task transcribe \
    --language ru \
    -f vtt \
    "${@}"
}
```
</details>

## Resources

- https://openai.com/
- https://github.com/openai
- https://github.com/openai/whisper
- https://openai.com/research/whisper
- https://pypi.org/project/openai-whisper/

## Alternatives

- https://hub.docker.com/r/liquidinvestigations/openai-whisper-gradio

[models]:   https://github.com/openai/whisper?tab=readme-ov-file#available-models-and-languages
[example]:  https://github.com/kamilsk/dotfiles/commit/dce0b935e6cb99473ae499e69394b99b45b837f1
