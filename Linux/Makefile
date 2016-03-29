ifdef DEBUG
CFLAGS += -g -DDEBUG
endif
CFLAGS += -std=gnu89 -Wall -pedantic -pthread -DKII_JSON_FIXED_TOKEN_NUM=256

LIBS = -lssl -lcrypto -lpthread
LD_FLAGS = -L../thing-if-ThingSDK/
SOURCES = $(wildcard *.c)
SOURCES += ../thing-if-ThingSDK/kii_thing_if.c ../thing-if-ThingSDK/kii_thing_if_environment_linux.c
SOURCES += $(wildcard ../thing-if-ThingSDK/kii/Linux/kii_*.c)
SOURCES += $(wildcard ../thing-if-ThingSDK/kii/kii-core/*.c)
SOURCES += $(wildcard ../thing-if-ThingSDK/kii/kii-core/linux/kii_core*.c)
SOURCES += $(wildcard ../thing-if-ThingSDK/kii/kii/*.c)
SOURCES += $(wildcard ../thing-if-ThingSDK/kii/kii_json/src/*.c)
SOURCES += ../thing-if-ThingSDK/kii/lib/jsmn/jsmn.c
TARGET = exampleapp
INCLUDES = -I../thing-if-ThingSDK/ -I../thing-if-ThingSDK/kii/kii-core -I../thing-if-ThingSDK/kii/kii-core/linux -I../thing-if-ThingSDK/kii/kii -I../thing-if-ThingSDK/kii/kii_json/include -I../thing-if-ThingSDK/kii/lib/jsmn -I../thing-if-ThingSDK/kii/Linux


all: clean $(TARGET) $(DOCTARGET)

$(TARGET):
	gcc $(CFLAGS) $(SOURCES) $(LIBS) $(LD_FLAGS) $(INCLUDES) -o $@

clean:
	touch $(TARGET)
	rm $(TARGET)
	rm -rf $(DOCTARGET)

.PHONY: all clean copy
