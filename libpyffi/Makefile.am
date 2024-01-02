lib_LTLIBRARIES = libpyffi.la
libpyffi_la_SOURCES = pyffi.c
libpyffi_la_CFLAGS = $(GUILE_CFLAGS) `python$(PYTHON_VERSION)-config --cflags` 
libpyffi_la_LDFLAGS = -module -shared -avoid-version
