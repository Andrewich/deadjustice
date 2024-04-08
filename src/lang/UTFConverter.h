#ifndef LANG_UTFCONVERTER_H_
#define LANG_UTFCONVERTER_H_

#include <string>

namespace lang {

class String;

namespace utfconverter {

/**
 * Converts UTF-8 string to UTF-16 string
 * @param utf8 Reference to a string of class lang::String
 * @return The standard library class wstring
 * @author Egorov Maxim (abd.andrew@gmail.com)
 */
std::wstring utf8ToUtf16(const String& utf8);

/**
 * Converts UTF-16 string to UTF-8 string
 * @param utf16 Reference to wstring from the standard library
 * @return String lang::String class
 * @author Egorov Maxim (abd.andrew@gmail.com)
 */
lang::String utf16ToUtf8(const std::wstring& utf16);

}  // namespace utfconverter

}  // namespace lang

#endif  // LANG_UTFCONVERTER_H_
