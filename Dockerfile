FROM python:3.7.5-slim
# FROM ubuntu:18.04

# install sshd
RUN apt update && apt install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile && \
    echo "export PATH=$PATH" >> /etc/profile && \
    echo "ldconfig" >> /etc/profile

EXPOSE 22

# install pyenv
RUN apt install -y \
    git \
    curl \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    bzip2 \
    libbz2-dev \
    zlib1g-dev \
    libssl-dev \
    openssl \
    libgdbm-dev \
    libgdbm-compat-dev \
    liblzma-dev \
    libreadline-dev \
    libncursesw5-dev \
    libffi-dev \
    uuid-dev

ENV PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PATH=/root/.pyenv/bin:$PATH' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile

# install jupyterlab
RUN pip install jupyterlab && \
    mkdir ~/.jupyter && \
    echo "\
c.NotebookApp.allow_root = True\n\
c.NotebookApp.ip = '0.0.0.0'\n\
c.NotebookApp.open_browser = False\n\
c.NotebookApp.port = 8888\n\
c.NotebookApp.notebook_dir = '/root/pyprojects'\
" > ~/.jupyter/jupyter_notebook_config.py

# install poetry
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | POETRY_PREVIEW=1 python
RUN pip install --upgrade keyrings.alt && \
    . $HOME/.poetry/env && \
    /root/.poetry/bin/poetry config virtualenvs.in-project true

# ホームを後でマウントできるように一旦退避
RUN mv /root/ /cp_root/ && mkdir /root

COPY start.sh /start.sh
COPY monitoring.py /monitoring.py

EXPOSE 8888

CMD ["/start.sh"]
