# homebrew-tap

[![CI](https://github.com/AntonFill/homebrew-tap/actions/workflows/ci.yml/badge.svg)](https://github.com/AntonFill/homebrew-tap/actions/workflows/ci.yml)

Homebrew formulae for a family of local-first CLI tools that make personal data usable without it ever leaving your Mac.

## Install

```sh
brew tap antonfill/tap
brew install mail2md      # or: brew install antonfill/tap/mail2md
```

Tapping is optional. `brew install antonfill/tap/<tool>` works on its own.

## Formulae

| Formula | What it does | Repository |
|---|---|---|
| `mail2md` | Converts `.eml` files to Markdown with YAML frontmatter, for Obsidian vaults, paperless archives and AI-ready data pipelines | [AntonFill/mail2md](https://github.com/AntonFill/mail2md) |
| `realdate` | Reads a leading date from a filename and writes it into the macOS creation and modification timestamps, so the Finder sorts by what a document is about rather than when it was downloaded | [AntonFill/realdate](https://github.com/AntonFill/realdate) |

Both are Swift command-line tools and require macOS 13 or later.

## Built from source

This tap ships no bottles. Every install compiles the tool from the released tag, which is why Xcode is a build dependency. CI does the same on each change here: it audits both formulae, builds them from their tag tarball and runs their test blocks, so a broken checksum or a formula that no longer compiles shows up before anyone installs it.
