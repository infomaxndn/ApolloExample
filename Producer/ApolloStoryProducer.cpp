#include "ApolloStoryProducer.hpp"

// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace infomax { 

ApolloStoryProducer :: ApolloStoryProducer (string dir)
{

	ifstream rFile(dir+string("/task_info.json"));
	
	if (!rFile)
	{
		cout << "task_info.json does not exist." << endl;
		candidate = false;
		return;
	}
	
	string line;
	getline (rFile, line);	

 	Reader reader;
    Value metaData;
    reader.parse(line, metaData);
    Value query = metaData["query"];
    Value analysisType = query["analysis_types"];

    for (unsigned int i=0; i<analysisType.size(); i++)
    {
    	if (analysisType[i].asString() == string("Diversity"))
    	{
    		candidate = true;    	
    		break;
    	}
    }

	Name nRoot = Name("Apollo");
	nRoot.append(Name(query["dataset"].asString()));
	
	this->storyName = query["dataset"].asString();
	this->producer = new InfoMaxProducer(nRoot);

    vector<Name> nameList;
	vector<Data> dataList;

	string subdir = string(dir+string("/analysis/Diversity"));	
    if (readDirintoNameAndData(subdir, &nameList, &dataList))  
    {
    	for(unsigned int i=0; i<nameList.size(); i++) {	
			producer->add(nameList[i], dataList[i]);
		}
	}	    

    if (!candidate)
    {
    	cout << "This folder doesn't have Diversity folder." << endl;
    	candidate = false;
    	return;
    }   
		
}

void
ApolloStoryProducer :: run()
{
	producer->run();
}

Name
ApolloStoryProducer :: convertStringToName(string str)
{
	Name name = Name();
	for (unsigned int i=0; i<str.size(); i++)
		name.append(string(1,str[i]));
	return name;
}

bool
ApolloStoryProducer :: readFileintoNameAndData(string fileName, vector<Name> *nameList, vector<Data> *dataList, unsigned long long int freshnessPeriod)
{
	string line;	
	string name, content;	
	ifstream readFile (fileName);
	
	if (readFile.is_open())
	{
		while (getline (readFile, line))
		{		
			name = convertStringToName(line).toUri();			
            nameList->push_back(name);

            getline (readFile, line);
           	content = line;    
       	    Data data = Data(name);
           	data.setFreshnessPeriod(time::seconds(freshnessPeriod));
           	data.setContent(reinterpret_cast<const uint8_t*>(content.c_str()), content.size());
			dataList->push_back(data);					            
		}		
	}else
    {
        cout << "Unable to open the file.\n";
    }
    readFile.close();

	return true;
}

string
ApolloStoryProducer :: getdir (string dir)
{

	string maxTimeStampFileName, currFileName;
	int maxTimeStamp=0, currTimeStamp=0;
    DIR *dp;
    struct dirent *dirp;
    if((dp  = opendir(dir.c_str())) == NULL) {
        cout << "Folder " << dir << " does not exist" << endl;
        return "";
    }

    while ((dirp = readdir(dp)) != NULL) {    	
    	currFileName = string(dirp->d_name);
    	if(currFileName.find("60m.model.txt") != string::npos)
    	{    		
    		currTimeStamp = atoi(currFileName.substr(0, 10).c_str());    		
    		
    		if (currTimeStamp > maxTimeStamp)
    		{
    			maxTimeStamp = currTimeStamp;
    			maxTimeStampFileName = dir + "/" + currFileName;        	    			
    		}
    	}
    }
    closedir(dp);
    
    return maxTimeStampFileName;
}

bool
ApolloStoryProducer :: readDirintoNameAndData(string dir, vector<Name> *nameList, vector<Data> *dataList)
{
	string file = getdir(dir);	

	if (!file.empty()) {		
    	readFileintoNameAndData(file, nameList, dataList, 10);     	
	}
    else {
    	this->candidate = false;
    	return false;
    }    	
    return true;
}

string 
ApolloStoryProducer :: getStoryName()
{
	return this->storyName;
}

bool
ApolloStoryProducer :: getCandidateFlag()
{
	return this->candidate;
}

}
}