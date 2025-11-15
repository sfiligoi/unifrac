# ----------------------------------------------------------------------------
# Copyright (c) 2025-, UniFrac development team.
#
# Distributed under the terms of the Modified BSD License.
#
# The full license is in the file LICENSE, distributed with this software.
# ----------------------------------------------------------------------------

import ctypes
import numpy as np
from skbio import DistanceMatrix
from unifrac._binutil import get_dll as get_unibin_dll

class MatFullFP64(ctypes.Structure):
    _fields_ = [
        ("n_samples", ctypes.c_uint),
        ("flags", ctypes.c_uint),
        ("matrix", ctypes.POINTER(ctypes.c_double)),
        ("sample_ids", ctypes.POINTER(ctypes.c_char_p)),
    ]

class MatFullFP32(ctypes.Structure):
    _fields_ = [
        ("n_samples", ctypes.c_uint),
        ("flags", ctypes.c_uint),
        ("matrix", ctypes.POINTER(ctypes.c_float)),
        ("sample_ids", ctypes.POINTER(ctypes.c_char_p)),
    ]



#
# Functions that compute Unifrac and return a memory object
#

def libssu_from_file(biom_filename: str, tree_filename: str,
                     unifrac_method: str, variance_adjust: bool,
                     alpha: float, bypass_tips: bool,
                     n_substeps: int) -> DistanceMatrix:
    """Execute a call to Strided State UniFrac via the binary API

    Parameters
    ----------
    biom_filename : str
        A filepath to a BIOM 2.1 formatted table (HDF5)
    tree_filename : str
        A filepath to a Newick formatted tree
    unifrac_method : str
        The requested UniFrac method, one of {unweighted,
        unweighted_unnormalized, weighted_normalized, weighted_unnormalized,
        generalized, unweighted_fp64, unweighted_unnormalized_fp64,
        weighted_normalized_fp64, weighted_unnormalized_fp64, generalized_fp64,
        unweighted_fp32, unweighted_unnormalized_fp32,
        weighted_normalized_fp32, weighted_unnormalized_fp32, generalized_fp32}
    variance_adjust : bool
        Whether to perform Variance Adjusted UniFrac
    alpha : float
        The value of alpha for Generalized UniFrac; only applies to
        Generalized UniFraca
    bypass_tips : bool
        Bypass the tips of the tree in the computation. This reduces compute
        by about 50%, but is an approximation.
    n_substeps : int
        The number of substeps to use.

    Returns
    -------
    skbio.DistanceMatrix
        The resulting distance matrix

    Raises
    ------
    ValueError
        If the table is empty
        If the table is not completely represented by the phylogeny
        If an unknown method is requested.
    Exception
        If an unkown error is experienced
    """
    # TODO: Hardcoded for now
    normalize_sample_counts = True
    subsample_depth = 0
    subsample_with_replacement = True

    dll = get_unibin_dll()
    # convert inputs to ctypes representation
    ct_biom_filename = ctypes.c_char_p(biom_filename.encode('utf-8'))
    ct_tree_filename = ctypes.c_char_p(tree_filename.encode('utf-8'))
    ct_unifrac_method = ctypes.c_char_p(unifrac_method.encode('utf-8'))
    ct_variance_adjust = ctypes.c_bool(variance_adjust)
    ct_alpha = ctypes.c_double(alpha)
    ct_bypass_tips = ctypes.c_bool(bypass_tips)
    ct_normalize_sample_counts = ctypes.c_bool(normalize_sample_counts)
    ct_n_substeps = ctypes.c_uint(n_substeps)
    ct_subsample_depth = ctypes.c_uint(subsample_depth)
    ct_subsample_with_replacement = ctypes.c_bool(subsample_with_replacement)
    ct_mmap_dir = ctypes.c_char_p() # NULL

    is_fp32 = ('_fp64' not in unifrac_method)

    if is_fp32: # use 32bit variant
        ct_out_result = ctypes.POINTER(MatFullFP32)()
        rc = dll.one_off_matrix_fp32_v3(ct_biom_filename,
                                        ct_tree_filename,
                                        ct_unifrac_method,
                                        ct_variance_adjust, ct_alpha,
                                        ct_bypass_tips,
                                        ct_normalize_sample_counts,
                                        ct_n_substeps,
                                        ct_subsample_depth,
                                        ct_subsample_with_replacement,
                                        ct_mmap_dir,
                                        ctypes.byref(ct_out_result))
    else: # use fp64 variant
        ct_out_result = ctypes.POINTER(MatFullFP64)()
        rc = dll.one_off_matrix_v3(ct_biom_filename,
                                   ct_tree_filename,
                                   ct_unifrac_method,
                                   ct_variance_adjust, ct_alpha,
                                   ct_bypass_tips,
                                   ct_normalize_sample_counts,
                                   ct_n_substeps,
                                   ct_subsample_depth,
                                   ct_subsample_with_replacement,
                                   ct_mmap_dir,
                                   ctypes.byref(ct_out_result))
    if (rc!=0):
        raise Exception("one_off_matrix failed, rc=%i"%rc)   
 
    n_samples = ct_out_result.contents.n_samples
    # we effectively pass ownership of the matrix buffer to p_matrix
    p_matrix = np.ctypeslib.as_array(ct_out_result.contents.matrix,
                                     [n_samples,n_samples])
    ct_out_result.contents.matrix = None # prevent double free

    ids = []
    for i in range(n_samples):
      # decode makes a copy, so don't need after
      ids.append(ct_out_result.contents.sample_ids[i].decode('utf-8'))

    if is_fp32:
        dll.destroy_mat_full_fp32(ctypes.byref(ct_out_result))
    else:
        dll.destroy_mat_full_fp64(ctypes.byref(ct_out_result))


    # if we got here, everything went well
    return DistanceMatrix(p_matrix, ids)

