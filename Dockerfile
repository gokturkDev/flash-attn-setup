FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV PYTHONUNBUFFERED=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # make poetry create the virtual environment in the project's root
    # it gets named `.venv`
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    EXTRAS="all" \
    PYTHON="python3.10"

RUN apt-get update && apt-get install build-essential python3-dev $PYTHON-venv $PYTHON curl -y 
WORKDIR /app

RUN pip install torch==2.1.0

RUN wget https://github.com/Dao-AILab/flash-attention/releases/download/v2.3.5/flash_attn-2.3.5+cu118torch2.1cxx11abiTRUE-cp310-cp310-linux_x86_64.whl
RUN pip install flash_attn-2.3.5+cu118torch2.1cxx11abiTRUE-cp310-cp310-linux_x86_64.whl

