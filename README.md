# CPDat mapping on exposure
CPDAT (version="20201216") exposure mapping <br>
Folder: /CPDat/CPDatRelease20201216/"

# Project update
- 10-12-21: init git

# Search terms in function description, document id and oecd used 

## Pesticide
>**JK: I feel like antimicrobial and extermination could potentially be consumer too**
- pesticide
- antimicrobial
- fungicide
- extermination
- herbicide
- herbicdisinfectantide
- insecticide

## Industrial
- industrial
- NACE
- coal tar
- raw material
- industrial manufacturing
- industrial fluid
- mining
- manufacturing
- ressource extraction
- rubber processing
- plasticizer
- plasticisers
- catalyst
>**JK: couldn't a UV stabilizer be in consumer products too? Maybe even more likely, since UV isn't likely to be present during industrial manufacturing?**
- uv stabilizer
- flame retardant
- colorants


## Diet
- food and not for food and Nonfood 
- beverage
>**JK: I'd say retail is consumer**
- retail    
- drinking
>**JK: Preservatives aren't necessarily for foods - e.g., phthalates in plastics**
- preservative
- flavouring


## Pharmaceuticals
- drug
- pharma
>**JK: I don't see sunscreen as a pharma product**
- sunscreen agent
 

## Consumer products         
- apparel
- personal care
- arts crafts
- furniture
- child use
- decor
- toy
>**JK: I struggled with electronics... I feel like they could be industrial too/instead since the manufacturing process would be the more likely exposure source rather than a consumer opening up the product**
- electronics
- lawn garden
- sports equipment
- baby use
- pet
- dogs
- cats
- tools
- dental
- toothbrush
>**JK: what about industrial cleaners?**
- clean washing
- soap
- automotive care
- hair dyeing
- skin-care
- hair conditioning
- shampoo
- cosmetic
- perfuming
>**JK: couldn't flame retardant be industrial too?**
- flame retardant 
- parfume
- skin conditioning
- sunscreen agent
>**JK: why is coal tar under consumer? Probably industrial**
- coal tar
- colorants


# Document id mapping
Mapp on the document ID:
- 1373515 #Air Water INC Fine Chemicals List --> Industrial
- 1513117 #Fl@vis Flavouring Substances --> Diet
- 460 #U.S. FDA list of Indirect Additives used in Food Contact Substances; presence of a substance in this list indicates that only certain intended uses and use conditions are authorized by FDA regulations (version of list updated 10/4/2018) --> Diet
>**JK: food contact would be diet, not pesticides, unless pesticides are specified**
- 1372213 #Indirect Additives used in Food Contact Substances --> Pesticides    
- 1365244 #Inert Ingredients Permitted for Use in Nonfood Use Pesticide Products --> Pesticides
>**JK: there are lots of documents for pesticides in foods (corn, wheat, soybeans, broccoli..), and they should be indicated as diet too**
- 1374900 #2007 Pesticide Residues in Blueberries --> Pesticides
>**JK: I think chemical intermediates are more industrial than end product**
- 1371498 #Harmonized Tariff Schedule of the United States (2019) Intermediate Chemicals for Dyes Appendix --> Consumer products
>**JK: another challenging thing with distinguishing consumer and industrial... everything in consumer products was in an industrial process at some point!**
- 453478 #present on the WA State Department of Ecology - Chemicals of High Concern to Children Reporting List (version of list pulled 4/24/2020),pertaining to  or intended for use specifically by children --> Consumer products, Industrial
>**JK: I'm not seeing document 400407471, or anything with this title**
- 400407471 #chemicals measured or identified in environmental media or products,Sources specific to a European country or subset of countries,writing utensils containing liquid or gel ink --> Consumer products
>**JK: another case of consumer, industrial or both?**
- 519 # substances on the International Fragrance Association's ordered register of all fragrance ingredients used in consumer goods by the fragrance industry's customers worldwide --> Consumer products, Industrial
>**JK: I ended up creating a new category for "environmental" b/c of these lists. Also, things in water aren't necessarily pesticides, I would remove that one**
- 392400422 #applied to all data sources used in MN DoH chemical screening proof of concept,chemicals measured or identified in environmental media or products,water intended for drinking  or related to drinking water; includes bottled water  finished water from drinking water treatment plants  and untreated water that has been denoted as a drinking source --> Pesticides, Diet
>**JK: Most pesticides aren't pharma too. And I didn't try to classify from the "chemical residues from drugs or pesticides" list because it's not specific to either**
- 423446 #Relating to pesticides or pesticide usage. Includes specific types of pesticides  e.g. insecticides   herbicides  fungicides  and fumigants; also includes general biocides,chemical residues  typically from drugs or pesticides --> Pesticides, Pharmaceuticals
>**JK: things in the next bullet are just pesticides, not pharma**
- 400423425442446 #chemicals measured or identified in environmental media or products,Relating to pesticides or pesticide usage. Includes specific types of pesticides  e.g. insecticides   herbicides  fungicides  and fumigants; also includes general biocides,general term pertaining to agricultural practices  including the raising and farming of animals and growing of crops,includes fresh  canned and frozen forms  as well as juices and sauces (e.g. applesauce)  excludes forms intended for consumption by young children (i.e. baby foods); includes green beans and peas,chemical residues  typically from drugs or pesticides --> Pesticides, Pharmaceuticals
- 1372195 #Pharmaceutical Appendix (2019) Table 1 --> Pharmaceuticals
- 1372197 #Pharmaceutical Appendix (2019) Table 3 --> Pharmaceuticals


# PUC
>**JK: unfortunately I don't think all PUC things are consumer... things w/ PUC "kind = O" and "gen_cat = industrial" are both --> industrial types**
Chemicals with a PUC --> Consumer products



