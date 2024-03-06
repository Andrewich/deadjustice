#include "String.h"

#include <algorithm>
#include <cassert>

//-----------------------------------------------------------------------------

namespace lang {

String::String(const Char* str) : m_buffer(std::basic_string(str)) {}

String::String(const Char* begin, size_t count)
    : m_buffer(std::basic_string(begin, count)) {}

String& String::operator=(const String& other) {
  m_buffer = other.m_buffer;
  return *this;
}

Char String::charAt(size_t index) const { return m_buffer[index]; }

void String::getChars(size_t begin, size_t end, std::span<Char> dest) const {
  auto it_begin = m_buffer.begin() + begin;
  auto it_end = m_buffer.begin() + end + 1;

  std::copy(it_begin, it_end, dest.begin());
  dest.back() = '\0';
}

bool String::endsWith(const String& suffix) const {
  return m_buffer.ends_with(suffix.m_buffer);
}

bool String::startsWith(const String& prefix) const {
  return m_buffer.starts_with(prefix.m_buffer);
}

int String::hashCode() const {
  int code = 0;

  for (Char ch : m_buffer) {
    code *= 31;
    code += ch;
  }

  return code;
}

}  // namespace lang