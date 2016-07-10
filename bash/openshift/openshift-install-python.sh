#!/bin/bash 

#
# This file is part of the FlossWare family of open source software.
#
# FlossWare is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
#

#
# This script will install Python at Openshift.  Note this script has to be run
# at your openshift instance.
#
# To use:
#   openshift-install-python.sh
#

# --------------------------------------------------------------------
# Installing python...
# --------------------------------------------------------------------

cd $OPENSHIFT_TMP_DIR
wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar jxf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure --prefix=$OPENSHIFT_DATA_DIR
make install

# --------------------------------------------------------------------
# Installing setuptools
# --------------------------------------------------------------------

cd $OPENSHIFT_TMP_DIR
wget http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c11.tar.gz
tar zxf setuptools-0.6c11.tar.gz
cd setuptools-0.6c11

$OPENSHIFT_DATA_DIR/bin/python setup.py install

# --------------------------------------------------------------------
# Installing pip
# --------------------------------------------------------------------

cd $OPENSHIFT_TMP_DIR
wget http://pypi.python.org/packages/source/p/pip/pip-1.1.tar.gz
tar zxf pip-1.1.tar.gz
cd pip-1.1

$OPENSHIFT_DATA_DIR/bin/python setup.py install