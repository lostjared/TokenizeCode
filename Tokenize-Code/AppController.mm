//
//  AppController.m
//  Tokenize-Code
//
//  Created by Jared Bruni on 8/5/16.
//  Copyright © 2016 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"AppController.h"
#include<iostream>
#include<string>
#include<cstdio>
#include<cstdlib>
#include<sstream>
#include<cstring>
#include<fstream>
#include"lexer.hpp"




@implementation AppController
//@synthesize web_v;

int run_main(const std::string &ctext);


- (IBAction) tokenizeCode:(id) sender {
    NSString *text = [[text_v textStorage] string];
    std::string cxxtext = std::string([text UTF8String]);
    run_main(cxxtext);
    NSString *file_path = @"/tmp/test.html";
    NSURL *file_url = [NSURL fileURLWithPath:file_path];
    NSURLRequest *request = [NSURLRequest requestWithURL:file_url];
    [[web_v mainFrame] loadRequest:request];
    //[[web_v mainFrame]loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];
    [window_v orderFront:self];
}


std::string urldecode(std::string text);

//! convert text back to HTML
/*!
 \param text text to convert
 \return tranlsated text
 */
std::string toHTML(const std::string &text) {
    std::string temp;
    for(unsigned int i = 0; i < text.length(); ++i) {
        switch(text[i]) {
            case '<':
                temp += "&lt;";
                break;
            case '>':
                temp += "&gt;";
                break;
            case '(':
                temp += "&#40;";
                break;
            case ')':
                temp += "&#41;";
                break;
            case '.':
                temp += "&#46;";
                break;
            case ';':
                temp += "&#59;";
                break;
            default:
                temp += text[i];
                break;
        }
    }
    return temp;
}
//! output token
/*!
 \param out stream to output the html to
 \param t the Token to output
 */

unsigned int counter = 0;

void outputToken(std::ostringstream &out, lex::Token &t) {
    
    if(t.isKeyword() && (t.getTokenType() != lex::TOKEN_STRING && t.getTokenType() != lex::TOKEN_SINGLE)) {
        out << "<tr><td class=\"lineindex_color\">" << ++counter << "</td><td class=\"codekeyword\">" << toHTML(t.getToken()) << "</b></td><td class=\"linetype\">Keyword</td><td class=\"linenum\">" << t.line << "</td></tr>";
        
    } else {
        
        std::string codecolor;
        switch(t.getTokenType()) {
            case lex::TOKEN_STRING:
                codecolor = "codestring";
                break;
            case lex::TOKEN_OPERATOR:
                codecolor = "codesymbol";
                break;
            case lex::TOKEN_DIGIT:
                codecolor = "codedigit";
                break;
            case lex::TOKEN_SINGLE:
                codecolor = "codechar";
                break;
            default:
                codecolor = "codetext";
        }
        
        out << "<tr><td class=\"lineindex_color\">" << ++counter << "</td><td class=\"" << codecolor << "\">" << toHTML(t.getToken()) << "</td><td class=\"linetype\">" << t.getType() << "</td><td class=\"linenum\">" << t.line << "</td></tr>\n";
    }
}

//! main function
/*!
 \param argc argument count for main function
 \param argv argument values for main function
 */
int run_main(const std::string &ctext) {
    counter = 0;
    std::ostringstream ofile;
    std::istringstream input(ctext);
    lex::Scanner scan(input);
    
    ofile << "<!DOCTYPE html>\n";
    ofile << "<html><head><title>" << "C++ Tokenizer " << "</title></head>\n";
    ofile << "<body>\n";
    ofile << "<style>\n";
    ofile << ".linenumber { background-color: rgb(0,100,200); }\n";
    ofile << ".lineindex_color { color: rgb(255,255,255); background-color: #000000; }\n";
    ofile << ".linetype { color: rgb(100,0,255); background-color: rgb(25,255,100); }\n";
    ofile << ".linenum { color: rgb(50,255,50); background-color: #888888; }\n";
    ofile << ".codetext { color: #000000; background-color: rgb(255,254,208);}\n";
    ofile << ".codekeyword { color: rgb(0,0,255); font-weight: bold; }\n";
    ofile << ".codestring { color: rgb(255,0,255);background-color: rgb(200, 200,200); }\n";
    ofile << ".codesymbol { color: rgb(76,255,198); background-color: rgb(100,100,100); }\n";
    ofile << ".codedigit { color: rgb(0,255,186); background-color: rgb(0,0,0); }\n";
    ofile << ".codechar { color: rgb(187,212,249); background-color: rgb(94,0,167); }\n";
    ofile << "</style>\n";
    ofile << "<table border=\"1\" cellspacing=\"4\" cellpadding=\"4\"><tr style=\"background-color: rgb(150, 150, 150);\"><td class=\"linenumber\"><b>Index</b></td><td class=\"linenumber\"><b>Token</b></td><td class=\"linenumber\"><b>Type</b></td><td class=\"linenumber\"><b>Line Number</b></td></tr>\n";
    
    try {
        while(scan.valid()) {
            lex::Token token;
            scan >> token;
            outputToken(ofile, token);
        }
    } catch(lex::Scanner_EOF) {
        
    } catch(lex::Scanner_Error) {
        std::cout << "A error has occured. Check your source.\n";
    }
    
    ofile << "\n</table></body></html>";
    
    std::cout << ofile.str() << "\n";
    std::fstream file;
    
    file.open("/tmp/test.html", std::ios::out);
    if(!file.is_open()) {
        std::cerr << "Error failed to write temporary file..\n";
    }
    file << ofile.str() << "\n";
    file.close();
    return 0;
}

//! urldecode translate url back into standard text
/*!
 \param text text to convert
 \return translsated string
 */
std::string urldecode(std::string text) {
    std::ostringstream stream;
    for(unsigned int i = 0; i < text.length(); ++i) {
        if(text[i] == '+') {
            stream << " ";
            continue;
        }
        if(text[i] == '%') {
            if(i+2 < text.length()) {
                ++i;
                std::string test;
                test += text[i];
                ++i;
                test += text[i];
                int char_value;
                sscanf(test.c_str(), "%x", &char_value);
                stream << (char)char_value;
                continue;
            }
        }
        stream << text[i];
    }
    return stream.str();
}




@end
