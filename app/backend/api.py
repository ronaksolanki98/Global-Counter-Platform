from fastapi import FastAPI

from .handler import _increment_views

app = FastAPI()


@app.get("/views")
def get_views():
    return {"views": _increment_views()}
