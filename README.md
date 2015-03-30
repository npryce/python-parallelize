python-parallelize
==================

Simple fork/join parallelism with Python's `for` loop


Quick Start
-----------

Parallel iteration with a process/CPU:

```python
import os
from parallelize import parallelize
    
for i in parallelize(range(100)):
    print(os.getpid(), i)
```

Parallel iteration with a process/item:

```python
import os
from parallelize import parallelize, per_item
    
for i in parallelize(range(100), fork=per_item):
    print(os.getpid(), i)
```
