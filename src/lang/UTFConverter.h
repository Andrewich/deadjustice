#ifndef LANG_UTFCONVERTER_H_
#define LANG_UTFCONVERTER_H_

#include <string>

namespace lang {

namespace utfconverter {

std::wstring utf8ToUtf16(const std::string& str);
std::string utf16ToUtf8(const std::wstring& str);

}  // namespace utfconverter

}  // namespace lang

#endif  // LANG_UTFCONVERTER_H_
