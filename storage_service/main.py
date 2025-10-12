from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import FileResponse
import os

# Initialize FastAPI app
app = FastAPI(
    title="MiniCloud Object Storage Service",
    description="A lightweight S3-like object storage microservice for MiniCloud",
    version="1.0.0"
)

# Define storage directory
STORAGE_DIR = os.path.join(os.path.dirname(__file__), "storage")
os.makedirs(STORAGE_DIR, exist_ok=True)


@app.get("/")
def root():
    """
    Root endpoint - simple health check
    """
    return {"message": "MiniCloud Object Storage Service is running 🚀"}


@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    """
    Upload a file to the storage directory
    """
    file_path = os.path.join(STORAGE_DIR, file.filename)
    try:
        with open(file_path, "wb") as f:
            contents = await file.read()
            f.write(contents)
        return {"message": "✅ File uploaded successfully!", "filename": file.filename}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/list")
def list_files():
    """
    List all files in the storage directory
    """
    try:
        files = os.listdir(STORAGE_DIR)
        return {"files": files, "count": len(files)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/download/{filename}")
def download_file(filename: str):
    """
    Download a specific file
    """
    file_path = os.path.join(STORAGE_DIR, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(file_path, filename=filename)


@app.delete("/delete/{filename}")
def delete_file(filename: str):
    """
    Delete a specific file
    """
    file_path = os.path.join(STORAGE_DIR, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="File not found")
    os.remove(file_path)
    return {"message": f"🗑️ File '{filename}' deleted successfully"}
