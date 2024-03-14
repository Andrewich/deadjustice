#include <Windows.h>
#include <lang/UTFConverter.h>

#include <string>

int main() {
  std::wstring caption = lang::utfconverter::utf8ToUtf16("Внимание");
  std::wstring text = lang::utfconverter::utf8ToUtf16(
      "Тестирование конвертации UTF-8 в UTF-16");

  MessageBoxW(NULL, text.data(), caption.data(), MB_ICONWARNING);

  return 0;
}