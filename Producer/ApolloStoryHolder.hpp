#ifndef APOLLO_STORY_HOLDER_HPP
#define APOLLO_STORY_HOLDER_HPP

#include <ndn-cxx/face.hpp>
#include <ndn-cxx/security/key-chain.hpp>



// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace infomax {

class ApolloStoryHolder
{
public:
  ApolloStoryHolder(std::string nameList);

  void run();

private:
  void onInterest(const InterestFilter& filter, const Interest& interest);

  void onRegisterFailed(const Name& prefix, const std::string& reason);

private:
  Face m_face;
  KeyChain m_keyChain;
  std::string nameList;
};

} // namespace examples
} // namespace ndn

#endif