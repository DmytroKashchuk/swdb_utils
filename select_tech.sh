#!/bin/bash

# Input files
SITES_FILE="/Users/dmk6603/Documents/swdb_data/USA_aod_2022_google/google_sites.csv"
# snippet
# "SITE_ID","ACCOUNT_ID","SITE_NAME","SITE_TRADE_NAME","SITE_STREET1","SITE_STREET2","SITE_CITY","SITE_POSTAL_STATE","SITE_POSTAL_CODE","SITE_COUNTRY","SITE_PHONE","SITE_FAX","SITE_URL","SITE_URL_DOMAIN","SITE_LANGUAGE","SITE_TYPE","SITE_LEGAL_STATUS","SITE_START_YEAR","SITE_REG_CODE","SITE_VAT_CODE","SITE_EMPLOYEES","SITE_IT_EMPLOYEES","SITE_REVENUE_USD","SITE_REVENUE_EUROS","SITE_REVENUE_POUNDS","SITE_ICT_SPENDING","SITE_HW_SPENDING","SITE_SW_SPENDING","SITE_IT_COMNET_SPENDING","SITE_IT_SERVICES_SPENDING","SITE_IT_STAFF_SPENDING","SITE_TELCO_SPENDING","SITE_VEHICLE_FLEET","SITE_PRI_NAICS6_CODE","SITE_SEC_NAICS6_CODE","SITE_PRI_SIC4_CODE","SITE_SEC_SIC4_CODE","SITE_GOVT_LEVEL","SITE_NACE4_CODE","SITE_CONTINENT","SITE_COUNTRY_GROUPING_CODE","SITE_COUNTRY_CODE","SITE_REGION","SITE_SUBREGION","SITE_STATE","SITE_COUNTY","SITE_CBSA_CODE","SITE_CBSA","SITE_CBSA_TYPE","SITE_CSA_CODE","SITE_CSA","SITE_NUTS1_CODE","SITE_NUTS1_DESC","SITE_NUTS2_CODE","SITE_NUTS2_DESC","SITE_NUTS3_CODE","SITE_NUTS3_DESC","SITE_POSTAL_SECTOR","SITE_LATITUDE","SITE_LONGITUDE","SITE_SERVERS","SITE_WORKSTATIONS","SITE_PCS","SITE_DESKTOPS","SITE_LAPTOPS","SITE_TABLETS","SITE_PRINTERS","SITE_STORAGE","ACCOUNT_EMPLOYEES_DOMESTIC","ACCOUNT_IT_EMPLOYEES_DOMESTIC","ACCOUNT_REVENUE_DOMESTIC","ACCOUNT_NB_SITES_DOMESTIC","ACCOUNT_PCS_DOMESTIC","SITE_AOD_URL"
# "7321842","2321183","Velostrata Inc.","","1600 Amphitheatre Pkwy","","Mountain View","CA","940431351","United States","(408)444-6039","","velostrata.com","","English","HQ","Corporation","2018","","","9","1","1830000","1740000","1490000","141124","8443","23454","4954","37104","43876","23292","0","541511","","7371","","","62.01","North","NA","US","West","Pacific","California","Santa Clara","41940","San Jose-Sunnyvale-Santa Clara CA","MSA","488","San Jose-San Francisco-Oakland CA","","","","","","","","37.4183","-122.0709","2","1","9","6","3","0","5","2365","0","0","258000000000","80","4622","https://ondemand.aberdeen.com/siteProfile/7321842"

TECH_FILE="/Users/dmk6603/Documents/swdb_data/USA_aod_2022/SITES_TECHNOLOGY_clean.txt"
# snippet
# "TECH_ID","SITE_ID","PRODUCT_ID","PRODUCT_VENDOR","PRODUCT","PRODUCT_FIRST_SEEN_DATE","PRODUCT_CONFIDENCE_RANKING"
# "1","367099","6943","Siemens","Siemens SIMATIC Automation Designer","2021-08-01","2"
# "5","1082097","6943","Siemens","Siemens SIMATIC Automation Designer","2020-09-01","2"

OUTPUT_FILE="google_technologies.csv"

# Build unique SITE_ID list (no header, no quotes, no CRLF)
awk -F',' 'NR>1 {id=$1; gsub(/\r/,"",id); gsub(/"/,"",id); print id}' "$SITES_FILE" \
  | sort -u > site_ids.tmp

# Filter technologies by SITE_ID while preserving original formatting
awk -F',' '
  NR==FNR {
    id=$1; gsub(/\r/,"",id); gsub(/"/,"",id);
    sites[id]=1; next
  }
  FNR==1 { print; next }  # keep TECH_FILE header
  {
    sid=$2; gsub(/\r/,"",sid); gsub(/"/,"",sid);
    if (sid in sites) print $0
  }
' site_ids.tmp "$TECH_FILE" > "$OUTPUT_FILE"

rm -f site_ids.tmp
echo "Filtered results saved to $OUTPUT_FILE"
