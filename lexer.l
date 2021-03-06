/*
   Example using Flex and Bison with Qt.
   Copyright (C) 2013  Gonzalo Exequiel Pedone

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with This program.  If not, see <http://www.gnu.org/licenses/>.

   Email   : hipersayan DOT x AT gmail DOT com
   Web-Site: http://github.com/hipersayanX/FlexBisonQt
*/

%{
// We include QtScript because we neeed to convert from a string representation
// to an string literal.
#include <QtScript>

// Also include the Bison generated header where the tokens are defined.
#include "parser.h"
%}

%%

 /* Parse symbols */
\( return TOK_LEFTPAREN;
\) return TOK_RIGHTPAREN;
\{ return TOK_LEFTCURLYBRACKET;
\} return TOK_RIGHTCURLYBRACKET;
\[ return TOK_LEFTBRACKET;
\] return TOK_RIGHTBRACKET;
,  return TOK_COMMA;
:  return TOK_COLON;

 /* Parse Intiger numbers */
-?[0-9]+ {
    // yylval and yytext are predefined variables generated by Flex.
    // yylval stores the value that will be sended to the parser.
    // yytext stores the string matched by Flex.
    yylval.QVariant_t = new QVariant();
    *yylval.QVariant_t = QString(yytext).toInt();

    return TOK_INTIGER;
}

 /* Parse float numbers */
-?([0-9]+\.[0-9]+|\.[0-9]+|[0-9]+\.) {
    yylval.QVariant_t = new QVariant();
    *yylval.QVariant_t = QString(yytext).toFloat();

    return TOK_FLOAT;
}

 /* Parse booleans */
true|false {
    yylval.QVariant_t = new QVariant();

    if (QString(yytext) == "true")
        *yylval.QVariant_t = true;
    else
        *yylval.QVariant_t = false;

    return TOK_BOOLEAN;
}

 /* Parse keywords */
size     return TOK_SIZE;
sizeF    return TOK_SIZEF;
point    return TOK_POINT;
pointF   return TOK_POINTF;
rect     return TOK_RECT;
rectF    return TOK_RECTF;
line     return TOK_LINE;
lineF    return TOK_LINEF;
date     return TOK_DATE;
time     return TOK_TIME;
dateTime return TOK_DATETIME;
color    return TOK_COLOR;
b        return TOK_BYTES;
url      return TOK_URL;

 /* Parse booleans */
\"([^"\\]*|\\.)*\"|'([^'\\]*|\\.)*' {
    yylval.QVariant_t = new QVariant();
    QScriptEngine scriptEngine;
    *yylval.QVariant_t = scriptEngine.evaluate(QString(yytext)).toString();

    return TOK_STRING;
}

. // Unrecognized token.

%%
