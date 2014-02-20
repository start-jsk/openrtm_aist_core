#!/usr/bin/env python

PKG = 'openrtm_aist'
import roslib; roslib.load_manifest(PKG)  # This line is not needed with Catkin.

import os
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
from subprocess import call, check_output, Popen, PIPE

PID = 0
## A sample python unit test
class TestCompile(unittest.TestCase):
    ## test 1 == 1
    def test_compile_pkg_config(self):
        global PID
        ret = call("gcc -o openrtm-sample-pkg-config /tmp/%d-openrtm-sample.cpp `pkg-config openrtm-aist --cflags --libs`"%(PID), shell=True)
        self.assertTrue(ret==0)

    def test_compile_rtm_config(self):
        global PID
        ret = call("gcc -o openrtm-sample-pkg-config /tmp/%d-openrtm-sample.cpp `rosrun openrtm_aist rtm-config --cflags --libs`"%(PID), shell=True)
        self.assertTrue(ret==0)
        self.assertTrue(True)

    def _test_share(self):
        # check if rtshell runs
        print os.path.join(check_output(['rospack','find','openrtm_aist']).rstrip(), "share/openrtm-1.1/example/rtc.conf")
        self.assertTrue(os.path.exists(os.path.join(check_output(['rospack','find','openrtm_aist']).rstrip(), "share/openrtm-1.1/example/rtc.conf")))

if __name__ == '__main__':
    import rostest
    global PID
    PID = os.getpid()
    f = open("/tmp/%d-openrtm-sample.cpp"%(PID),'w')
    f.write(code)
    f.close()
    rostest.rosrun(PKG, 'test_openrtm_aist', TestCompile) 



