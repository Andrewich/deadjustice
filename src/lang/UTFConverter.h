#ifndef LANG_UTFCONVERTER_H_
#define LANG_UTFCONVERTER_H_

#include <span>
#include <string>

#include "String.h"

namespace lang {

namespace utfconverter {

std::wstring utf8ToUtf16(std::span<char> utf8);
lang::String utf16ToUtf8(std::span<Char16> utf16);

}  // namespace utfconverter

}  // namespace lang

#endif  // LANG_UTFCONVERTER_H_
