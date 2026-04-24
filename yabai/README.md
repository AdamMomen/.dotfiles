# Yabai Configuration

## Scripting Addition Patch (macOS Sequoia)

If you're on macOS Sequoia (15.x) and yabai window movement isn't working, you may need to apply the PAC ABI patch.

### The Issue
- Yabai v7.1.16+ is built with PAC ABI v1 (caps 0x81)
- Dock.app on macOS Sequoia uses PAC ABI v0 (caps 0x80)
- The kernel blocks injection when versions don't match
- Error: `could not spawn remote thread: (os/kern) protection failure`

See: https://github.com/asmvik/yabai/issues/2686

### Apply the Patch

```bash
# Run this after installing/updating yabai via Homebrew
sudo bash ~/ghq/github.com/adammomen/.dotfiles/yabai/scripts/patch-loader.sh

# Or if you have ~/.local/bin in your PATH:
sudo yabai-patch-loader
```

Then reload the scripting addition:
```bash
sudo yabai --load-sa
```

### When to Reapply

You need to reapply this patch after:
- Running `brew upgrade yabai`
- Reinstalling yabai
- The patch modifies: `/Library/ScriptingAdditions/yabai.osax/Contents/MacOS/loader`

The patch persists across reboots but not yabai updates.
