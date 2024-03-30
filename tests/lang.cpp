#include <lang/Character.h>
#include <lang/String.h>
#include <lang/UTFConverter.h>

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

  SECTION("get index") {
    REQUIRE(str.indexOf(',') == 5);
    REQUIRE(str.indexOf('l') == 2);
    REQUIRE(str.indexOf('l', 3) == 3);
    REQUIRE(str.indexOf('x') == -1);
    REQUIRE(str.lastIndexOf('o') == 8);
    REQUIRE(str.lastIndexOf("l") == 10);
    REQUIRE(str.lastIndexOf('l', 9) == 3);
  }

  SECTION("check region strings") {
    REQUIRE(str.regionMatches(7, "This is World fine!", 8, 5));
    REQUIRE_FALSE(str.regionMatches(0, "This is World fine!", 8, 5));
  }

  SECTION("replace characters") {
    REQUIRE(str.replace('l', 'z').compareTo("Hezzo, Worzd!") == 0);
  }

  SECTION("substring") {
    REQUIRE(str.substring(7).compareTo("World!") == 0);
    REQUIRE(str.substring(2, 4).compareTo("llo,"_s) == 0);
  }

  SECTION("to lower case") {
    REQUIRE(str.toLowerCase().compareTo("hello, world!"_s) == 0);
  }

  SECTION("to upper case") {
    REQUIRE(str.toUpperCase().compareTo("HELLO, WORLD!") == 0);
  }

  SECTION("trim whitespace character") {
    REQUIRE(" Hello"_s.trim().compareTo("Hello"_s) == 0);
  }

  SECTION("comparative operators") {
    REQUIRE("Hello, World!"_s == str);
    REQUIRE("WEX"_s > str);
    REQUIRE_FALSE("Aria"_s > str);
    REQUIRE(("Hello,"_s + " World!"_s) == str);
  }

  SECTION("value to string") {
    REQUIRE(lang::String::valueOf(538) == "538"_s);
    REQUIRE(lang::String::valueOf(53.234f) == "53.234"_s);
  }
}

TEST_CASE("UTFConverter", "[lang]") {
  std::wstring ws = {
      L"\u041F\u0440\u0438\u0432\u0435\u0442"};  // "Привет" word Unicode
                                                 // points

  SECTION("Std strings convert") {
    std::string s{"Привет"};
    std::wstring res = lang::utfconverter::utf8ToUtf16(s);

    REQUIRE(res == ws);
  }

  /*SECTION("Lang string convert") {
    lang::String s{"Привет"};
    std::wstring res = lang::utfconverter::utf8ToUtf16(s);

    REQUIRE(res = ws);
  }*/
}