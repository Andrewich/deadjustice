#include <Windows.h>
#include <lang/UTFConverter.h>

#include <string>

int main() {
  std::string caption_utf8{"Внимание"};
  std::wstring caption = lang::utfconverter::utf8ToUtf16(caption_utf8);

  std::string text_utf8{"Тестирование конвертации UTF-8 в UTF-16"};
  std::wstring text = lang::utfconverter::utf8ToUtf16(text_utf8);

  MessageBoxW(NULL, text.data(), caption.data(), MB_ICONWARNING);

  return 0;
}