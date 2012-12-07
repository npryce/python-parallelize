python-parallelize
==================

Simple fork/join parallelism with Python's for loop


Quick Start
-----------

To parallelise iteration with a process per CPU:

    import os
    from parallelize import parallelize
    
    for i in parallelize(range(100)):
        print(os.getpid(), i)

To parallelise iteration with a process per item:

    import os
    from parallelize import parallelize, per_item
    
    for i in parallelize(range(100), fork=per_item):
        print(os.getpid(), i)
