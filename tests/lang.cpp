#include <lang/Character.h>

#include <catch2/catch_all.hpp>

TEST_CASE("Character", "[lang]") {
  REQUIRE(lang::Character::isDigit('0') == true);
  REQUIRE(lang::Character::isDigit('B') == false);

  REQUIRE(lang::Character::isLetter('A') == true);
  REQUIRE(lang::Character::isLetter('0') == false);

  REQUIRE(lang::Character::isLetterOrDigit('0') == true);
  REQUIRE(lang::Character::isLetterOrDigit('A') == true);

  REQUIRE(lang::Character::isLowerCase('A') == false);
  REQUIRE(lang::Character::isLowerCase('a') == true);

  REQUIRE(lang::Character::isUpperCase('A') == true);
  REQUIRE(lang::Character::isUpperCase('a') == false);

  REQUIRE(lang::Character::isWhitespace(' ') == true);
  REQUIRE(lang::Character::isWhitespace('A') == false);
  REQUIRE(lang::Character::isWhitespace('9') == false);
}