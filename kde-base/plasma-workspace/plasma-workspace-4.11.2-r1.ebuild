# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-workspace/plasma-workspace-4.11.2-r1.ebuild,v 1.1 2013/10/09 23:04:36 creffett Exp $

EAPI=5

DECLARATIVE_REQUIRED="always"
KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
KMMODULE="plasma"
PYTHON_COMPAT=( python2_{6,7} )
OPENGL_REQUIRED="always"
inherit python-single-r1 kde4-meta

DESCRIPTION="Plasma: KDE desktop framework"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug gps json python qalculate semantic-desktop"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMONDEPEND="
	dev-libs/libdbusmenu-qt
	>=dev-qt/qtcore-4.8.4-r3:4
	!kde-misc/ktouchpadenabler
	$(add_kdebase_dep kactivities)
	$(add_kdebase_dep kdelibs)
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep ksysguard)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libplasmaclock)
	$(add_kdebase_dep libplasmagenericshell)
	$(add_kdebase_dep libtaskmanager)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	gps? ( >=sci-geosciences/gpsd-2.37 )
	json? ( dev-libs/qjson )
	python? (
		${PYTHON_DEPS}
		>=dev-python/PyQt4-4.4.0[X,${PYTHON_USEDEP}]
		$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}")
	)
	qalculate? ( sci-libs/libqalculate )
	semantic-desktop? (
		dev-libs/soprano
		$(add_kdebase_dep nepomuk-core)
		$(add_kdebase_dep kdepimlibs)
	)
"
DEPEND="${COMMONDEPEND}
	dev-libs/boost
	x11-proto/compositeproto
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/renderproto
"
RDEPEND="${COMMONDEPEND}
	$(add_kdebase_dep plasma-runtime)
"

KMEXTRA="
	appmenu/
	ktouchpadenabler/
	statusnotifierwatcher/
"
KMEXTRACTONLY="
	kcheckpass/
	krunner/dbus/org.freedesktop.ScreenSaver.xml
	krunner/dbus/org.kde.krunner.App.xml
	ksmserver/org.kde.KSMServerInterface.xml
	ksmserver/screenlocker/
	libs/kephal/
	libs/kworkspace/
	libs/taskmanager/
	libs/plasmagenericshell/
	libs/ksysguard/
	libs/kdm/kgreeterplugin.h
	ksysguard/
"

KMLOADLIBS="libkworkspace libplasmaclock libplasmagenericshell libtaskmanager"

PATCHES=( "${FILESDIR}/${PN}-4.10.1-noplasmalock.patch" )

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
	fi
	kde4-meta_pkg_setup
}

src_unpack() {
	if use handbook; then
		KMEXTRA+=" doc/plasma-desktop"
	fi

	kde4-meta_src_unpack
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with gps libgps)
		$(cmake-utils_use_with json QJSON)
		$(cmake-utils_use_with python PythonLibrary)
		$(cmake-utils_use_with qalculate)
		$(cmake-utils_use_with semantic-desktop Akonadi)
		$(cmake-utils_use_with semantic-desktop NepomukCore)
		$(cmake-utils_use_with semantic-desktop Soprano)
		-DWITH_Xmms=OFF
	)

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	if use python; then
		python_optimize "${ED}"
	fi
}
