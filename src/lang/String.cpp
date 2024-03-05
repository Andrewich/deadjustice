#include "String.h"

//-----------------------------------------------------------------------------

namespace lang {

String::String(const Char* str) : m_buffer(std::basic_string(str)) {}

String::String(const Char* begin, size_t count)
    : m_buffer(std::basic_string(begin, count)) {}

String& String::operator=(const String& other) {
  m_buffer = other.m_buffer;
  return *this;
}

}  // namespace lang