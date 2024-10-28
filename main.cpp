#include <sw/redis++/redis++.h>
#include <iostream>

int main() {
    try {
        auto redis = sw::redis::Redis("tcp://127.0.0.1:6379");

        redis.set("key", "hello redis++");
        auto val = redis.get("key");

        if (val) {
            std::cout << "Value from Redis: " << *val << std::endl;
        }
    } catch (const sw::redis::Error &e) {
        std::cerr << "Redis error: " << e.what() << std::endl;
    }

    return 0;
}

