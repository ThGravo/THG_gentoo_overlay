# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic cmake-utils

DESCRIPTION="f2c'ed version of LAPACK"
HOMEPAGE="http://www.netlib.org/clapack/"
SRC_URI="http://www.netlib.org/${PN}/${P}-CMAKE.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-libs/libf2c-20090407-r1
	virtual/blas"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-CMAKE

PATCHES=(
	"${FILESDIR}/${P}-fix_include_file.patch"
	"${FILESDIR}/${P}-noblasf2c.patch"
	"${FILESDIR}/${P}-hang.patch"
	"${FILESDIR}/${P}-findblas-r7.patch"
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-cmake_LDFLAGS.patch"
)

# bug 433806
RESTRICT="test"

src_prepare() {
	rm INCLUDE/f2c.h F2CLIBS/libf2c/f2c.h || die
	cmake-utils_src_prepare
}

src_configure() {
	#filter-flags -ftree-vectorize
	# causes an internal compiler error with gcc-4.6.2

	local mycmakeargs=( -DENABLE_TESTS=$(usex test) )
	cmake-utils_src_configure
}
