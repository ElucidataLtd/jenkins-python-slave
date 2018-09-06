FROM openshift/jenkins-slave-base-centos7

# install "Inline with Upstream Stable" to get most current upstream stable release of Python 3
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm

# install Python 3.6 with pip
RUN yum install -y python36u python36u-pip python36u-devel wget
RUN pip3.6 install virtualenv virtualenvwrapper


RUN wget https://www.sqlite.org/2018/sqlite-autoconf-3240000.tar.gz
RUN tar xvfz sqlite-autoconf-3240000.tar.gz && cd sqlite-autoconf-3240000
RUN yum -y groupinstall "Development Tools" && \
    cd sqlite-autoconf-3240000 && ./configure && make -j4 && make install

RUN rm -rf /usr/bin/sqlite3 && \
    mv /var/lib/origin/sqlite-autoconf-3240000/sqlite3 /usr/bin/


ENV LD_LIBRARY_PATH /usr/local/lib
RUN python3.6 --version && sqlite3 --version && python3.6 -c "import sqlite3; print(sqlite3.sqlite_version)"

# change user to non-root OpenShift usage
RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001

CMD /usr/bin/bash
