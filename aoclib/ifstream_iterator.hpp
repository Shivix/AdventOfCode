#include <fstream>
#include <string>

class IfstreamIterator {
public:
    using iterator_category = std::input_iterator_tag;
    using value_type = std::string;
    using difference_type = ptrdiff_t;
    using pointer = const std::string*;
    using reference = const std::string&;

    explicit IfstreamIterator(std::ifstream& stream) noexcept
        : stream{&stream} {
        std::getline(*this->stream, current);
    }
    IfstreamIterator() noexcept 
        : stream{nullptr}
    {}

    IfstreamIterator operator++(int) noexcept {
        auto previous{*this};
        if (!std::getline(*stream, current)) {
            stream = nullptr;
        }
        return previous;
    }
    IfstreamIterator& operator++() noexcept {
        if (!std::getline(*stream, current)) {
            stream = nullptr;
        }
        return *this;
    }

    std::string_view operator*() noexcept {
        return current;
    }

    constexpr friend bool operator==(const IfstreamIterator& lhs, const IfstreamIterator& rhs) noexcept {
        return lhs.stream == rhs.stream;
    }
    constexpr friend bool operator!=(const IfstreamIterator& lhs, const IfstreamIterator& rhs) noexcept {
        return !(lhs == rhs);
    }

private:
    std::ifstream* stream;
    // TODO: can we make this string_view?
    std::string current;
};
