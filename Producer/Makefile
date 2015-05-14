CC = g++
INC = -I. -Ilibs
FLAGS = -g -W -Wall -std=c++11
LIBS = -lboost_system -lboost_thread

all: ApolloStoryProducerTester ApolloStoryReceiverTester

ApolloStoryProducerTester: TreeNode.o Prioritizers.o InfoMaxProducer.o ApolloStoryProducer.o ApolloStoryReceiver.o ApolloStoryHolder.o ApolloStoryProducerTester.cpp
	$(CC) $(FLAGS) $(INC) $^ -o $@ `pkg-config --cflags --libs libndn-cxx jsoncpp` $(LIBS)	

ApolloStoryReceiverTester: ApolloStoryReceiverTester.cpp
	$(CC) $(FLAGS) $(INC) $^ -o $@ `pkg-config --cflags --libs libndn-cxx` 

ApolloStoryProducer.o: ApolloStoryProducer.cpp ApolloStoryProducer.hpp
	$(CC) -c $(FLAGS) $(INC) $< -o $@

ApolloStoryReceiver.o: ApolloStoryReceiver.cpp ApolloStoryReceiver.hpp
	$(CC) -c $(FLAGS) $(INC) $< -o $@	

ApolloStoryHolder.o: ApolloStoryHolder.cpp ApolloStoryHolder.hpp
	$(CC) -c $(FLAGS) $(INC) $< -o $@		

clean:
	$(RM) -r *.o ApolloStoryProducerTester ApolloStoryReceiverTester
