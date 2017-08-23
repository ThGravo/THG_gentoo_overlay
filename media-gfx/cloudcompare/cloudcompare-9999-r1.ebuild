# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-utils eutils

DESCRIPTION="3D point cloud processing software"
HOMEPAGE="http://www.danielgm.net/cc/"
EGIT_REPO_URI="https://github.com/cloudcompare/trunk"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/glew
	sci-mathematics/cgal
	sci-libs/pcl
	sci-libs/mpir
	dev-qt/qtcore:5
	dev-qt/qtopengl:5"

RDEPEND="${DEPEND}"

#PATCHES=("${FILESDIR}/cgal_cmake.patch")

src_configure() {
	local mycmakeargs=""
	mycmakeargs=(
	"${mycmakeargs}"
	-DCMAKE_INSTALL_PREFIX="/usr"
    -DINSTALL_QPCL_PLUGIN=ON
    -DINSTALL_QSRA_PLUGIN=ON
    -DOPTION_USE_DXF_LIB=ON
    -DINSTALL_QPOISSON_RECON_PLUGIN=ON
    -DPOISSON_RECON_WITH_OPEN_MP=ON
    -DINSTALL_QHPR_PLUGIN=ON
    -DINSTALL_QRANSAC_SD_PLUGIN=ON
    -DINSTALL_QKINECT_PLUGIN=OFF
    -DINSTALL_QBLUR_PLUGIN=ON
    -DINSTALL_QPCV_PLUGIN=ON
    -DINSTALL_QDUMMY_PLUGIN=OFF
    -DINSTALL_QCORK_PLUGIN=OFF
    -DINSTALL_QGMMREG_PLUGIN=OFF
	-DINSTALL_QSSAO_PLUGIN=ON
	-DINSTALL_QEDL_PLUGIN=ON
	-DCOMPILE_CC_CORE_LIB_WITH_CGAL=ON
	-DCGAL_DIR="/usr/lib64/cmake"
	-DOPTION_USE_LIBLAS=ON
	-DLIBLAS_INCLUDE_DIR="/usr/include"
	-DLIBLAS_DEBUG_LIBRARY_FILE="/usr/lib64/liblas.so"
	-DLIBLAS_RELEASE_LIBRARY_FILE="/usr/lib64/liblas.so"
	-DFBX_INCLUDE_DIR="/usr/local/include"
	-DFBX_SDK_LIBRARY_FILE="/usr/local/lib/gcc4/x64/release/libfbxsdk.so"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon "${S}"/qCC/images/icon/cc_icon_64.png "${PN}".png
	make_desktop_entry CloudCompare
}
