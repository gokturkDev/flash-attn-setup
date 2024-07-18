FROM nvcr.io/nvidia/pytorch:24.06-py3

RUN pip install flash_attn
RUN python test.py