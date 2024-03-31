#ifndef LANG_UTFCONVERTER_H_
#define LANG_UTFCONVERTER_H_

#include <string>

namespace lang {

class String;

namespace utfconverter {

std::wstring utf8ToUtf16(const String& utf8);
//  lang::String utf16ToUtf8(const std::wstring& utf16);

}  // namespace utfconverter

}  // namespace lang

#endif  // LANG_UTFCONVERTER_H_
