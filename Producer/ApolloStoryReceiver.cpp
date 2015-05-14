#include "ApolloStoryReceiver.hpp"
#include <unistd.h>

// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace infomax {

#define KEYWORD_DIVIDER "%26"
#define KEYWORD_SIZE 3

ApolloStoryReceiver::ApolloStoryReceiver()
{

}

void ApolloStoryReceiver::run()
{
  m_face.setInterestFilter("/Apollo/newStory/",
                           bind(&ApolloStoryReceiver::onInterest, this, _1, _2),
                           RegisterPrefixSuccessCallback(),
                           bind(&ApolloStoryReceiver::onRegisterFailed, this, _1, _2));
  m_face.processEvents();
}

void ApolloStoryReceiver::onInterest(const InterestFilter& filter, const Interest& interest)
{
  std::cout << "<< I: " << interest << std::endl;

  // Create new name, based on Interest's name
  Name dataName(interest.getName());

  std::string request = std::string(dataName.get(interest.getName().size()-1).toUri());
  int pos1=-1, pos2=-1, pos3=-1;
  std::string requestName, requestKey1, requestKey2, requestKey3;

  pos1 = request.find(KEYWORD_DIVIDER);
  if (pos1 > 0) {
    requestName = request.substr(0, pos1);
    requestKey1 = request.substr(pos1+KEYWORD_SIZE);    
    pos2 = requestKey1.find(KEYWORD_DIVIDER);
    if (pos2 > 0) {
      requestKey2 = requestKey1.substr(pos2+KEYWORD_SIZE);    
      pos3 = requestKey2.find(KEYWORD_DIVIDER);
    } if (pos3 > 0) {
      requestKey3 = requestKey2.substr(pos3+KEYWORD_SIZE);
    }
  }

  requestKey1 = requestKey1.substr(0, pos2);
  requestKey2 = requestKey2.substr(0, pos3);
  
  std::cout << "<< name: " << requestName << std::endl;     
  std::cout << "<< keyword1: " << requestKey1 << std::endl;   
  std::cout << "<< keyword2: " << requestKey2 << std::endl;   
  std::cout << "<< keyword3: " << requestKey3 << std::endl;   

  std::string command = "curl 'http://apollo2.cs.illinois.edu/now-bin/now.py/create_task?keyword1=" + requestKey1 + "&keyword2=" + requestKey2 + "&keyword3=" + requestKey3 + "&dataset=" + requestName + "&latitude=&longitude=&radius=&crawler=search_api&created_by=ndn&query_type=NOT&analysis_types=\%5B\%22Diversity\%22\%5D&default_analysis=Diversity&permission=private' -H 'Host: apollo2.cs.illinois.edu'";

  system(command.c_str());

  static const std::string content = "ACK";

  // Create Data packet
  shared_ptr<Data> data = make_shared<Data>();
  data->setName(dataName);
  data->setFreshnessPeriod(time::seconds(10));
  data->setContent(reinterpret_cast<const uint8_t*>(content.c_str()), content.size());

  // Sign Data packet with default identity
  m_keyChain.sign(*data);
  // m_keyChain.sign(data, <identityName>);
  // m_keyChain.sign(data, <certificate>);

  // Return Data packet to the requester
  std::cout << ">> D: " << *data << std::endl;
  m_face.put(*data);
}


void ApolloStoryReceiver::onRegisterFailed(const Name& prefix, const std::string& reason)
{
  std::cerr << "ERROR: Failed to register prefix \""
            << prefix << "\" in local hub's daemon (" << reason << ")"
            << std::endl;
  m_face.shutdown();
}

}
}

// int
// main(int argc, char** argv)
// {
//   (void)argc;
//   (void)argv;

//   ndn::examples::ApolloStoryReceiver producer;
//   try {
//     producer.run();
//   }
//   catch (const std::exception& e) {
//     std::cerr << "ERROR: " << e.what() << std::endl;
//   }
//   return 0;
// }
