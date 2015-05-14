#ifndef APOLLO_STORY_RECEIVER_HPP
#define APOLLO_STORY_RECEIVER_HPP

#include <ndn-cxx/face.hpp>
#include <ndn-cxx/security/key-chain.hpp>



// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace infomax {

class ApolloStoryReceiver
{
public:
  ApolloStoryReceiver();

  void run();

private:
  void onInterest(const InterestFilter& filter, const Interest& interest);

  void onRegisterFailed(const Name& prefix, const std::string& reason);

private:
  Face m_face;
  KeyChain m_keyChain;
};

} // namespace examples
} // namespace ndn

#endif