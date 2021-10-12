# AUTHOR: Jenny Kay
# PURPOSE: pull product usages from CPDat for chemicals on mammary 
#           carcinogen and endocrine-active lists
# STARTED: before I knew to put this header in
# written in version: R version 4.1.0 (2021-05-18)


# Last  updated 9/21/21


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

options(scipen=999)


#This is a glossary from CompTox dashboard linking CAS numbers to DTXSIDs and chemical names
chemids <- read_excel("Dsstox_CAS_number_name.xlsx") %>% 
  rename(CASRN = casrn, DTXSID = dsstox_substance_id)



#CPDat chem_dictionary useful columns: A = chemical_id, D = preferred_name 
#   (i.e., common name), E = preferred_casrn, F = DTXSID
chem_dictionary <- read.csv("./original files/chemical_dictionary_20201216.csv", header = TRUE) %>% 
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

  



########### List Presence #############
# Match chemicals to "list presence" - keywords that define/describe chemicals on lists in public documents
# list presence files have cassettes (as opposed to the specific functional uses in use_dictionary)
# Description of "list presence" from CPDat documentation: "Documents from many 
#    different sources describing the presence of chemicals on lists within 
#    public documents related to chemical use, exposure scenario, 
#    chemical occurrence, or regulatory purview."

list_presence <- read.csv("./original files/list_presence_data_20201216.csv", header = TRUE)

list_pres_dict <- read.csv("./original files/list_presence_dictionary_20201216.csv") %>% 
  mutate(jk_cat = case_when(name == "Pesticides" ~ "Pesticide_cp", 
                            #validated term "applied" as pesticides by comparing to lists_n_docs that contains more info
                            name == "applied" ~ "Pesticide_cp", 
                            
                            
                            #CEDI is FDA daily intake of food contact substances
                            #EAFUS is substances added to food
                            #supplements includes pre/probiotics and vitamins - should this be pharma too?
                            str_detect(name, "animal_products|baby_food|CEDI|EAFUS") ~ "Diet_cp",
                            str_detect(name, "dairy|drinking_water|food_additive") ~ "Diet_cp",
                            str_detect(name, "fruits|general_foods|grain|legumes") ~ "Diet_cp", 
                            str_detect(name, "nuts|tobacco") ~ "Diet_cp",
                            name == "supplements" ~ "Diet_cp", 
                            
                            str_detect(name, "ood contact") ~ "Diet_cp, Consumer_cp",
                            
                            #"Substances in" are from canadian lists of chemicals in products
                            #IFRA is list of fragrances in consumer goods
                            #ehicle is for vehicles
                            #"children" is defined as intended for use by children
                            #I wonder if electronics should be industrial too?
                            str_detect(name, "Arts|cotton|Cleaning products") ~ "Consumer_cp",
                            str_detect(name, "consumer|Furniture and Furnishings") ~ "Consumer_cp",
                            str_detect(name, "electronics") ~ "Consumer_cp", 
                            str_detect(name, "Personal care|ehicle|Toys") ~ "Consumer_cp", 
                            str_detect(name, "Substances in") ~ "Consumer_cp", 
                            str_detect(name, "IFRA") ~ "Consumer_cp", 
                            name == "children" ~ "Consumer_cp", 
                            
                            # construction is for materials used in homes (e.g., carpet, fixtures, drywall) 
                            #     appropriate to label as both consumer and indusrial?
                            str_detect(name, "Construction|Home maintenance|Yard") ~ "Consumer_cp, Industrial_cp", 
                            name == "plastic_additive" ~ "Consumer_cp, Industrial_cp",
                            
                            str_detect(name, "fossil_fuels|fracking|manufacturing") ~ "Industrial_cp",
                            kind == "PUC - industrial" ~ "Industrial_cp",
                            
                            name == "pharmaceutical" ~ "Pharma_cp",
                            
                            # covers other water besides drinking (labeled diet above)
                            str_detect(name, "air|agri|emissions|soil|water") ~ "Environment_cp", 
                            
                            # other categories are less specific or harder to interpret 
                            #     (e.g., residue can include pesticides or drugs)
                            #     but the categorizations above still capture the relevant chems for my purpose
                            #     (e.g., pesticide residues are labeled both "residue" and "Pesticides")
                            TRUE ~ "NA")) %>% 
  separate(col = jk_cat, into = paste0("jk_cat", 1:2), sep = ", ") %>% 
  pivot_longer(cols = c(jk_cat1:jk_cat2), names_to = "jk_cat", values_to = "cp_source", values_drop_na = TRUE) %>% 
  subset(select = -c(jk_cat))
                            

lists <- left_join(list_presence, list_pres_dict, by = "list_presence_id")


#create df with chemical names paired with list cassettes
chem_lists <- inner_join(chem_dictionary, lists, by = "chemical_id") 


#### Validate "list" category assignments 
# Document dictionary can be useful to check that list presence classifications 
#      are consistent with the products associated 
doc_dict <- read.csv("./original files/document_dictionary_20201216.csv")

