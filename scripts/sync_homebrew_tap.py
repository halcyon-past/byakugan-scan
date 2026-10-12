#!/usr/bin/env python3
"""
Synchronize Byakugan Scan release version and DMG SHA-256 across:
  1. Local Casks/byakugan-scan.rb
  2. Local website/src/app/page.tsx (SHA-256 display & copy button)
  3. Remote halcyon-past/homebrew-tap Casks/byakugan-scan.rb (via GitHub API)

Idempotent by design:
- If the local cask and website already have the exact version & SHA-256, no local git commit is made.
- If the remote halcyon-past/homebrew-tap cask already matches the exact content, no remote commit is made.
"""

import argparse
import base64
import json
import os
import re
import subprocess
import sys
from pathlib import Path


def update_cask_content(content: str, version: str, sha256: str) -> str:
    content = re.sub(
        r'(^\s*version\s+")[^"]+(")',
        rf'\g<1>{version}\g<2>',
        content,
        flags=re.MULTILINE,
    )
    content = re.sub(
        r'(^\s*sha256\s+")[^"]+(")',
        rf'\g<1>{sha256}\g<2>',
        content,
        flags=re.MULTILINE,
    )
    return content


def update_website_page(content: str, sha256: str) -> str:
    short_sha = f"{sha256[:8]}...{sha256[-5:]}"
    # Update truncated SHA-256 label: <span className="text-slate-300 select-all">...</span>
    content = re.sub(
        r'(<span className="text-slate-300 select-all">)[0-9a-f]{8}\.\.\.[0-9a-f]{5}(</span>)',
        rf'\g<1>{short_sha}\g<2>',
        content,
    )
    # Update full SHA-256 clipboard copy string
    content = re.sub(
        r'(navigator\.clipboard\.writeText\(")[0-9a-f]{64}("\))',
        rf'\g<1>{sha256}\g<2>',
        content,
    )
    return content


def run_gh_api(args: list[str], token: str) -> str:
    env = os.environ.copy()
    env["GH_TOKEN"] = token
    result = subprocess.run(
        ["gh", "api", *args],
        env=env,
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


def sync_remote_tap(cask_content: str, version: str, tap_repo: str, token: str) -> bool:
    """Updates Casks/byakugan-scan.rb in halcyon-past/homebrew-tap if different. Returns True if updated."""
    endpoint = f"repos/{tap_repo}/contents/Casks/byakugan-scan.rb"
    raw = run_gh_api([endpoint], token)
    data = json.loads(raw)
    remote_sha = data["sha"]
    remote_content = base64.b64decode(data["content"]).decode("utf-8")

    if remote_content.strip() == cask_content.strip():
        print(f"✅ Remote tap ({tap_repo}) is already up to date at v{version}.")
        return False

    b64_payload = base64.b64encode(cask_content.encode("utf-8")).decode("utf-8")
    commit_msg = f"bump(byakugan-scan): update cask to v{version}"
    out = run_gh_api(
        [
            "--method",
            "PUT",
            endpoint,
            "-f",
            f"message={commit_msg}",
            "-f",
            f"content={b64_payload}",
            "-f",
            f"sha={remote_sha}",
            "--jq",
            ".commit.html_url",
        ],
        token,
    )
    print(f"🚀 Updated remote Homebrew tap ({tap_repo}) to v{version}: {out}")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Sync Homebrew Cask and Website SHA-256.")
    parser.add_argument("--version", required=True, help="Release version without 'v' prefix (e.g. 1.0.4)")
    parser.add_argument("--sha256", required=True, help="64-char hex SHA-256 of ByakuganScan-v<version>.dmg")
    parser.add_argument("--cask-file", default="Casks/byakugan-scan.rb", help="Path to local Cask file")
    parser.add_argument("--website-file", default="website/src/app/page.tsx", help="Path to website page.tsx")
    parser.add_argument("--tap-repo", default="halcyon-past/homebrew-tap", help="Target Homebrew tap repository")
    parser.add_argument("--skip-remote", action="store_true", help="Only update local files")
    args = parser.parse_args()

    version = args.version.lstrip("v").strip()
    sha256 = args.sha256.strip().lower()

    if not re.fullmatch(r"[0-9a-f]{64}", sha256):
        print(f"❌ ERROR: Invalid SHA-256 digest: '{sha256}'", file=sys.stderr)
        return 1

    cask_path = Path(args.cask_file)
    if not cask_path.exists():
        print(f"❌ ERROR: Cask file not found at {cask_path}", file=sys.stderr)
        return 1

    original_cask = cask_path.read_text(encoding="utf-8")
    updated_cask = update_cask_content(original_cask, version, sha256)
    if updated_cask != original_cask:
        cask_path.write_text(updated_cask, encoding="utf-8")
        print(f"✏️  Updated local {cask_path} to v{version} ({sha256[:12]}...)")
    else:
        print(f"✅ Local {cask_path} already matches v{version} ({sha256[:12]}...)")

    web_path = Path(args.website_file)
    if web_path.exists():
        original_web = web_path.read_text(encoding="utf-8")
        updated_web = update_website_page(original_web, sha256)
        if updated_web != original_web:
            web_path.write_text(updated_web, encoding="utf-8")
            print(f"✏️  Updated local {web_path} SHA-256 to {sha256[:12]}...")
        else:
            print(f"✅ Local {web_path} already has SHA-256 {sha256[:12]}...")

    if not args.skip_remote:
        token = os.environ.get("HOMEBREW_TAP_TOKEN") or os.environ.get("GH_TOKEN") or ""
        if not token:
            print("⚠️  WARNING: Neither HOMEBREW_TAP_TOKEN nor GH_TOKEN is set; skipping remote tap update.")
        else:
            sync_remote_tap(updated_cask, version, args.tap_repo, token)

    return 0


if __name__ == "__main__":
    sys.exit(main())
