# WinUAE GDB Server Patch

## Overview

This fork adds **register write** (P, G) and **memory write** (M) commands to the [BartmanAbyss WinUAE fork](https://github.com/BartmanAbyss/WinUAE)'s GDB server, which was previously read-only. This enables full read-write debugging of Amiga 68k programs via the GDB Remote Serial Protocol.

Used by the [mcp-winuae-emu](https://github.com/axewater/mcp-winuae-emu) MCP server to give AI assistants direct hardware-level access to an emulated Amiga.

## What Was Changed

### `od-win32/barto_gdbserver.cpp`
1. **PacketSize increased**: `char buf[512]` -> `char buf[65536]`, `PacketSize=512` -> `PacketSize=65536`
2. **P command**: Write single register (D0-D7, A0-A7, SR, PC). Uses `m68k_dreg(regs, n)`, `m68k_areg(regs, n)`, `regs.pc`, `regs.sr` + `MakeFromSR()`.
3. **G command**: Write all 18 registers from 144-char hex string. Calls `MakeFromSR()` once at end.
4. **M command**: Write memory bytes. Uses `debug_safe_addr()` + `ad->bput()` (inverse of existing read handler's `ad->bget()`).

### `od-win32/winuae_msvc15/winuae_msvc.vcxproj`
- Fixed output path to `$(SolutionDir)..\..\build\` (was a hardcoded local path).

## Pre-built Binary

Download `winuae-gdb.exe` from the [Releases](https://github.com/axewater/WinUAE/releases) page.

## Building from Source

### Prerequisites
- Visual Studio 2022 Build Tools (MSVC 14.44+)
- Windows SDK 10.0.26100.0+
- [NASM](https://www.nasm.us/) (for `fpux86_80.asm`)
- WinUAE build dependencies: download [winuaeinclibs.zip](https://download.abime.net/winuae/files/b/winuaeinclibs.zip) and extract to `C:\dev`

### Build Steps

```batch
:: Install NASM if not present
choco install nasm -y

:: Build (use build_with_nasm.bat if NASM isn't in your PATH)
cd C:\Scripts\WinUAE
build.bat
```

Output: `build\winuae.exe` (rename to `winuae-gdb.exe`).

- Solution: `od-win32/winuae_msvc15/winuae_msvc.sln`
- Configuration: Release | Win32

## Technical Notes

- `MakeFromSR()` is critical when writing SR -- without it, CPU flags get out of sync
- `regs.pc = val` is correct (not `m68k_setpc()`) because the debug exit path re-syncs pointers
- The build is Win32 (32-bit) to match the original BartmanAbyss binary
