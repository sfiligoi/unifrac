# ----------------------------------------------------------------------------
# Copyright (c) 2025-, UniFrac development team.
#
# Distributed under the terms of the Modified BSD License.
#
# The full license is in the file LICENSE, distributed with this software.
# ----------------------------------------------------------------------------

import ctypes
import numpy as np
from numbers import Integral

# ====================================================

# Internal, do not use directly
#
# Global values used for caching purposes
#

_unibin_first_try = True
# Set to invalid values
_unibin_dll = None

# ====================================================


def _get_new_unibin_dll():
    """Load unifrac-binaries shared library object, if exists.

    Returns
    -------
    ctypes.CDLL object or None
        Object to invoked external functions, or None, if no shared library found

    Note
    ----
    Should not be used directly, use get_dll instead.

    """
    import os

    try:
        dll = ctypes.CDLL("libssu.so")
        if os.environ.get("UNIFRAC_CPU_INFO", "N") in ("Y", "YES"):
            print("INFO (scikit-bio): Using shared library libssu.so")
    except OSError:
        dll = None
    return dll


def get_dll():
    """Load unifrac-binaries shared library object, if exists.

    Returns
    -------
    ctypes.CDLL object or None
        Object to invoked external functions, or None, if no shared library found

    Note
    ----
    Internally it uses caching, to minimize overhead

    """
    global _unibin_first_try
    global _unibin_dll
    if _unibin_first_try:
        _unibin_dll = _get_new_unibin_dll()
        _unibin_first_try = False
    return _unibin_dll


