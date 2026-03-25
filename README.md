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
    EXT1["bats/bats:latest"]:::external
    EXT2["alpine:latest"]:::external
    EXT3["ros:humble-ros-base-jammy"]:::external

    EXT1 --> bats-src["bats-src"]:::tool
    EXT2 --> bats-ext["bats-extensions"]:::tool

    EXT3 --> runtime["runtime\nsick_safetyscanners2_interfaces + sick_safetyscanners_base"]:::stage

    bats-src --> test["test  ⚡ ephemeral\nsmoke tests, discarded after build"]:::ephemeral
    bats-ext --> test
    runtime --> test

    classDef external fill:#555,color:#fff,stroke:#999
    classDef tool fill:#8B6914,color:#fff,stroke:#c8960c
    classDef stage fill:#1a5276,color:#fff,stroke:#2980b9
    classDef ephemeral fill:#6e2c00,color:#fff,stroke:#e67e22,stroke-dasharray:5 5
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

Located in `test/smoke_test/` — executed automatically during `docker build --target test` — **22 tests** total.

<details>
<summary>Click to expand test details</summary>

#### ROS environment (3)

| Test | Description |
|------|-------------|
| `ROS_DISTRO` | Is set |
| `setup.bash` | File exists |
| `setup.bash` | Can be sourced |

#### SICK packages (2)

| Test | Description |
|------|-------------|
| `sick_safetyscanners2_interfaces` | Package installed via `dpkg` |
| `sick_safetyscanners_base` | Package installed via `dpkg` |

#### System (1)

| Test | Description |
|------|-------------|
| `entrypoint.sh` | Exists and executable |

#### Script help (16)

| Test | Description |
|------|-------------|
| `build.sh -h` | Exits 0 |
| `build.sh --help` | Exits 0 |
| `build.sh -h` | Prints usage |
| `run.sh -h` | Exits 0 |
| `run.sh --help` | Exits 0 |
| `run.sh -h` | Prints usage |
| `exec.sh -h` | Exits 0 |
| `exec.sh --help` | Exits 0 |
| `exec.sh -h` | Prints usage |
| `stop.sh -h` | Exits 0 |
| `stop.sh --help` | Exits 0 |
| `stop.sh -h` | Prints usage |
| `build.sh -h` | Detects zh from `LANG=zh_TW.UTF-8` |
| `build.sh -h` | Detects ja from `LANG=ja_JP.UTF-8` |
| `build.sh -h` | Defaults to en for `LANG=en_US.UTF-8` |
| `build.sh -h` | `SETUP_LANG` overrides `LANG` |

</details>

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
    └── smoke_test/              # Bats environment tests
        ├── ros_env.bats
        ├── script_help.bats
        └── test_helper.bash
```
