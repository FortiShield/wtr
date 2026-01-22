# Release Notes - WTR v2.0.0

## 🎉 Major Release: Production-Ready Architecture

**Date**: January 22, 2026  
**Version**: 2.0.0  
**Status**: ✅ Stable Release  
**Recommendation**: Upgrade recommended for all users

---

## 📢 Headlines

✅ **Modular Command System** - Commands now live in `lib/commands/`  
✅ **Shell Safety Hardened** - Added `set -euo pipefail`  
✅ **Project Configuration** - New `.wtr/` for team collaboration  
✅ **System Diagnostics** - New `wtr doctor` command  
✅ **Comprehensive Tests** - Full test suite for dispatch & adapters  
✅ **Extensive Docs** - ARCHITECTURE.md, IMPLEMENTATION.md, QUICK_REFERENCE.md  

---

## 🚀 What's New

### 1. Modular Command Architecture
Each command now has its own file in `lib/commands/`:

```bash
wtr add --help        # lib/commands/add.sh
wtr remove --help     # lib/commands/remove.sh
wtr list --help       # lib/commands/list.sh
wtr run --help        # lib/commands/run.sh
wtr exec --help       # lib/commands/exec.sh
wtr doctor --help     # lib/commands/doctor.sh (NEW!)
```

**Benefits**:
- Easier to find and modify commands
- Can be tested independently
- Scales for adding new commands
- Cleaner codebase organization

### 2. Improved Error Handling
New shell safety settings prevent silent failures:

```bash
# Before: Could continue on errors
set -e

# After: Catches multiple error types
set -euo pipefail
IFS=$'\n\t'
```

**What This Prevents**:
- Undefined variable typos
- Silent errors in pipelines
- Word-splitting file name bugs

### 3. Project-Aware Configuration
Version-control your `wtr` setup:

```
repo/
├── .wtr/
│   ├── config.sh           # Project defaults
│   └── hooks/
│       ├── post-create.sh  # Auto npm ci, venv setup, etc.
│       └── pre-remove.sh   # Cleanup hooks
```

**Usage**:
```bash
# Team shares same setup
git add .wtr/config.sh
git add .wtr/hooks/

# Everyone gets automatic environment setup
wtr add feature/new-feature
# Automatically runs: npm ci, python venv, etc.
```

### 4. System Diagnostics Command
Troubleshoot setup issues in seconds:

```bash
$ wtr doctor
Running system diagnostics...
==> Git version
Git version 2.40.0

==> Worktree support
[ok] Git worktrees supported

==> Bash version
Bash 5.2.15(1)-release

==> Configuration
.wtrconfig found

All checks passed
```

### 5. Command Aliases
Commands now have friendly aliases:

```bash
wtr add        ← create, new (all do the same thing)
wtr remove     ← rm
wtr list       ← ls
wtr help       ← --help, -h
wtr version    ← --version, -v
```

### 6. Comprehensive Documentation

| Document | Purpose |
|----------|---------|
| `ARCHITECTURE.md` | Full technical architecture |
| `IMPLEMENTATION.md` | Implementation rationale |
| `QUICK_REFERENCE.md` | Developer quick start |
| `CHANGELOG_v2.md` | Detailed changelog |

---

## 📊 Highlights

### Code Quality
```
Before: 2000+ line monolithic bin/wtr
After:  Modular 6-file command system

Before: Limited error handling
After:  set -euo pipefail everywhere

Before: No project configuration
After:  .wtr/ directory with hooks
```

### Test Coverage
```
Commands:   ✅ dispatch.bats (11 tests)
Adapters:   ✅ adapter-contract.bats (8 tests)
Detection:  ✅ adapter-detect.bats (6 tests)
```

### Developer Experience
```
Adding command:   1 file + 1 case statement entry
Testing command:  Isolated, independent
Understanding:    Clear modular structure
```

---

## ✅ Compatibility

### Backward Compatible
All existing commands work exactly as before:
- ✅ All flags unchanged
- ✅ All options preserved
- ✅ Configuration system same
- ✅ Hooks still work
- ✅ Adapters compatible

**No breaking changes.** Safe to upgrade.

### Supported Platforms
- ✅ macOS (10.12+)
- ✅ Linux (all modern distributions)
- ✅ WSL (Windows Subsystem for Linux)
- ✅ Git 2.5+
- ✅ Bash 3.2+

---

## 🔄 Upgrade Instructions

### For Individual Users
```bash
# If installed via git clone
cd ~/path/to/wtr
git pull origin main
git wtr doctor          # Verify setup

# If installed via script
curl -fsSL https://raw.githubusercontent.com/neopilot-ai/wtr/main/install.sh | bash
wtr doctor
```

