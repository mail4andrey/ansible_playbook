FROM gliderlabs/alpine:latest

RUN \
  apk-install \
    curl \
    g++ \
    gcc \
    libffi-dev \
    make \
    openssh-client \
    openssl-dev \
    python \
    python-dev \
    python3-dev \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip setuptools python-keyczar pycrypto cryptography ansible pywinrm requests-credssp && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

# RUN \
#   curl -fsSL https://releases.ansible.com/ansible/ansible-latest.tar.gz -o ansible.tar.gz && \
#   tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
#   rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
