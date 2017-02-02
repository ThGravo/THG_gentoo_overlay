# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils multilib toolchain-funcs flag-o-matic

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://embree.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick +ispc jpeg openexr png static-libs"

RDEPEND="dev-cpp/tbb
	media-libs/freeglut
	imagemagick? (
	   || ( media-gfx/imagemagick[cxx] media-gfx/graphicsmagick[cxx] )
	)
	ispc? ( dev-lang/ispc )
	jpeg? ( virtual/jpeg:0 )
	openexr? ( media-libs/openexr )
	png? ( media-libs/libpng:0 )"
DEPEND="${RDEPEND}"

src_prepare() {
	filter-flags "-march=*"
	sed -e "s:PREFIX}/lib:PREFIX}/$(get_libdir):g" \
		-e "s:lib/cmake:$(get_libdir)/cmake:g" \
		-e "/LICENSE.txt/d" \
		-e "/DIRECTORY tutorials/d" \
		-i common/cmake/package.cmake || die
	sed -e "s/gcc/$(tc-getCC)/" \
		-e "s/g++/$(tc-getCXX)/" \
		-e "s/-fPIC/${CXXFLAGS} &/" \
		-i common/cmake/gcc.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DEMBREE_TUTORIALS=OFF
                -DCMAKE_BUILD_TYPE:STRING=Release
                -DEMBREE_TASKING_SYSTEM:STRING=TBB
                -DTBB_INCLUDE_DIR:PATH=/usr/include
                -DTBB_LIBRARY:FILEPATH=/usr/lib64/libtbb.so
                -DTBB_LIBRARY_MALLOC:FILEPATH=/usr/lib64/libtbbmalloc.so
                -DTBB_ROOT:PATH=/usr
                -DEMBREE_BACKFACE_CULLING:BOOL=OFF
		-DEMBREE_GEOMETRY_HAIR:BOOL=OFF
		-DEMBREE_GEOMETRY_LINES:BOOL=OFF
		-DEMBREE_GEOMETRY_QUADS:BOOL=OFF
		-DEMBREE_GEOMETRY_SUBDIV:BOOL=OFF
		-DEMBREE_GEOMETRY_TRIANGLES:BOOL=ON
		-DEMBREE_GEOMETRY_USER:BOOL=OFF
                -DEMBREE_IGNORE_INVALID_RAYS:BOOL=ON
		-DEMBREE_INTERSECTION_FILTER:BOOL=ON
		-DEMBREE_INTERSECTION_FILTER_RESTORE:BOOL=ON
		$(cmake-utils_use_enable ispc EMBREE_ISPC_SUPPORT)
                -DEMBREE_MAX_ISA:STRING=AVX2
                -DEMBREE_RAY_MASK:BOOL=OFF
                -DEMBREE_RAY_PACKETS:BOOL=OFF
		$(cmake-utils_use_enable static-libs EMBREE_STATIC_LIB)
		$(cmake-utils_use_use jpeg EMBREE_TUTORIALS_LIBJPEG)
		$(cmake-utils_use_use png EMBREE_TUTORIALS_LIBPNG)
		$(cmake-utils_use_use imagemagick EMBREE_TUTORIALS_IMAGE_MAGICK)
		$(cmake-utils_use_use openexr EMBREE_TUTORIALS_OPENEXR)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
}
