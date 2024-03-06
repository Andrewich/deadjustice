#ifndef LANG_STRING_H_
#define LANG_STRING_H_

#include <lang/Char.h>

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

 private:
  std::basic_string<Char> m_buffer;
};

}  // namespace lang

#endif  // LANG_STRING_H_
