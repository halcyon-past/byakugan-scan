#!/usr/bin/env python3
"""
Release notes generator for Byakugan Scan.
Extracts release notes from CHANGELOG.md, injects optional custom announcement messages
after the top heading, and appends direct DMG download references.
"""

import argparse
import os
import re
import sys


def generate_notes(version: str, custom_message: str = "", changelog_path: str = "CHANGELOG.md", repo: str = "halcyon-past/byakugan-scan") -> str:
    lines = [f"# Byakugan Scan v{version}\n"]

    # Optional custom announcement message immediately after heading
    if custom_message and custom_message.strip():
        clean_msg = custom_message.strip()
        lines.append(f"> **Announcement:**\n> {clean_msg}\n")

    # Extract changelog section for this version
    changelog_content = ""
    if os.path.exists(changelog_path):
        with open(changelog_path, "r", encoding="utf-8") as f:
            full_changelog = f.read()

        # Match markdown section ## [version] ... up to the next ## [ or end
        pattern = rf"##\s*\[{re.escape(version)}\][^\n]*\n(.*?)(?=\n##\s*\[|\Z)"
        match = re.search(pattern, full_changelog, re.DOTALL)
        if match:
            changelog_content = match.group(1).strip()

    if changelog_content:
        lines.append(changelog_content)
    else:
        lines.append("See [CHANGELOG.md](CHANGELOG.md) for full change history.")

    # Direct DMG download references
    lines.append("\n---\n")
    lines.append("### 📦 Direct Downloads\n")
    lines.append(f"- 🍎 **Latest Universal DMG:** [`ByakuganScan.dmg`](https://github.com/{repo}/releases/download/v{version}/ByakuganScan.dmg)")
    lines.append(f"- 🏷️ **Versioned DMG:** [`ByakuganScan-v{version}.dmg`](https://github.com/{repo}/releases/download/v{version}/ByakuganScan-v{version}.dmg)")
    lines.append("\n*Requires macOS 14.0 Sonoma or later on Apple Silicon / Intel.*")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Generate release notes for Byakugan Scan")
    parser.add_argument("--version", required=True, help="Release version (e.g. 1.0.0)")
    parser.add_argument("--custom-message", default="", help="Optional announcement message")
    parser.add_argument("--changelog", default="CHANGELOG.md", help="Path to CHANGELOG.md")
    parser.add_argument("--output", default="RELEASE_NOTES.md", help="Output file path")
    parser.add_argument("--repo", default="halcyon-past/byakugan-scan", help="GitHub repo (owner/repo)")

    args = parser.parse_args()

    notes = generate_notes(
        version=args.version,
        custom_message=args.custom_message,
        changelog_path=args.changelog,
        repo=args.repo,
    )

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(notes)

    print(f"✅ Generated release notes in {args.output}")


if __name__ == "__main__":
    main()
