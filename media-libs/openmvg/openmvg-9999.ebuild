# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base cmake-utils git-r3

DESCRIPTION="Open Multiple View Geometry is a library for computer-vision scientists and especially targeted to the Multiple View Geometry community. It is designed to provide an easy access to the classical problem solvers in Multiple View Geometry and solve them accurately."
HOMEPAGE="http://imagine.enpc.fr/~moulonp/openMVG/"
EGIT_REPO_URI="https://github.com/openMVG/openMVG"
SRC_URI=""
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND="
	dev-cpp/eigen
	sci-libs/ceres-solver
	sci-libs/flann
	media-libs/tiff
	media-libs/libpng
	virtual/jpeg
	sci-libs/coinor-clp
	sci-libs/coinor-utils
	sci-libs/coinor-osi
	sci-libs/lemon
	media-libs/glfw
	dev-libs/cereal
"

#src_prepare() {
#	base_src_prepare
# TODO write a patch
	# remove bundled stuff
#	rm -rf src/third_party src/dependencies
#	sed -i \
#		-e '/ADD_SUBDIRECTORY(.*third_party.*)/ d' \
#		CMakeLists.txt || die
#       sed -i \
#                -e '/ADD_SUBDIRECTORY(.*dependencies.*)/ d' \
#                CMakeLists.txt || die
#        sed -i \
#                -e '/INCLUDE_DIRECTORIES(.*dependencies.*)/ d' \
#               	CMakeLists.txt || die
#}

