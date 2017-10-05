# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Fork of the official LAStools project that only keeps the library section of LAStools"
HOMEPAGE="https://github.com/CGAL/LAStools"
EGIT_REPO_URI="https://github.com/CGAL/LAStools.git"
DEPEND="!sci-geosciences/liblas"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
PATCHES=(
	"${FILESDIR}"/libdir.patch
)

