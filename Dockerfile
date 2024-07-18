FROM nvcr.io/nvidia/pytorch:24.06-py3


WORKDIR /app

RUN apt-get update && apt-get install build-essential python3-dev python3.10-venv python3.10 curl -y 

RUN python -m venv .venv
RUN source .venv/bin/activate
RUN pip install flash_attn

COPY test.py /app


RUN pip install infinity-emb[all]

RUN python3.10 -m infinity_emb.infinity_server:cli --model-id BAAI/bge-small-en-v1.5 --engine torch --preload-only || [ $? -eq 3 ]
ENTRYPOINT ["infinity_emb"]