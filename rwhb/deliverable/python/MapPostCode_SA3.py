import os
import xlrd
from urllib import request
from datetime import datetime
import zipfile
class MapPostCodeSA:

    path = "C:"+os.sep+"Users"+os.sep+"persnal"+os.sep+"Desktop"+os.sep+"SEP-Nostradata"
    url = "http://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&1270055006_cg_postcode_2011_sa3_2011.zip&1270.0.55.006&Data%20Cubes&07308A67BF786E9FCA257A4B0014E971&0&July%202011&31.07.2012&Latest"
    workbook_name = "1270055006_CG_POSTCODE_2011_SA3_2011.xls"
    new_file_name = "POSTCODE_SA3"
    start_row = 5
    end_row_offset = 3
    start_col = 1
    end_col = 2

    def __init__(self):

        self.postcodeSA3directory = os.path.join(MapPostCodeSA.path, MapPostCodeSA.workbook_name)
        self.postCodeLines = self.readFile()

    def downloadFile(self):

       try:
           r=request.urlretrieve(MapPostCodeSA.url,MapPostCodeSA.new_file_name+datetime.now().strftime('%Y-%m-%d')+".zip")
           return os.path.join(MapPostCodeSA.path,MapPostCodeSA.new_file_name+datetime.now().strftime('%Y-%m-%d')+".zip")

       except ConnectionError:
           print("Bad Connection")
       except FileNotFoundError:
           print ("File not Found")

    def unzipFile(self,filePath):
        zip_ref = zipfile.ZipFile(filePath, 'r')
        zip_ref.extractall(MapPostCodeSA.path)
        zip_ref.close()

    def readFile(self):

        postcode_sa = []

        try:
            xlsfile = self.postcodeSA3directory
            workbook = xlrd.open_workbook(xlsfile)

            sheet = workbook.sheet_by_name("Table 3")

            for row in range(MapPostCodeSA.start_row,sheet.nrows-MapPostCodeSA.end_row_offset):

                postcode_sa.append(sheet.cell(row,1).__repr__().split(":")[1]+","+sheet.cell(row,2).__repr__().split(":")[1])

            return postcode_sa

        except FileNotFoundError:
            print("File Not Found error")



    def writeFile(self,filename):

        file = filename + "_" + datetime.now().strftime('%Y-%m-%d')+"_.csv"

        with open(file,"w") as f:
            for elem in self.postCodeLines:
                f.write(elem)
                f.write("\n")

if __name__ == "__main__":

    os.chdir(MapPostCodeSA.path)
    msa = MapPostCodeSA()
    zipfilePath = msa.downloadFile()
    msa.unzipFile(zipfilePath)
    msa.readFile()
    msa.writeFile(MapPostCodeSA.new_file_name)

