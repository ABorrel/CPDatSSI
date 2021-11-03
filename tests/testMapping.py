import unittest
import CPDatSSI

class TestMapping(unittest.TestCase):

    
    def test_mappingIndividualCASRN(self):

        pr_database = "/mnt/d/database/CPDat/CPDatRelease20201216/"
        CASRN = "106-50-3"
        c_CPDAT = CPDatSSI.CPDatSSI(pr_database)
        c_CPDAT.loadMapping()
        d_map = c_CPDAT.casrnToFunctions(CASRN)
        print(d_map)
        self.assertEqual(1, 1)
    
    
    def test_mappingByListCASRN(self):
        ## testing
        pr_database = "/mnt/d/database/CPDat/CPDatRelease20201216/"
        l_CASRN = ["106-50-3", "128-95-0", "2243-62-1", "112-38-9", "82-44-0", "2110-18-1"]
        c_CPDAT = CPDatSSI.CPDatSSI(pr_database)
        c_CPDAT.listCasToFunct(l_CASRN)
        print(c_CPDAT.d_casrn_mapped)
        self.assertEqual(1, 1)

if __name__ == '__main__':
    unittest.main()