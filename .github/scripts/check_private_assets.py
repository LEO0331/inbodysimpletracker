"""Fail publication if private health exports, databases, or videos are present."""
import argparse
import json
from pathlib import Path
import re
import subprocess
import sys


PRIVATE_DIRECTORIES = {
    "apple_health_export", "private_health_data", "training_videos",
    "healthbackup", "health_backups",
}
PRIVATE_NAMES = {"export.xml", "export_cda.xml", "export.zip"}
PRIVATE_SUFFIXES = {
    ".healthbackup",
    ".mp4", ".mov", ".m4v", ".avi", ".mkv", ".webm", ".3gp",
    ".sqlite", ".sqlite3", ".db", ".sqlite-wal", ".sqlite-shm",
    ".sqlite3-wal", ".sqlite3-shm", ".db-wal", ".db-shm",
}


def is_private_path(path):
    normalized = str(path).replace("\\", "/").lower()
    parts = normalized.split("/")
    name = parts[-1]
    return (
        any(part in PRIVATE_DIRECTORIES for part in parts)
        or name in PRIVATE_NAMES
        or (
            name.startswith(("healthbackup", "health_backup", "health-backup"))
            and Path(name).suffix in {".zip", ".json", ".enc", ".backup", ".healthbackup"}
        )
        or any(name.endswith(suffix) for suffix in PRIVATE_SUFFIXES)
    )


def has_private_contents(path):
    # Only inspect a bounded prefix, never print patient content.
    with path.open("rb") as source:
        prefix = source.read(65536).lower()
    if path.suffix.lower() == ".xml" and re.search(
        rb"<(?:[a-z_][\w.-]*:)?(?:healthdata|clinicaldocument)\b", prefix
    ):
        return True
    # Renamed encrypted backup files are still personal runtime artifacts.
    try:
        header = json.loads(prefix.split(b"\n", 1)[0].decode("utf-8"))
        return isinstance(header, dict) and header.get("format") == "private-health"
    except (UnicodeError, ValueError):
        return False


def find_private_assets(paths, root):
    return [
        path for path in paths
        if is_private_path(path) or has_private_contents(root / path)
    ]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--web-dir", type=Path)
    args = parser.parse_args()
    if args.web_dir:
        root = args.web_dir.resolve()
        if not root.is_dir():
            parser.error("web build directory does not exist")
        paths = [path.relative_to(root) for path in root.rglob("*") if path.is_file()]
    else:
        root = Path.cwd()
        result = subprocess.run(
            ["git", "ls-files", "-z"], check=True, capture_output=True
        )
        paths = [Path(path) for path in result.stdout.decode("utf-8").split("\0") if path]
    blocked = find_private_assets(paths, root)
    if blocked:
        print(f"Publication blocked: {len(blocked)} private asset(s) detected.", file=sys.stderr)
        print("Remove health exports, databases, backups, and videos from tracked/build assets.", file=sys.stderr)
        return 1
    print("Privacy asset guard passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
