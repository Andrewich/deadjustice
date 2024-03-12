#include "String.h"

#include <algorithm>
#include <cassert>
#include <sstream>
#include <string_view>

//-----------------------------------------------------------------------------

namespace lang {

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
  std::string s{m_buffer};

  std::replace(s.begin(), s.end(), oldChar, newChar);

  return String{std::move(s)};
}

String String::substring(size_t begin, size_t end) const {
  String s;
  s.m_buffer = this->m_buffer.substr(begin, end);
  return s;
}

String String::substring(size_t begin) const {
  return substring(begin, length());
}

String String::toLowerCase() const {
  std::string s{m_buffer};

  std::transform(s.begin(), s.end(), s.begin(),
                 [](unsigned char c) { return std::tolower(c); });

  return String{std::move(s)};
}

String String::toUpperCase() const {
  std::string s{m_buffer};

  std::transform(s.begin(), s.end(), s.begin(),
                 [](unsigned char c) { return std::toupper(c); });

  return String{std::move(s)};
}

String String::trim() const {
  std::string s{m_buffer};

  s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
            return !std::isspace(ch);
          }));

  return String{std::move(s)};
}

int String::compareTo(const String& other) const {
  return m_buffer.compare(other.m_buffer);
}

String String::valueOf(int value) { return String{std::to_string(value)}; }

String String::valueOf(float value) {
  std::ostringstream os;
  os << value;
  return String{std::move(os.str())};
}

}  // namespace lang

lang::String operator""_s(const char* str, std::size_t) {
  return lang::String(str);
}