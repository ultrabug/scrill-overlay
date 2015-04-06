# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} pypy2_0 )

inherit distutils-r1

DESCRIPTION="Low-level, data-driven core of boto 3"
HOMEPAGE="https://github.com/boto/botocore https://pypi.python.org/pypi/botocore"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="=dev-python/requests-1.2.0
	>=dev-python/six-1.1.0
	=dev-python/jmespath-0.0.2
	>=dev-python/python-dateutil-2.1"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RESTRICT="test"

DOCS=( README.rst )

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}