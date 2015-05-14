#ifndef APOLLO_STORY_PRODUCER_HPP
#define APOLLO_STORY_PRODUCER_HPP

#include <iostream>
#include <fstream>
#include <string>
#include "InfoMaxProducer.hpp"
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <json/json.h>

using namespace std;
using namespace Json;
// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace infomax {

/**
 * Class defination for the ApolloStoryProducer.
 */
class ApolloStoryProducer 
{

public:
	/**
	 * Constructor for the ApolloStoryProducer.	 
	 */
	ApolloStoryProducer (string dir);
	void run();
	std::string getStoryName();
	bool getCandidateFlag();

private:	

 	bool readFileintoString(string fileName, string *content);
 	bool setContentFromFile(Data *data, string fileName, unsigned long long int freshnessPeriod);
 	Name convertStringToName(string str);
 	bool readFileintoNameAndData(string fileName, vector<Name> *nameList, vector<Data> *dataList, unsigned long long int freshnessPeriod);
 	string getdir (string dir);
 	bool readDirintoNameAndData(string dir, vector<Name> *nameList, vector<Data> *dataList);

private:
	InfoMaxProducer *producer;
	std::string storyName;
	bool candidate;     //whether the folder includes InfoMax relevant data

};

}
}

#endif