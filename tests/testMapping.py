import unittest
import CPDatSSI

class TestMapping(unittest.TestCase):


    def test_broadexposure(self):

        pr_database = "/mnt/d/database/CPDat/CPDatRelease20201216/"
        #l_CASRN = ["106-50-3", "128-95-0", "2243-62-1", "112-38-9", "82-44-0", "2110-18-1", "100-42-5"]
        l_CASRN = ["100-42-5"]
        self.c_CPDAT = CPDatSSI.CPDatSSI(pr_database)
        self.c_CPDAT.loadMapping()
        self.c_CPDAT.listCasToFunct(l_CASRN)
        out = self.c_CPDAT.extractBoardExposure("./tests/test.csv", "./tests/test_tmp.csv")
        print(out)

    """
    def test_mappingByListCASRN(self):
        ## testing
        pr_database = "/mnt/d/database/CPDat/CPDatRelease20201216/"
        l_CASRN = ["106-50-3", "128-95-0", "2243-62-1", "112-38-9", "82-44-0", "2110-18-1"]
        self.c_CPDAT = CPDatSSI.CPDatSSI(pr_database)
        self.c_CPDAT.listCasToFunct(l_CASRN)
        self.assertEqual(1, 1)


    def test_mappingIndividualCASRN(self):
    
        # load the data
        pr_database = "/mnt/d/database/CPDat/CPDatRelease20201216/"
        self.c_CPDAT = CPDatSSI.CPDatSSI(pr_database)
        self.c_CPDAT.loadMapping()

        pr_database = "/mnt/d/database/CPDat/CPDatRelease20201216/"
        CASRN = "106-50-3"
        d_map = self.c_CPDAT.casrnToFunctions(CASRN)
        self.assertEqual(1, 1)
    """

if __name__ == '__main__':
    unittest.main()