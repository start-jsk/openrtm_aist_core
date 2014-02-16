#!/usr/bin/env python

PKG = 'openrtm_aist'
import roslib; roslib.load_manifest(PKG)  # This line is not needed with Catkin.

import sys
import unittest

code = """
#include <rtm/Manager.h>
int main (int argc, char** argv)
{
  RTC::Manager* manager;
  manager = RTC::Manager::init(argc, argv);
  return 0;
}
"""
from subprocess import call, Popen, PIPE

## A sample python unit test
class TestCompile(unittest.TestCase):
    ## test 1 == 1
    def test_compile_pkg_config(self):
        ret = call("gcc -o openrtm-sample-pkg-config openrtm-sample.cpp `pkg-config openrtm-aist --cflags --libs`", shell=True)
        self.assertTrue(ret==0)

    def test_compile_rtm_config(self):
        ret = call("gcc -o openrtm-sample-pkg-config openrtm-sample.cpp `rosrun openrtm_aist rtm-config --cflags --libs`", shell=True)
        self.assertTrue(ret==0)
        self.assertTrue(True)

if __name__ == '__main__':
    import rostest
    f = open('openrtm-sample.cpp','w')
    f.write(code)
    f.close()
    rostest.rosrun(PKG, 'test_compile_openrtm_aist', TestCompile) 



