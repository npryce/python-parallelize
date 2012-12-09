#!/usr/bin/env python

import os
from distutils.core import setup


setup(name='python-parallelize',
      version='1.0.0.0',
      description='Make the for loop run in parallel',
      author='Nat Pryce',
      author_email='about-python-parallelize@natpryce.com',
      url='http://github.com/npryce/python-parallelize',
      
      license="Apache 2.0",
      
      classifiers = [
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Programming Language :: Python',
        'Natural Language :: English',
        'Topic :: Software Development',
      ],

      provides=['parallelize'],
      py_modules=['parallelize']
)
