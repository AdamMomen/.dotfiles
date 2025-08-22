# Minimal Ubuntu container to test bootstrap/install scripts
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip \
      python3 python3-venv python3-pip pipx \
      stow tmux openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for testing
RUN useradd -ms /bin/bash dev && \
    usermod -aG sudo dev || true
USER dev
WORKDIR /home/dev

# Prepare home directories often used by scripts
RUN mkdir -p /home/dev/.local/bin /home/dev/.dotfiles
ENV PATH=/home/dev/.local/bin:${PATH}

# Copy repo (assumes docker build context is repo root)
COPY --chown=dev:dev . /home/dev/.dotfiles
WORKDIR /home/dev/.dotfiles

# Ensure test and bootstrap scripts are executable
RUN chmod +x /home/dev/.dotfiles/bootstrap/*.sh || true && \
    chmod +x /home/dev/.dotfiles/tests/run.sh || true

# Default command opens a shell for manual testing
CMD ["bash"]


