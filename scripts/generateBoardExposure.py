from os import path
import sys, getopt
import CPDatSSI

# This will get the name of this file
script_name = path.basename(__file__)


def help():
   
   help_to_print = f'''
    {script_name} -i input file -o output file -d database folder path [-t temporary file of mapping]
    
    Read a list of chemicals in casrn format and write a csv file output with the board exposure
    
    examples:
      
            # Generate the mapping in output
            {script_name} -i list_casrn.txt -o output.csv -d /CPDat/CPDatRelease20201216/
            
        Read list of chemicals, load the CPDat dataset and map on a board exposure. 
       
            # Generate temporary file of the CPDat mapping
            {script_name} -i list_casrn.txt -o output.csv -d /CPDat/CPDatRelease20201216/ -t
            
    -i input_file
        Path of the input file in txt format, one casrn by line
        
    -o output_file
        Output file path, will generate a csv table with chemicals with the board exposure
    
    -d database folder
        path to the directory including the CPDat database (version 20201216). 
        Database available at (https://epa.figshare.com/articles/dataset/The_Chemical_and_Products_Database_CPDat_MySQL_Data_File/5352997)
        Folder need to include:
        - CPDatRelease20201216.docx    - chemical_dictionary_20201216.csv
        - list_presence_data_20201216.csv - HHE_data_20201216.csv
        - document_dictionary_20201216.csv - list_presence_dictionary_20201216.csv
        - PUC_dictionary_20201216.csv  - functional_use_data_20201216.csv
        - product_composition_data_20201216.csv - QSUR_data_20201216.csv
        - functional_use_dictionary_20201216.csv

   [ -t temporary_file
        Generate a temporary file with the CPDat mapping with the different category ]
      
   [ -v verbose]

    -h 
    --help 
        print this message
    
   '''
   
   print (help_to_print)
   print()


def main(argv):
   inputfile = ''
   outputfile = ''
   databasefolder = ''
   tempfile = False
   verbose = False

   try:
      opts, args = getopt.getopt(argv,"hvti:o:d:",["ifile=","ofile=","database=", "tempfile=","verbose="])
   except getopt.GetoptError:
      print ('wrapper.py -i <inputfile> -o <outputfile> -d <databasefolder>')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         help()
         sys.exit()
      elif opt in ("-i", "--ifile"):
         inputfile = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
      elif opt in ("-d", "--database"):
         databasefolder = arg 
      elif opt in ("-t", "--tempfile"):
         tempfile = True
      elif opt in ("-v", "--verbose"):
         verbose = True

   if inputfile == "" or outputfile == "" or databasefolder == "":
      print("Error - missing argument")
      help()
      return

   if verbose == True:
      print('Input file is "', inputfile)
      print('Output file is "', outputfile)
      print('Database folder is ', databasefolder)
      print('Temporary file ?', tempfile)
      print()

   # first open file and generate list of casrn
   if not path.exists(inputfile):
      print("Error - input file is not existing")
      help()
      return
   
   filin = open(inputfile, "r")             
   l_casrn = filin.readlines()
   l_casrn = [casrn.strip() for casrn in l_casrn]
   
   
   # load database
   c_cpdat = CPDatSSI.CPDatSSI(pr_database=databasefolder)
   c_cpdat.loadMapping()
   #except:
   #   print("Error - database folder inexisting or nor complete")
   #   help()
   #   return

   if tempfile == True:
      p_temp = path.dirname(outputfile) + "/tmp.csv"
      c_cpdat.listCasToFunct(l_casrn, p_temp)
   else:
      c_cpdat.listCasToFunct(l_casrn)
   c_cpdat.extractBoardExposure(outputfile)



if __name__ == "__main__":
   main(sys.argv[1:])

