#include <ndn-cxx/face.hpp>

// Enclosing code in ndn simplifies coding (can also use `using namespace ndn`)
namespace ndn {
// Additional nested namespace could be used to prevent/limit name contentions
namespace examples {

class Consumer : noncopyable
{

public:
  void
  run(std::string testName)
  {
    Interest interest(Name(testName.c_str()));
    interest.setInterestLifetime(time::milliseconds(1000));
    interest.setMustBeFresh(true);

    m_face.expressInterest(interest,
                           bind(&Consumer::onData, this,  _1, _2),
                           bind(&Consumer::onTimeout, this, _1));

    std::cout << "Sending " << interest << std::endl;

    // processEvents will block until the requested data received or timeout occurs
    m_face.processEvents();
  }

private:
  void
  onData(const Interest& interest, const Data& data)
  {
    std::cout << data << std::endl;

    std::string receivedContent = reinterpret_cast<const char*>(data.getContent().value());
    receivedContent = receivedContent.substr(0, data.getContent().value_size());

    std::cout << receivedContent << std::endl;
  }

  void
  onTimeout(const Interest& interest)
  {
    std::cout << "Timeout " << interest << std::endl;
  }

private:
  Face m_face;
};

} // namespace examples
} // namespace ndn

int
main(int argc, char** argv)
{
 
  ndn::examples::Consumer consumer;
  try {
    consumer.run(std::string(argv[1]));
  }
  catch (const std::exception& e) {
    std::cerr << "ERROR: " << e.what() << std::endl;
  }
  return 0;
}
