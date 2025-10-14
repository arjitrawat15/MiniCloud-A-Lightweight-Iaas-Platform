import os
import logging
from pathlib import Path
import re

# -----------------------
# Configure logging
# -----------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

def log_action(action: str, filename: str):
    """
    Logs actions performed on files (upload/download/delete)
    """
    logging.info(f"{action.upper()} - {filename}")


# -----------------------
# Safe file name
# -----------------------
def safe_filename(filename: str) -> str:
    """
    Sanitize filename to remove unsafe characters
    """
    filename = Path(filename).name  # remove directory paths
    filename = re.sub(r"[^A-Za-z0-9._-]", "_", filename)  # replace unsafe chars
    return filename


# -----------------------
# File size helpers
# -----------------------
def get_file_size(file_path: str) -> int:
    """
    Returns file size in bytes
    """
    if os.path.exists(file_path):
        return os.path.getsize(file_path)
    return 0

def human_readable_size(size_bytes: int) -> str:
    """
    Convert bytes to human-readable format
    """
    for unit in ["B", "KB", "MB", "GB", "TB"]:
        if size_bytes < 1024:
            return f"{size_bytes:.2f} {unit}"
        size_bytes /= 1024
    return f"{size_bytes:.2f} PB"
