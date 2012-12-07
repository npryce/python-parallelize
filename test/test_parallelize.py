
import os
import multiprocessing
from ctypes import c_int
from parallelize import parallelize, per_item


def test_runs_loop_body_in_process_per_cpu_by_default():
    cpus = multiprocessing.cpu_count()
    pids = multiprocessing.Array(c_int, 100)
    sequence = range(100)
    
    for i in parallelize(sequence):
        pids[i] = os.getpid()
    
    assert len(set(pids)) == cpus

def test_can_run_loop_body_in_process_per_item():
    pids = multiprocessing.Array(c_int, 10)
    sequence = range(10)
    
    for i in parallelize(sequence, fork=per_item):
        pids[i] = os.getpid()
    
    assert len(set(pids)) == len(sequence)
    
