FROM centos/python-36-centos7
MAINTAINER SSE4 <tomskside@gmail.com>

ENV CMAKE_VERSION=3.10.2

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y \
    sudo \
    gcc-c++ \
    glibc-devel \
    glibc-devel.i686 \
    libgcc.i686 \
    libstdc++.i686 \
    make \
    file \
    python-pip \
    python-wheel && \
    yum remove -y cmake && \
    yum upgrade -y python-setuptools && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    curl https://cmake.org/files/v3.10/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz | tar -xz && \
    pip install -q --no-cache-dir --upgrade pip setuptools && \
    pip install -q --no-cache-dir conan && \
    groupadd 1001 -g 1001 && \
    groupadd 1000 -g 1000 && \
    groupadd 2000 -g 2000 && \
    useradd -ms /bin/bash conan -g 1001 -G 1000,2000 && \
    printf "conan:conan" | chpasswd && \
    usermod -aG wheel conan && \
    printf "conan ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

USER conan
WORKDIR /home/conan

RUN mkdir -p /home/conan/.conan

ENV PATH=$PATH:/opt/app-root/src/cmake-${CMAKE_VERSION}-Linux-x86_64/bin
