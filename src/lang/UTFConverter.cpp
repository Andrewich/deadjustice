#include "UTFConverter.h"

#include <Windows.h>  // Win32 Platform SDK main header

#include "String.h"

//-----------------------------------------------------------------------------

namespace lang {

namespace utfconverter {

std::wstring utf8ToUtf16(const String& utf8) {
  std::wstring utf16;

  if (utf8.m_buffer.empty()) {
    return utf16;
  }

  const int utf8Length = std::ssize(utf8.m_buffer);

  // Get the size of the destination UTF-16 string
  const int utf16Length = ::MultiByteToWideChar(
      CP_UTF8,               // source string is in UTF-8
      MB_ERR_INVALID_CHARS,  // conversion flags
      utf8.m_buffer.data(),  // source UTF-8 string pointer
      utf8Length,            // length of the source UTF-8 string, in chars
      nullptr,               // unused - no conversion done in this step
      0                      // request size of destination buffer, in wchar_ts
  );
  if (utf16Length == 0) {
    // Conversion error: capture error code and throw
    const DWORD error = ::GetLastError();
    /*throw Utf8ConversionException(
        error == ERROR_NO_UNICODE_TRANSLATION
            ? "Invalid UTF-8 sequence found in input string."
            : "Cannot get result string length when converting "
              "from UTF-8 to UTF-16 (MultiByteToWideChar failed).",
        error, Utf8ConversionException::ConversionType::FromUtf8ToUtf16);*/
    return utf16;
  }

  // Make room in the destination string for the converted bits
  utf16.resize(utf16Length);

  // Do the actual conversion from UTF-8 to UTF-16
  int result = ::MultiByteToWideChar(
      CP_UTF8,               // source string is in UTF-8
      MB_ERR_INVALID_CHARS,  // conversion flags
      utf8.m_buffer.data(),  // source UTF-8 string pointer
      utf8Length,            // length of source UTF-8 string, in chars
      utf16.data(),          // pointer to destination buffer
      utf16Length            // size of destination buffer, in wchar_ts
  );
  if (result == 0) {
    // Conversion error: capture error code and throw
    const DWORD error = ::GetLastError();
    /*throw Utf8ConversionException(
        error == ERROR_NO_UNICODE_TRANSLATION
            ? "Invalid UTF-8 sequence found in input string."
            : "Cannot convert from UTF-8 to UTF-16 "
              "(MultiByteToWideChar failed).",
        error, Utf8ConversionException::ConversionType::FromUtf8ToUtf16);*/
    return utf16;
  }

  return utf16;
}

lang::String utf16ToUtf8(const std::wstring& utf16) {
  std::string utf8;

  if (utf16.empty()) {
    return utf8;
  }

  const int utf16Length = std::ssize(utf16);

  // Get the length, in chars, of the resulting UTF-8 string
  const int utf8Length = ::WideCharToMultiByte(
      CP_UTF8,               // convert to UTF-8
      WC_ERR_INVALID_CHARS,  // conversion flags
      utf16.data(),          // source UTF-16 string
      utf16Length,           // length of source UTF-16 string, in wchar_ts
      nullptr,               // unused - no conversion required in this step
      0,                     // request size of destination buffer, in chars
      nullptr, nullptr       // unused
  );
  if (utf8Length == 0) {
    // Conversion error: capture error code and throw
    const DWORD error = ::GetLastError();
    return utf8;
    /*throw Utf8ConversionException(
        error == ERROR_NO_UNICODE_TRANSLATION
            ? "Invalid UTF-16 sequence found in input string."
            : "Cannot get result string length when converting "
              "from UTF-16 to UTF-8 (WideCharToMultiByte failed).",
        error, Utf8ConversionException::ConversionType::FromUtf16ToUtf8);*/
  }

  // Make room in the destination string for the converted bits
  utf8.resize(utf8Length);

  // Do the actual conversion from UTF-16 to UTF-8
  int result = ::WideCharToMultiByte(
      CP_UTF8,               // convert to UTF-8
      WC_ERR_INVALID_CHARS,  // conversion flags
      utf16.data(),          // source UTF-16 string
      utf16Length,           // length of source UTF-16 string, in wchar_ts
      utf8.data(),           // pointer to destination buffer
      utf8Length,            // size of destination buffer, in chars
      nullptr, nullptr       // unused
  );
  if (result == 0) {
    // Conversion error: capture error code and throw
    const DWORD error = ::GetLastError();
    return std::string();
    /*throw Utf8ConversionException(
        error == ERROR_NO_UNICODE_TRANSLATION
            ? "Invalid UTF-16 sequence found in input string."
            : "Cannot convert from UTF-16 to UTF-8 "
              "(WideCharToMultiByte failed).",
        error, Utf8ConversionException::ConversionType::FromUtf16ToUtf8);*/
  }

  return lang::String{std::move(utf8)};
}

}  // namespace utfconverter

}  // namespace lang