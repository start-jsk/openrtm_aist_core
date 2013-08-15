#!/usr/bin/env python

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

d = generate_distutils_setup(
    packages=['OpenRTM_aist', 'OpenRTM_aist.utils', 'OpenRTM_aist.RTM_IDL',
              'OpenRTM_aist.RTM_IDL.RTC', 'OpenRTM_aist.RTM_IDL.RTC__POA',
              'OpenRTM_aist.RTM_IDL.RTM', 'OpenRTM_aist.RTM_IDL.RTM__POA',
              'OpenRTM_aist.RTM_IDL.SDOPackage', 'OpenRTM_aist.RTM_IDL.SDOPackage__POA',
              'OpenRTM_aist.RTM_IDL.OpenRTM', 'OpenRTM_aist.RTM_IDL.OpenRTM__POA'
              ],
    package_dir={'': 'lib/python2.7/site-packages' }
)

setup(**d)
