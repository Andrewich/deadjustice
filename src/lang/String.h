#ifndef LANG_STRING_H_
#define LANG_STRING_H_

#include <lang/Char.h>

#include <string>

namespace lang {

/**
 * Immutable Unicode character string.
 * Note about implementation:
 * Short strings are stored in preallocated buffer (and copied by value)
 * and longer strings are allocated to heap (and copied by reference).
 * Currently String class has only very basic Unicode support
 * (for example toUpperCase simply uses toupper internally).
 * @author Jani Kajala (jani.kajala@helsinki.fi)
 */
class String {
 public:
  /** Creates an empty string. */
  String() = default;

  /**
   * Creates a string from the null-terminated character sequence.
   */
  String(const Char* str);

  /**
   * Creates a string from the character sequence.
   *
   * @param begin Pointer to the beginning (inclusive) of the sequence.
   * @param count Number of characters in the sequence.
   */
  String(const Char* begin, size_t count);

  /**
   * Creates a string from single character.
   */
  explicit String(Char ch) { m_buffer = ch; }

  /** Copy by reference. */
  String(const String& other) { m_buffer = other.m_buffer; }

  ///
  ~String() {}

  /** Copy by reference. */
  String& operator=(const String& other);

  /** Returns number of characters in the string. */
  size_t length() const { return m_buffer.length(); }

 private:
  std::basic_string<Char> m_buffer;
};

}  // namespace lang

#endif  // LANG_STRING_H_
