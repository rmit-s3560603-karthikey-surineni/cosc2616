import os
from ftplib import FTP
from datetime import datetime

# ftpPath = "ftp:"+os.sep*2+"ftp2.bom.gov.au"+os.sep+"anon"+os.sep+"gen"+os.sep+"clim_data"+os.sep+"IDCKWCDEA0"+os.sep+"tables"
ftpPath="ftp.bom.gov.au"
fileType = "CLIMATE"

class GetWeatherData:
    def __init__(self):
        self.ftpPath = "ftp.bom.gov.au"
        self.ftp = None
        self.path = []
        self.param = 0
        self.rootDir = ""

    def setRootDir(self,path): self.rootDir = path

    def directoryCreation(self,filename,dateStamp):
        mydir = ""
        if(dateStamp == True):
            mydir = os.path.join(
                os.getcwd(),filename+"_"+datetime.now().strftime('%Y-%m-%d'))
        else:
            mydir = os.path.join(
                os.getcwd(), filename)

        try:
            if(os.path.exists(mydir)):
                print("Directory "+mydir+" exists")
            else:
                os.makedirs(mydir)
            os.chdir(mydir)

            return mydir

        except OSError as e:
            raise  # This was not a "directory exist" error..

    def openFtp(self):

        try:
            self.ftp = FTP(self.ftpPath)
            self.ftp.login()

            return self.ftp

        except FTP:
            print("Error opening ftp path")

    def workingDirectoryCheck(self,ftp,cwd,x):

        self.param = x

        try:
            print(cwd)
            ftp.cwd(cwd)
            self.ftp = ftp
            self.directoryCreation(cwd, False)


        except:

            if(self.param==0):
                self.path = self.ftp.pwd().split("/")

            print(self.path)

            ftp = self.openFtp()


            for dir in self.path[1:-(1+self.param)]:
                # print(dir)
                ftp.cwd(dir)

            print(os.getcwd())
            os.chdir(os.getcwd() + os.sep + os.pardir)


            print("RECURSION: "+str(self.param))
            self.workingDirectoryCheck(ftp,cwd,self.param-1)

    def downloadFile(self,filename):

        ftp = self.ftp
        data= []

        wFile = open(filename, "wb")
        ftp.retrbinary('RETR '+filename, wFile.write)
        wFile.close()


    def traverse(self,ftp, cwd):

        self.ftp = ftp
        dirlist = []
        data = []

        print("NEXT DIRECTORY: "+cwd)
        print("PRESENT DIRECTORY PATH: "+self.ftp.pwd())


        self.workingDirectoryCheck(self.ftp, cwd,0)

        print("PATH AFTER: "+self.ftp.pwd())

        # print(self.ftp.retrlines('LIST'))
        # print(self.ftp.pwd())

        self.ftp.dir(data.append)

        dirLine =""
        for line in data:
            if(".csv" in line):
                self.downloadFile(line[56:])

            if(line[0]=='d'):
                dirLine = line[56:]
                dirlist.append(dirLine)

        if dirlist:
            for line in dirlist:
                # if("." not in line and "README" not in line):

                self.traverse(self.ftp,line)



        return dirlist


if __name__ == "__main__":


    gwd = GetWeatherData()
    gwd.setRootDir(gwd.directoryCreation(fileType,True))

    ftp = gwd.openFtp()
    ftp.cwd('anon')
    ftp.cwd('gen')
    ftp.cwd('clim_data')
    ftp.cwd('IDCKWCDEA0')
    ftp.cwd('tables')

    gwd.traverse(ftp,".")
    # print(allDirectories)

#os.system("wget -r " + ftpPath)






