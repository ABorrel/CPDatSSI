from os import path
import sys, getopt
import CPDatSSI

# This will get the name of this file
script_name = path.basename(__file__)


def help():
       print (script_name + ' -i <inputfile> -o <outputfile> -d <databasefolder>')


def main(argv):
   inputfile = ''
   outputfile = ''
   databasefolder = ''

   try:
      opts, args = getopt.getopt(argv,"hi:o:d:",["ifile=","ofile=","database="])
   except getopt.GetoptError:
      print ('wrapper.py -i <inputfile> -o <outputfile> -d <databasefolder>')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print ('wrapper.py -i <inputfile> -o <outputfile> -d <databasefolder>')
         sys.exit()
      elif opt in ("-i", "--ifile"):
         inputfile = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
      elif opt in ("-d", "--database"):
         databasefolder = arg 
   
   if inputfile == "" or outputfile == "" or databasefolder == "":
          print("Error - missing argument")
          help()
   
   #print ('Input file is "', inputfile)
   #print ('Output file is "', outputfile)
   #print('Database folder is ', databasefolder)

if __name__ == "__main__":
   main(sys.argv[1:])

