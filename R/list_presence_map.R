## col B in the list presence 

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