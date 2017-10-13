# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/siftgpu/siftgpu-0.5.400.ebuild,v 0.1 2013/11/19 11:24:12 brothermechanic Exp $

EAPI=5

inherit eutils

DESCRIPTION="A GPU Implementation of SIFT"
HOMEPAGE="http://cs.unc.edu/~ccwu/siftgpu/"
#SRC_URI="http://wwwx.cs.unc.edu/~ccwu/cgi-bin/siftgpu.cgi -> SiftGPU-V400.zip"
SRC_URI="https://repo.acin.tuwien.ac.at/tmp/permanent/SiftGPU-V400.zip"

LICENSE="UNC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda"

DEPEND="media-libs/glew
	media-libs/devil
	dev-util/nvidia-cuda-toolkit
	app-text/dos2unix"
RDEPEND="${DEPEND}"

MAKEOPTS="-j1"

S="${WORKDIR}/SiftGPU"

src_prepare() {
	dos2unix makefile
	if use cuda ; then
		epatch "${FILESDIR}"/with-cuda.patch
	else
		epatch "${FILESDIR}"/no-cuda.patch
	fi
	rm -r include
	sed -i -e's/siftgpu_prefer_glut = 0/siftgpu_prefer_glut = 1/' makefile
	sed -i -e's/siftgpu_sse_options = -march=native -mfpmath=sse/siftgpu_sse_options = -O3 -march=native -mfpmath=sse -std=c++11 -w/' makefile
        sed -i -e's/siftgpu_cuda_options = -arch sm_21 -std=c++11/siftgpu_cuda_options = -arch sm_21 -std=c++11/' makefile
}

src_install() {
	dobin "${S}"/bin/MultiThreadSIFT "${S}"/bin/SimpleSIFT "${S}"/bin/speed "${S}"/bin/TestWinGlut
	dolib "${S}"/bin/libsiftgpu.so
	insinto /usr/include
	doins "${S}"/bin/libsiftgpu.a
	dodoc -r doc data demos
}
