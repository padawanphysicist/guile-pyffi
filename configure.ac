#
# Process this file with autoconf to produce a configure script.
#
AC_PREREQ([2.69])
AC_INIT([guile-pyffi], [0.1.0], [victor_santos@fisica.ufc.br])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([foreign])
m4_ifdef([AM_PROG_AR], [AM_PROG_AR])

# Init libtool
LT_INIT([shared disable-static])

# Checks for programs.
AC_PROG_CC
AM_PATH_PYTHON([3.7])
PKG_CHECK_MODULES([GUILE], [guile-3.0])

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile
		libpyffi/Makefile])

AC_OUTPUT