chem_lists_n_docs <- left_join(chem_lists, doc_dict, by = "document_id") %>%
  subset(select = -c(doc_date, chemical_id, document_id, list_presence_id, subtitle)) %>% 
  mutate(cp_source = case_when(
    cp_source == "NA" & str_detect(title, "Corn|Wheat|Soybeans|Sorghum|Spinach") ~ "Diet_cp",
    cp_source == "NA" & str_detect(title, "Lettuce|Blueberries|Bottled Water") ~ "Diet_cp",
    cp_source == "NA" & str_detect(title, "Catfish|Onions|Cucumbers|Celery|Peas") ~ "Diet_cp",
    TRUE ~ cp_source
  )) %>% 
  select(CASRN, DTXSID, preferred_name, cp_source) %>% 
  filter(CASRN != "-") %>% 
  filter(CASRN != "--") %>% 
  filter(CASRN != "---") %>% 
  filter(CASRN != "-00-0") %>% 
  filter(CASRN != "?") %>% 
  unique()
 

#write.csv(chem_lists_docs, "CPDat_chem_lists.csv", row.names = FALSE)



########## Product Composition / PUC #############
# Match chemicals to product composition and PUC
# CPDat documentation describes product composition data as coming from 
#     "documents from product manufacturers concerning ingredient and chemical 
#      composition of consumer products, typically in the form of SDS, MSDS, 
#      and product ingredient disclosure documents."

PUC_dictionary <- read.csv("./original files/PUC_dictionary_20201216.csv") %>% 
  mutate(jk_cat = case_when(str_detect(gen_cat, "pesticides") ~ "Pesticide_cp",
                            prod_fam == "herbicide" ~ "Pesticide_cp, Consumer_cp",
                            
                            # Since plant/garden treatments are applied to the environment, 
                            #     you can be exposed outside whether or not you bought the product
                            #     so I'm including them as both consumer and environment
                            # Other landscape/yard items are not likely for 
                            #     external release, so they're just labeled consumer (below)
                            str_detect(prod_fam, "fertilizer|plants") ~ "Consumer_cp, Environment_cp",
                            
                            # "care" categories under gen_cat includes personal, pet, and household care products  
                            str_detect(gen_cat, "arts|appliances|furniture|sports") ~ "Consumer_cp", 
                            str_detect(gen_cat, "care|consumer|packaging|yard|toy") ~ "Consumer_cp",
                            str_detect(prod_fam, "lock deicer|patch") ~ "Consumer_cp",
                            
                            str_detect(gen_cat, "food contact items") ~ "Consumer_cp, Diet_cp",
                            
                            # These things are probably consumer and industrial 
                            #     because they can likely be used in either setting
                            #     But there's room for different interpretations here...
                            str_detect(gen_cat, "batteries|construction") ~ "Consumer_cp, Industrial_cp",
                            str_detect(prod_fam, "refrigerant") ~ "Consumer_cp, Industrial_cp",
                            
                            
                            # Other items in "home maintenance" are probably safe to just call consumer
                            # Vehicle items all seem appropriate to classify as consumer
                            #     note that road vehicles and mass transit get caught in this
                            #     category which is a little weird, but not an issue for my classifications
                            str_detect(gen_cat, "home|vehicle") ~ "Consumer_cp",
                            
                            str_detect(kind, "O") ~ "Industrial_cp",
                            str_detect(gen_cat, "industrial") ~ "Industrial_cp",
                            
                            TRUE ~ "NA")) %>% 
  separate(col = jk_cat, into = paste0("jk_cat", 1:2), sep = ", ") %>% 
  pivot_longer(cols = c(jk_cat1:jk_cat2), names_to = "jk_cat", values_to = "cp_source", values_drop_na = TRUE) %>% 
  subset(select = -c(jk_cat))


#Product Composition Data matches chemical_id to puc_id
product_composition <- read.csv("./original files/product_composition_data_20201216.csv")


#Name the chems in products
chem_products <- full_join(chem_dictionary, product_composition, by = "chemical_id")


#Match PUCs in dictionary to chems
chem_puc <- full_join(chem_products, PUC_dictionary, by = "puc_id") %>% 
  select(CASRN, DTXSID, preferred_name, cp_source) %>% 
  filter(CASRN != "-") %>% 
  filter(CASRN != "--") %>% 
  filter(CASRN != "---") %>% 
  filter(CASRN != "-00-0") %>% 
  filter(CASRN != "?") %>% 
  unique()



########### List Presence + PUC ##############
# Combine list presence and product composition data for comprehensive list
# of exposure sources identified in CPDat

CPDat_exposources <- full_join(chem_lists_n_docs, chem_puc, by = "CASRN") %>%
  mutate(DTXSID = coalesce(DTXSID.x, DTXSID.y)) %>%
  mutate(preferred_name = coalesce(preferred_name.x, preferred_name.y)) %>% 
  select(CASRN, DTXSID, preferred_name, cp_source.x, cp_source.y) %>% 
  pivot_longer(cols = c(cp_source.x:cp_source.y), names_to = "jk_cat", 
               values_to = "cp_source", values_drop_na = TRUE) %>% 
  subset(select = -c(jk_cat)) %>% 
  filter(cp_source != "NA") %>% 
  unique()
  

#write.csv(CPDat_exposources, "CPDat_exposources.csv", row.names = FALSE)



