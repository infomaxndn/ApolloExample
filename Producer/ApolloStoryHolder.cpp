#include "ApolloStoryHolder.hpp"

// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace infomax {

ApolloStoryHolder::ApolloStoryHolder(std::string nameList)
{ 
  this->nameList = nameList;
}

void ApolloStoryHolder::run()
{
  m_face.setInterestFilter("/Apollo/story/",
                           bind(&ApolloStoryHolder::onInterest, this, _1, _2),
                           RegisterPrefixSuccessCallback(),
                           bind(&ApolloStoryHolder::onRegisterFailed, this, _1, _2));
  m_face.processEvents();
}

void ApolloStoryHolder::onInterest(const InterestFilter& filter, const Interest& interest)
{
  std::cout << "<< I: " << interest << std::endl;

  // Create new name, based on Interest's name
  Name dataName(interest.getName());

  static const std::string content = this->nameList;

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


void ApolloStoryHolder::onRegisterFailed(const Name& prefix, const std::string& reason)
{
  std::cerr << "ERROR: Failed to register prefix \""
            << prefix << "\" in local hub's daemon (" << reason << ")"
            << std::endl;
  m_face.shutdown();
}

}
}
