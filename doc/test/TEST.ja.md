# テストドキュメント

**41 件のテスト**。

## test/smoke/ros_env.bats

### ROS environment (3)

| テスト項目 | 説明 |
|------------|------|
| `ROS_DISTRO is set` | ROS_DISTRO environment variable is set |
| `ROS 2 setup.bash exists` | `/opt/ros/${ROS_DISTRO}/setup.bash` exists |
| `ROS 2 setup.bash can be sourced` | ROS 2 setup script sources without error |

### SICK packages (2)

| テスト項目 | 説明 |
|------------|------|
| `sick_safetyscanners2_interfaces is installed` | `ros-${ROS_DISTRO}-sick-safetyscanners2-interfaces` package installed |
| `sick_safetyscanners_base is installed` | `ros-${ROS_DISTRO}-sick-safetyscanners-base` package installed |

### Base tools (3)

| テスト項目 | 説明 |
|------------|------|
| `git is available` | git command works |
| `sudo is available` | sudo command works |
| `sudo passwordless works` | sudo runs without password |

### System (5)

| テスト項目 | 説明 |
|------------|------|
| `User is not root` | Container user is not root |
| `HOME is set and exists` | HOME is set and directory exists |
| `Timezone is Asia/Taipei` | Timezone configured correctly |
| `LANG is en_US.UTF-8` | LANG locale set |
| `entrypoint.sh exists and executable` | `/entrypoint.sh` is executable |

### Workspace (1)

| テスト項目 | 説明 |
|------------|------|
| `Work directory exists` | `${HOME}/work` directory exists |

## template/test/smoke/script_help.bats

### build.sh (3)

| テスト項目 | 説明 |
|------------|------|
| `build.sh -h exits 0` | Help exits successfully |
| `build.sh --help exits 0` | Help exits successfully |
| `build.sh -h prints usage` | Help output contains "Usage:" |

### run.sh (3)

| テスト項目 | 説明 |
|------------|------|
| `run.sh -h exits 0` | Help exits successfully |
| `run.sh --help exits 0` | Help exits successfully |
| `run.sh -h prints usage` | Help output contains "Usage:" |

### exec.sh (3)

| テスト項目 | 説明 |
|------------|------|
| `exec.sh -h exits 0` | Help exits successfully |
| `exec.sh --help exits 0` | Help exits successfully |
| `exec.sh -h prints usage` | Help output contains "Usage:" |

### stop.sh (3)

| テスト項目 | 説明 |
|------------|------|
| `stop.sh -h exits 0` | Help exits successfully |
| `stop.sh --help exits 0` | Help exits successfully |
| `stop.sh -h prints usage` | Help output contains "Usage:" |

### LANG auto-detect (4)

| テスト項目 | 説明 |
|------------|------|
| `build.sh detects zh from LANG=zh_TW.UTF-8` | Detects Traditional Chinese |
| `build.sh detects ja from LANG=ja_JP.UTF-8` | Detects Japanese |
| `build.sh defaults to en for LANG=en_US.UTF-8` | Defaults to English |
| `build.sh SETUP_LANG overrides LANG` | SETUP_LANG takes priority |

## template/test/smoke/display_env.bats

### Wayland env vars (3)

| テスト項目 | 説明 |
|------------|------|
| `compose.yaml contains WAYLAND_DISPLAY env` | WAYLAND_DISPLAY in compose.yaml |
| `compose.yaml contains XDG_RUNTIME_DIR env` | XDG_RUNTIME_DIR in compose.yaml |
| `compose.yaml contains XAUTHORITY env` | XAUTHORITY in compose.yaml |

### Display mounts (4)

| テスト項目 | 説明 |
|------------|------|
| `compose.yaml mounts XDG_RUNTIME_DIR as rw` | XDG_RUNTIME_DIR mounted read-write |
| `compose.yaml mounts XAUTHORITY volume` | XAUTHORITY volume mounted |
| `compose.yaml has no consecutive duplicate keys` | No YAML duplicate key errors |
| `compose.yaml mounts X11-unix volume` | X11 socket mounted |

### xhost branching (4)

| テスト項目 | 説明 |
|------------|------|
| `run.sh contains XDG_SESSION_TYPE check` | Session type detection present |
| `run.sh calls xhost +SI:localuser on wayland` | Wayland xhost command correct |
| `run.sh calls xhost +local: on X11` | X11 xhost command correct |
| `run.sh defaults to X11 xhost when XDG_SESSION_TYPE unset` | Falls back to X11 |
