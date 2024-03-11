#ifndef LANG_STRING_H_
#define LANG_STRING_H_

#include <lang/Char.h>

#include <iostream>
#include <span>
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
   * Creates a string from the byte sequence with specified encoding.
   * Ignores silently encoded characters which have invalid byte sequences.
   *
   * Supported encoding types are
   *	<pre>
  ASCII-7         UTF-8           UTF-16BE
  UTF-16LE        UTF-32BE        UTF-32LE
          </pre>
   *
   * @exception UnsupportedEncodingException
   */
  // String(const void* data, int size, const char* encoding);

  /**
   * Creates a string from single character.
   */
  explicit String(Char ch) { m_buffer = ch; }

  /** Copy by reference. */
  String(const String& other) { m_buffer = other.m_buffer; }

  /** Move constructor */
  String(String&& other) : m_buffer{std::move(other.m_buffer)} {}

  ///
  ~String() {}

  /** Copy by reference. */
  String& operator=(const String& other);

  /** Returns number of characters in the string. */
  size_t length() const { return m_buffer.length(); }

  /** Returns character at specified index. */
  Char charAt(size_t index) const;

  /**
   * Encodes string content to the buffer using specified encoding method.
   * Always terminates encoded character string with zero byte.
   *
   * @param buffer Pointer to the destination buffer.
   * @param bufferSize Size of the destination buffer.
   * @param encoding Encoding type. See constructor String(data,size,encoding)
   * for a list of supported encoding methods.
   * @return Number of bytes needed to encode the string, not including trailing
   * zero. Note that this might be larger than bufferSize.
   * @exception UnsupportedEncodingException
   */
  // int getBytes(void* buffer, int bufferSize, const char* encoding) const;

  /**
   * Copies characters from this string into the destination character
   * array/span
   *
   * @param begin Index to the beginning (inclusive) of the substring.
   * @param end Index to the end (exclusive) of the substring.
   */
  void getChars(size_t begin, size_t end, std::span<Char> dest) const;

  /**
   * Returns true if the string ends with specified substring.
   */
  bool endsWith(const String& suffix) const;

  /**
   * Returns true if the string starts with specified substring.
   */
  bool startsWith(const String& prefix) const;

  /**
   * Returns hash code for this string.
   */
  int hashCode() const;

  /**
   * Returns the first index within this string of the specified character.
   * Starts the search from the specified position.
   *
   * @param ch Character to find.
   * @param index The first position to search, default 0.
   * @return Index of the found position or -1 if the character was not found
   * from the string.
   */
  size_t indexOf(Char ch, size_t index = 0) const;

  /**
   * Returns the first index within this string of the specified substring.
   * Starts the search from the specified position.
   *
   * @param str Substring to find.
   * @param index The first position to search, default 0.
   * @return Index of the found position or -1 if the substring was not found
   * from the string.
   */
  size_t indexOf(const String& str, size_t index = 0) const;

  /**
   * Returns the last index within this string of the specified character.
   *
   * @param ch Character to find.
   * @return Index of the found position or -1 if the character was not found
   * from the string.
   */
  size_t lastIndexOf(Char ch) const {
    return lastIndexOf(ch, m_buffer.length() - 1);
  }

  /**
   * Returns the last index within this string of the specified character.
   * Starts the search from the specified position.
   *
   * @param ch Character to find.
   * @param index The last position to search.
   * @return Index of the found position or -1 if the character was not found
   * from the string.
   */
  size_t lastIndexOf(Char ch, size_t index) const;

  /**
   * Returns the last index within this string of the specified substring.
   *
   * @param str Substring to find.
   * @return Index of the found position or -1 if the substring was not found
   * from the string.
   */
  size_t lastIndexOf(const String& str) const {
    return lastIndexOf(str, m_buffer.length() - 1);
  }

  /**
   * Returns the last index within this string of the specified substring.
   * Starts the search from the specified position.
   *
   * @param str Substring to find.
   * @param index The last position to search.
   * @return Index of the found position or -1 if the substring was not found
   * from the string.
   */
  size_t lastIndexOf(const String& str, size_t index) const;

  /**
   * Tests if two string regions are equal.
   *
   * @param thisOffset Offset to this string.
   * @param other The other string to compare.
   * @param otherOffset Offset to other string.
   * @param length Length of the sequences to compare.
   */
  bool regionMatches(size_t thisOffset, const String& other, size_t otherOffset,
                     size_t length) const;

  /**
   * Returns a new string which has oldChar characters replaced with newChar.
   */
  String replace(Char oldChar, Char newChar) const;

  /**
   * Returns a new string that is a substring of this string.
   *
   * @param begin Index to the beginning (inclusive) of the substring.
   * @param end Index to the end (exclusive) of the substring.
   */
  String substring(size_t begin, size_t end) const;

  /**
   * Returns a new string that is a substring of this string.
   *
   * @param begin Index to the beginning (inclusive) of the substring.
   */
  String substring(size_t begin) const;

  /**
   * Returns a new string that has all characters of this string converted to
   * lowercase. Doesn't handle locale dependent special casing.
   */
  String toLowerCase() const;

  /**
   * Returns a new string that has all characters of this string converted to
   * uppercase. Doesn't handle locale dependent special casing.
   */
  String toUpperCase() const;

  /**
   * Returns a new string that is otherwise identical to this string
   * but has whitespace removed from both ends of the string.
   */
  String trim() const;

  /**
   * Bitwise lecigographical compare between this string and other string.
   * @return If this string is lexicographically before other then the return
   * value is <0 and if this string is after other string then >0. If the
   * strings are equal then the return value is 0.
   */
  int compareTo(const String& other) const;

 private:
  std::basic_string<Char> m_buffer;
};

}  // namespace lang

lang::String operator""_s(const char* str, std::size_t);

#endif  // LANG_STRING_H_
