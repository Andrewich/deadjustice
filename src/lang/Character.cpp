#include "Character.h"

#include <cctype>

//-----------------------------------------------------------------------------

namespace lang {

bool Character::isDigit(Char32 cp) {
  if (cp < Char32(0x80))
    return 0 != std::isdigit(static_cast<unsigned char>(cp));
  else
    return false;
}

bool Character::isLetter(Char32 cp) {
  if (cp < Char32(0x80))
    return 0 != std::isalpha(static_cast<unsigned char>(cp));
  else
    return false;
}

bool Character::isLetterOrDigit(Char32 cp) {
  return isLetter(cp) || isDigit(cp);
}

bool Character::isLowerCase(Char32 cp) {
  if (cp < Char32(0x80))
    return 0 != std::islower(static_cast<unsigned char>(cp));
  else
    return false;
}

bool Character::isUpperCase(Char32 cp) {
  if (cp < Char32(0x80))
    return 0 != std::isupper(static_cast<unsigned char>(cp));
  else
    return false;
}

bool Character::isWhitespace(Char32 cp) {
  if (cp < Char32(0x80))
    return 0 != std::isspace(static_cast<unsigned char>(cp));
  else
    return false;
}

}  // namespace lang
