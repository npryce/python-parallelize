
from itertools import islice
import os
import multiprocessing


def per_cpu(seq):
    cpu_count = multiprocessing.cpu_count()
    return (islice(seq, cpu, None, cpu_count) for cpu in range(cpu_count))


def per_item(seq):
    return ((i,) for i in seq)


def parallelize(seq, fork=per_cpu):
    pids = []
    
    for slice in fork(seq):
        pid = os.fork()
        if pid == 0:
            for item in slice:
                yield item
            os._exit(0)
        else:
            pids.append(pid)
    
    for pid in pids:
        os.waitpid(pid,0)


