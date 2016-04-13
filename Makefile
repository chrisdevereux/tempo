$(shell mkdir -p .build)

CPPFLAGS=-Ilib/compiler -Wall -Ilib/support -std=gnu++14
LDFLAGS=-lc++
CXX=clang++

SRCS        := $(shell find lib -name *.cpp)
OBJS        := $(SRCS:.cpp=.o)
TEST_SRCS   := $(shell find test -name main.cpp)
TESTS       := $(TEST_SRCS:/main.cpp=.testcase)


# Dependencies

depend: .depend

clean:
	rm -rf .depend
	rm -f lib/**/*.o
	rm -f test/**/*.testcase

.depend:
	$(CXX) $(CPPFLAGS) -MM $(SRCS) > .depend;


# Tests

test/%.testcase : test/%/main.cpp $(OBJS)
	$(CXX) $(CPPFLAGS) $(LDFLAGS) -o $@ $(OBJS) $<

test/%.run : test/%.testcase
	$< test/$*/examples/*

test : $(TESTS:.testcase=.run)

###

.PHONY : test clean
.PRECIOUS : %.o

include ./.depend
