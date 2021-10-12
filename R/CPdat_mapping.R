# AUTHOR: Jenny Kay
# PURPOSE: Attempt to create master CPDat spreadsheet for mapping
# STARTED: 2021-10-12
# written in version: R version 4.1.0 (2021-05-18)



#assuming these libraries will be useful?
library(tidyverse)
library(readxl)
library(stringr)

# This assigns the folder where the R script lives to workingdir
workingdir <- dirname(rstudioapi::getActiveDocumentContext()$path)
# This sets the working directory to workingdir
setwd(workingdir)


getwd()
options(stringsAsFactors = FALSE)


#### Chemical glossaries ####

#This is a glossary from CompTox dashboard linking CAS numbers to DTXSIDs and chemical names
chemids <- read_excel("Dsstox_CAS_number_name.xlsx") %>% 
  rename(CASRN = casrn, DTXSID = dsstox_substance_id)


#CPDat chem_dictionary useful columns: A = chemical_id, D = preferred_name 
#   (i.e., common name), E = preferred_casrn, F = DTXSID
chem_dictionary <- read.csv("./original files/chemical_dictionary_20201216.csv", header = TRUE)%>% 
  mutate(preferred_name = coalesce(preferred_name, raw_chem_name)) %>% 
  # I attempted to clean up some of the raw CASRNs by removing leading zeroes (next line of code), 
  #    but raw_casrn and preferred_casrn are both kind of disasters... 
  #    some got converted to dates along the way, others are missing numbers.
  #    For the purpose of my paper, these adjustments were sufficient to capture my chems of interest.
  #    Others wanting to use CPDat should be aware of major issues with CAS numbers 
  mutate(raw_casrn = str_replace(raw_casrn, pattern = "(?<![0-9])0+", replacement = "")) %>% 
  # In general, raw_casrn is better than preferred
  mutate(CASRN = coalesce(raw_casrn, preferred_casrn)) %>% 
  subset(select = -c(raw_casrn, preferred_casrn, raw_chem_name, curation_level)) %>% 
  # Since some chemicals are only given CAS numbers and others only get DTXSIDs, 
  #    I tried to capture everything by joining the CASRN-DTXSID dictionary from both sides 
  left_join(chemids, by = "CASRN") %>% 
  mutate(DTXSID = coalesce(DTXSID.y, DTXSID.x)) %>% 
  subset(select = -c(DTXSID.x, DTXSID.y)) %>% 
  left_join(chemids, by = "DTXSID") %>% 
  mutate(CASRN = coalesce(CASRN.y, CASRN.x)) %>% 
  subset(select = -c(CASRN.x, CASRN.y)) %>% 
  mutate(preferred_name = coalesce(preferred_name, preferred_name.x, preferred_name.y)) %>% 
  select(chemical_id, CASRN, DTXSID, preferred_name) %>% 
  unique()


# Document dictionary
# for documents that categorization terms are derived from
doc_dict <- read.csv("./original files/document_dictionary_20201216.csv")




########### List Presence #############
# Match chemicals to "list presence" - keywords that define/describe chemicals on lists in public documents
# list presence files have cassettes (as opposed to the specific functional uses in use_dictionary)
# Description of "list presence" from CPDat documentation: "Documents from many 
#    different sources describing the presence of chemicals on lists within 
#    public documents related to chemical use, exposure scenario, 
#    chemical occurrence, or regulatory purview."
list_presence <- read.csv("./original files/list_presence_data_20201216.csv", header = TRUE)

list_pres_dict <- read.csv("./original files/list_presence_dictionary_20201216.csv") %>% 
  rename(kind_list = kind)

lists <- left_join(list_presence, list_pres_dict, by = "list_presence_id") 


#create df with chemical names paired with list cassettes
chem_lists <- inner_join(chem_dictionary, lists, by = "chemical_id") %>% 
  unique()


#### Validate "list" category assignments 
# Document dictionary can be useful to check that list presence classifications 
#      are consistent with the products associated 

chem_lists_n_docs <- left_join(chem_lists, doc_dict, by = "document_id") %>% 
  unique()



########## Product Composition / PUC #############
# Match chemicals to product composition and PUC
# CPDat documentation describes product composition data as coming from 
#     "documents from product manufacturers concerning ingredient and chemical 
#      composition of consumer products, typically in the form of SDS, MSDS, 
#      and product ingredient disclosure documents."

PUC_dictionary <- read.csv("./original files/PUC_dictionary_20201216.csv") %>% 
  rename(kind_PUC = kind)

#Product Composition Data matches chemical_id to puc_id
product_composition <- read.csv("./original files/product_composition_data_20201216.csv")

#Name the chems in products
chem_products <- full_join(chem_dictionary, product_composition, by = "chemical_id") %>% 
  subset(select = -c(classification_method, raw_min_comp:clean_max_wf))


#Match PUCs in dictionary to chems
chem_puc <- full_join(chem_products, PUC_dictionary, by = "puc_id") %>% 
  unique()


###### List Presence + PUC #########
# Combine list presence and product composition data for comprehensive list
# of exposure sources identified in CPDat

lists_docs_PUCs <- full_join(chem_lists_n_docs, chem_puc, by = "chemical_id") %>% 
  rename(CASRN = CASRN.x, DTXSID = DTXSID.x, preferred_name = preferred_name.x, 
         document_id = document_id.x) %>%
  subset(select = -c(doc_date:document_id.y)) %>% 
  unique()
  



##### Functional use #####

func_dict <- read.csv("./original files/functional_use_dictionary_20201216.csv", header = TRUE)

func_data <- read.csv("./original files/functional_use_data_20201216.csv", header = TRUE)

func_uses <- full_join(func_data, func_dict, by = "functional_use_id") %>% 
  mutate(chemical_id = coalesce(chemical_id.x, chemical_id.y)) %>% 
  select(chemical_id, document_id, functional_use_id, report_funcuse, oecd_function) %>% 
  unique()


funcs_docs <- left_join(func_uses, doc_dict, by = "document_id") %>% 
  unique()



##### List presence + PUC + functional uses #####

lists_docs_PUCs_func <- full_join(lists_docs_PUCs, func_uses, by = "chemical_id") %>% 
  unique()  
  


lists_funcs_docs <- full_join(funcs_docs, lists, by = "document_id") %>% 
  unique()



