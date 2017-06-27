# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-multilib eutils python-any-r1 toolchain-funcs git-r3

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="http://ceres-solver.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/ceres-solver/ceres-solver.git"

LICENSE="sparse? ( BSD ) !sparse? ( LGPL-2.1 ) cxsparse? ( BSD )"
SLOT="0/1"
KEYWORDS=""

IUSE="cxsparse c++11 doc examples gflags lapack openmp +schur sparse test"
REQUIRED_USE="test? ( gflags ) sparse? ( lapack ) doc? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/glog[gflags?]
	cxsparse? ( sci-libs/cxsparse:0= )
	lapack? ( virtual/lapack )
	sparse? (
		sci-libs/amd:0=
		sci-libs/camd:0=
		sci-libs/ccolamd:0=
		sci-libs/cholmod:0=
		sci-libs/colamd:0=
		sci-libs/spqr:0= )"

DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	doc? ( dev-python/sphinx dev-python/sphinx_rtd_theme )
	lapack? ( virtual/pkgconfig )"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		if [[ $(tc-getCXX) == *g++* ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# search paths work for prefix
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i cmake/*.cmake || die

	# remove Werror
	sed -e 's/-Werror=(all|extra)//g' \
		-i CMakeLists.txt || die

	# respect gentoo doc install directory
	sed -e "s:share/doc/ceres:share/doc/${PF}:" \
		-i docs/source/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	# CUSTOM_BLAS=OFF EIGENSPARSE=OFF MINIGLOG=OFF CXX11=OFF
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_EXAMPLES=OFF
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use c++11 CXX11)
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use gflags GFLAGS)
		$(cmake-utils_use lapack LAPACK)
		$(cmake-utils_use openmp OPENMP)
		$(cmake-utils_use schur SCHUR_SPECIALIZATIONS)
		$(cmake-utils_use cxsparse CXSPARSE)
		$(cmake-utils_use sparse SUITESPARSE)
	)
	use sparse || use cxsparse || mycmakeargs+=( -DEIGENSPARSE=ON )
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	dodoc README.md

	if use examples; then
		insinto /usr/share/doc/${PF}
		docompress -x /usr/share/doc/${PF}/examples
		doins -r examples data
	fi
}
