Processors: GetFtp --> PutS3Object
Conjs:
GetFtp:   HostName: ftp2.bom.gov.au
          Username: anonymous
		  Remote path: /anon/gen/clim_data/IDCKWCDEA0/tables/
		  File filter Regex: .*csv
		  Search Recursively: TRUE
		  
PutS3Obeject:  ("sepnostradata" is my personal S3 bucket, 
    Access key ID	               Secret access key
AKIAI4SW72OALAXRB6AA	n86ekBXnqZvItefXngBVbf5k546/rqF+YNF2j5uR
    use yours instead for the test, if you cannot log into this) 
              Bucket: sepnostradata/${absolute.path:substring(31,${absolute.path:length()})}
              keys: as above
			  region: ap-SE-2