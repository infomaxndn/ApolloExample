#include <vector>
#include <iostream>
#include <dirent.h>
#include <errno.h>
#include "ApolloStoryProducer.hpp"
#include "ApolloStoryReceiver.hpp"
#include "ApolloStoryHolder.hpp"
#include <boost/thread.hpp>

// When consumers request name list, producers will send multiple names separated by this keyword
#define KEYWORD_DIVIDER "%%"  

using namespace std;
using namespace ndn;
using namespace ndn::infomax;

// Current folder having several task sub-folders
vector<string> *dirList; 

vector<string>* getdir (string dir)
{
    string currFileName;
    DIR *dp;
    struct dirent *dirp;
    vector<string> *dirList = new vector<string>;

    if((dp  = opendir(dir.c_str())) == NULL) {
        cout << "Error(" << errno << ") opening " << dir << endl;
        return NULL;
    }

    while ((dirp = readdir(dp)) != NULL) {      
        currFileName = string(dirp->d_name);
        if(currFileName.find(".task") != string::npos)
        {           
            dirList->push_back(string(dirp->d_name));
        }
    }
    closedir(dp);
    
    return dirList;
}

void producer_run( ApolloStoryProducer *producer )
{	
	producer->run();
}

void receiver_run( ApolloStoryReceiver *receiver )
{
    receiver->run();
}

void holder_run( ApolloStoryHolder *holder )
{
    holder->run();
}

int
main(int argc, char** argv) {
	(void)argc;
	(void)argv;

    string nameList;
    boost::thread_group g;
    dirList = getdir (".");

    for (unsigned int i=0; i<dirList->size(); i++)
    {
        ApolloStoryProducer * currProducer = new ApolloStoryProducer(dirList->at(i));
        if (!currProducer->getCandidateFlag()) {            
            cout << dirList->at(i) << " is not candidate" << endl;            
            continue;
        }   

        g.add_thread(new boost::thread(producer_run, currProducer));     

        if (!nameList.empty())
            nameList = nameList + KEYWORD_DIVIDER + currProducer->getStoryName();    
        else
            nameList = currProducer->getStoryName();        
    }

    ApolloStoryReceiver * receiver = new ApolloStoryReceiver();
    g.add_thread(new boost::thread(receiver_run, receiver));

    ApolloStoryHolder * holder = new ApolloStoryHolder(nameList);
    g.add_thread(new boost::thread(holder_run, holder));    

	g.join_all();		    

	return 0;
}
