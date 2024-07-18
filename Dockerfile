FROM nvcr.io/nvidia/pytorch:24.06-py3

RUN pip install flash_attn
WORKDIR /app
COPY test.py /app
RUN python test.py

# Set the working directory for the app

# Define the version of Poetry to install (default is 1.7.1)
# Define the directory to install Poetry to (default is /opt/poetry)
ARG POETRY_VERSION=1.7.1
ARG POETRY_HOME=/opt/poetry

# Create a Python virtual environment for Poetry and install it
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=$POETRY_HOME POETRY_VERSION=$POETRY_VERSION python3.10 -

ENV PATH=$POETRY_HOME/bin:$PATH

# Test if Poetry is installed in the expected path
RUN echo "Poetry version:" && poetry --version

# Copy the rest of the app source code (this layer will be invalidated and rebuilt whenever the source code changes)
COPY poetry.lock poetry.toml pyproject.toml README.md /app/
# Install dependencies only
RUN poetry install --no-interaction --no-ansi --no-root --extras "${EXTRAS}" --without lint,test
COPY infinity_emb infinity_emb
# Install dependency with infinity_emb package
RUN poetry install --no-interaction --no-ansi --extras "${EXTRAS}"  --without lint,test
# remove cache
RUN poetry cache clear pypi --all


RUN infinity_emb v2 --model-id BAAI/bge-small-en-v1.5 --engine torch --preload-only || [ $? -eq 3 ]
ENTRYPOINT ["infinity_emb"]