**[English](README.md)** | **[繁體中文](doc/README.zh-TW.md)** | **[简体中文](doc/README.zh-CN.md)** | **[日本語](doc/README.ja.md)**

# SICK Safety Scanner Docker Container (ROS 2 Humble)

> **TL;DR** — Containerized SICK Safety Scanner (nanoscan3) driver for ROS 2 Humble. Installs `sick_safetyscanners2_interfaces` and `sick_safetyscanners_base` from apt.
>
> ```bash
> ./build.sh && ./run.sh
> ```

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Smoke Tests](#smoke-tests)
- [Directory Structure](#directory-structure)

---

## Features

- **Apt-based install**: `sick_safetyscanners2_interfaces` and `sick_safetyscanners_base` from ROS 2 apt repository
- **Smoke Test**: Bats tests run automatically during build to verify environment
- **Docker Compose**: single `compose.yaml` manages all targets
- **Multi-arch**: Supports x86_64 and ARM64 (RPi, Jetson CPU mode)

## Quick Start

```bash
# 1. Build
./build.sh

# 2. Run (default: bash)
./run.sh

# Or use docker compose directly
docker compose up runtime
docker compose down
```

## Usage

### Runtime

```bash
./build.sh                       # Build (default: runtime)
./build.sh --no-env test         # Build without refreshing .env
./run.sh                         # Start (default: runtime)
./exec.sh                        # Enter running container
./stop.sh                        # Stop and remove containers

docker compose build runtime     # Equivalent command
docker compose up runtime        # Start
docker compose exec runtime bash # Enter running container
```

### Testing (test)

Smoke tests run automatically during build; build fails if tests fail.

```bash
./build.sh test
# or
docker compose --profile test build test
```

## Configuration

### .env Parameters

| Variable | Description | Example |
|----------|-------------|---------|
| `DOCKER_HUB_USER` | Docker Hub username | `myuser` |
| `IMAGE_NAME` | Image name | `sick_humble` |

## Architecture

### Docker Build Stage Diagram

```mermaid
graph TD
    EXT1["bats/bats:latest"]
    EXT2["alpine:latest"]
    EXT3["ros:humble-ros-base-jammy"]

    EXT1 --> bats-src["bats-src"]
    EXT2 --> bats-ext["bats-extensions"]

    EXT3 --> runtime["runtime\nsick_safetyscanners2_interfaces + sick_safetyscanners_base"]

    bats-src --> test["test (ephemeral)\nsmoke tests, discarded after build"]
    bats-ext --> test
    runtime --> test

```

### Stage Description

| Stage | FROM | Purpose |
|-------|------|---------|
| `bats-src` | `bats/bats:latest` | Bats binary source, not shipped |
| `bats-extensions` | `alpine:latest` | bats-support, bats-assert, not shipped |
| `lint-tools` | `alpine:latest` | ShellCheck + Hadolint, not shipped |
| `runtime` | `ros:humble-ros-base-jammy` | SICK Safety Scanner packages |
| `test` | `runtime` | Lints + smoke tests, discarded after build |

## Smoke Tests

See [TEST.md](doc/test/TEST.md) for details.

## Directory Structure

```text
sick_humble/
├── compose.yaml                 # Docker Compose definition
├── Dockerfile                   # Multi-stage build
├── build.sh                     # Build script
├── run.sh                       # Run script
├── exec.sh                      # Enter running container
├── stop.sh                      # Stop and remove containers
├── .env.example                 # Environment variable template
├── .hadolint.yaml               # Hadolint ignore rules
├── script/
│   └── entrypoint.sh            # Container entrypoint
├── doc/
│   ├── README.zh-TW.md          # Traditional Chinese
│   ├── README.zh-CN.md          # Simplified Chinese
│   └── README.ja.md             # Japanese
├── .github/workflows/           # CI/CD
│   ├── main.yaml                # Main pipeline
│   ├── build-worker.yaml        # Docker build + smoke test
│   └── release-worker.yaml      # GitHub Release
└── test/
    └── smoke/              # Bats environment tests
        ├── ros_env.bats
        ├── script_help.bats
        └── test_helper.bash
```
