#include <lang/Character.h>
#include <lang/String.h>

#include <catch2/catch_all.hpp>
#include <cstring>

TEST_CASE("Character", "[lang]") {
  REQUIRE(lang::Character::isDigit('0'));
  REQUIRE_FALSE(lang::Character::isDigit('B'));

  REQUIRE(lang::Character::isLetter('A'));
  REQUIRE_FALSE(lang::Character::isLetter('0'));

  REQUIRE(lang::Character::isLetterOrDigit('0'));
  REQUIRE(lang::Character::isLetterOrDigit('A'));
  REQUIRE_FALSE(lang::Character::isLetterOrDigit('-'));

  REQUIRE(lang::Character::isLowerCase('a'));
  REQUIRE_FALSE(lang::Character::isLowerCase('A'));

  REQUIRE(lang::Character::isUpperCase('A'));
  REQUIRE_FALSE(lang::Character::isUpperCase('a'));

  REQUIRE(lang::Character::isWhitespace(' '));
  REQUIRE_FALSE(lang::Character::isWhitespace('A'));
  REQUIRE_FALSE(lang::Character::isWhitespace('9'));
}

TEST_CASE("String", "[lang]") {
  lang::Char p_ch[] = "Hello, World!";
  lang::String str{p_ch};

  SECTION("string part initialization") {
    lang::String s(p_ch, 5);
    REQUIRE(s.length() == 5);
  }

  SECTION("get character from string") { REQUIRE(str.charAt(5) == ','); }

  SECTION("copy chars from String to char array") {
    constexpr size_t len_arr_with_zero = 11 - 7 + 2;
    char charr[len_arr_with_zero];

    str.getChars(7, 11, charr);
    REQUIRE(std::strcmp(charr, "World") == 0);
  }

  SECTION("check prefix and suffix") {
    REQUIRE(str.startsWith("Hello"));
    REQUIRE(str.endsWith("World!"));
  }

  SECTION("get hash code") {
    REQUIRE(str.hashCode() != 0);
    REQUIRE(str.hashCode() == 1498789909);
  }
}