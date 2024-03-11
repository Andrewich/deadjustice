#include "String.h"

#include <algorithm>
#include <cassert>
#include <string_view>

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

size_t String::indexOf(Char ch, size_t index) const {
  size_t index_ = m_buffer.find(ch, index);
  if (index_ == std::string::npos) return -1;
  return index_;
}

size_t String::indexOf(const String& str, size_t index) const {
  size_t index_ = m_buffer.find(str.m_buffer, index);
  if (index_ == std::string::npos) return -1;
  return index_;
}

size_t String::lastIndexOf(Char ch, size_t index) const {
  size_t index_ = m_buffer.rfind(ch, index);
  if (index_ == std::string::npos) return -1;
  return index_;
}

size_t String::lastIndexOf(const String& str, size_t index) const {
  size_t index_ = m_buffer.rfind(str.m_buffer, index);
  if (index_ == std::string::npos) return -1;
  return index_;
}

bool String::regionMatches(size_t thisOffset, const String& other,
                           size_t otherOffset, size_t length) const {
  std::string_view sv1{m_buffer};
  std::string_view sv2{other.m_buffer};

  return sv1.substr(thisOffset, length) == sv2.substr(otherOffset, length);
}

String String::replace(Char oldChar, Char newChar) const {
  String str{m_buffer.c_str()};

  std::replace(str.m_buffer.begin(), str.m_buffer.end(), oldChar, newChar);

  return str;
}

String String::substring(size_t begin, size_t end) const {
  String str;
  str.m_buffer = this->m_buffer.substr(begin, end);
  return str;
}

String String::substring(size_t begin) const {
  return substring(begin, length());
}

String String::toLowerCase() const {
  String s{m_buffer.c_str()};
  std::transform(s.m_buffer.begin(), s.m_buffer.end(), s.m_buffer.begin(),
                 [](unsigned char c) { return std::tolower(c); });
  return s;
}

String String::toUpperCase() const {
  String s{m_buffer.c_str()};
  std::transform(s.m_buffer.begin(), s.m_buffer.end(), s.m_buffer.begin(),
                 [](unsigned char c) { return std::toupper(c); });
  return s;
}

int String::compareTo(const String& other) const {
  return m_buffer.compare(other.m_buffer);
}

}  // namespace lang

lang::String operator""_s(const char* str, std::size_t) {
  return lang::String(str);
}