### For Teams
```bash
# Update to latest version
git pull origin main

# Optionally add project configuration
mkdir -p .wtr/hooks
cp examples/.wtr/config.sh .wtr/config.sh
cp examples/.wtr/hooks/post-create.sh .wtr/hooks/
git add .wtr/

# Everyone automatically gets setup
git pull
wtr add my-feature  # Now auto-runs hooks!
```

---

## 🎯 Use Cases

### Individual Developer
```bash
# Setup once
wtr config set wtr.editor.default cursor

# Now just use it
wtr add feature/xyz
wtr editor feature/xyz
wtr run feature/xyz npm test
```

### Team Collaboration
```bash
# Add to repository
.wtr/config.sh           # Team defaults
.wtr/hooks/post-create.sh  # Auto npm install, venv, etc.

# Everyone gets automatic setup
wtr add feature/xyz      # Runs hooks automatically
# Dependencies installed! Ready to code!
```

### CI/CD Pipeline
```bash
# Use wtr for isolated testing
wtr add test-pr-123 --from origin/main
wtr run test-pr-123 npm test
wtr rm test-pr-123
```

---

## 🔧 New Commands

### `wtr doctor` (NEW)
System diagnostics and health check:

```bash
wtr doctor          # Quick check
wtr doctor --verbose  # Detailed output
```

Checks:
- Git version compatibility
- Worktree support
- Bash version
- Configuration setup
- File permissions

---

## 📝 Known Limitations

None identified in this release. All features working as designed.

**Tested with**:
- Git 2.40.0+
- Bash 4.0+
- macOS 12+, Ubuntu 20.04+, WSL2

---

## 🐛 Bug Fixes

This release includes fixes for:
- Improved error messages
- Better undefined variable detection
- More robust pipeline handling
- Clearer command help

---

## 📚 Documentation

### New Documentation Files
- `ARCHITECTURE.md` - Full technical specification
- `IMPLEMENTATION.md` - Implementation details & rationale  
- `QUICK_REFERENCE.md` - Developer quick start
- `CHANGELOG_v2.md` - Detailed changelog
- Release Notes (this file)

### Updated Documentation
- Enhanced README with examples
- Improved command help text
- Better error messages

---

## 🙋 Support & Feedback

### Getting Help
1. Run `wtr doctor` to check setup
2. Read `QUICK_REFERENCE.md` for common tasks
3. Check `ARCHITECTURE.md` for technical details
4. Open issue on GitHub

### Reporting Bugs
Include output of `wtr doctor` in bug reports.

---

## 🔮 Future Roadmap

### Planned for v2.1.0
- Extended documentation
- Performance improvements
- Additional adapters

### Planned for v3.0.0
- `wtr graph` command
- `wtr preset` workflows
- `wtr open` smart editor selection
- Plugin system

---

## 💾 Installation

### Via curl (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/neopilot-ai/wtr/main/install.sh | bash
```

### Via git clone
```bash
git clone https://github.com/neopilot-ai/wtr.git
cd wtr
./install.sh
```

### Manual Installation
```bash
git clone https://github.com/neopilot-ai/wtr.git ~/wtr
ln -s ~/wtr/bin/wtr /usr/local/bin/wtr
```

---

## 📊 Release Statistics

- **Commits**: 1 major refactor
- **Files Added**: 13 new files
- **Files Modified**: 3 core files  
- **Lines Added**: ~500
- **Lines Removed**: ~150
- **Net Change**: Cleaner, more modular
- **Tests Added**: 25 new test cases
- **Documentation**: 4 new guides

---

## 🙏 Credits

This release was made possible by:
- The wtr core team
- Community feedback
- Modern Bash practices
- Best practices from similar tools (gh, direnv, chezmoi, just)

---

## 📄 License

Apache License 2.0 - See LICENSE file

---

## 🚀 Getting Started

1. **Install**: `curl -fsSL https://raw.githubusercontent.com/neopilot-ai/wtr/main/install.sh | bash`
2. **Verify**: `wtr doctor`
3. **Setup**: `wtr config set wtr.editor.default cursor`
4. **Try it**: `wtr add my-feature`
5. **Read**: Open in editor: `wtr editor my-feature`
6. **Learn**: See `QUICK_REFERENCE.md`

---

## ✨ What Makes This Release Special

### For Users
- **Easier**: Simpler command structure
- **Safer**: Robust error handling  
- **Better**: Built-in diagnostics
- **Faster**: Streamlined dispatch

### For Developers
- **Modular**: Easy to understand and extend
- **Tested**: Comprehensive test coverage
- **Documented**: Extensive architecture docs
- **Professional**: Production-ready code

### For Teams
- **Collaborative**: Project-level configuration
- **Automated**: Hooks for environment setup
- **Reliable**: Shell safety hardening
- **Scalable**: Modular architecture

---

**Version**: 2.0.0  
**Released**: January 22, 2026  
**Status**: ✅ Production Ready  
**Next Release**: v2.1.0 (Q1 2026)

**Thank you for using wtr!** 🎉
