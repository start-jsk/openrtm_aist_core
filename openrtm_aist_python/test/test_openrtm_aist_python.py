#!/usr/bin/env python

PKG = 'openrtm_aist_python'
import roslib; roslib.load_manifest(PKG)  # This line is not needed with Catkin.

import os
import sys
import unittest

from subprocess import call, check_output, Popen, PIPE

## A sample python unit test
class TestCode(unittest.TestCase):
    ## test 1 == 1
    def test_import_rtc(self):
        import OpenRTM_aist
        import RTC
        self.assertTrue(True)

    def test_import_rtcd(self):
        import OpenRTM_aist.utils.rtcd
        self.assertTrue(True)

    def test_manager_init(self):
        import OpenRTM_aist
        import RTC
        mgr = OpenRTM_aist.Manager.init(sys.argv)
        self.assertTrue(True)

#unittest.main()
if __name__ == '__main__':
    import rostest
    rostest.rosrun(PKG, 'test_openrtm_aist_python', TestCode)



