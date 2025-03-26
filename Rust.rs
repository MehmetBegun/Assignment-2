use std::io::{self, Write};
use std::collections::HashMap;

#[derive(Debug, Clone)]
enum Token {
    Number(f64),
    Identifier(String),
    Plus,
    Minus,
    Star,
    Slash,
    Caret,
    LParen,
    RParen,
    Equal,
}

fn tokenize(input: &str) -> Result<Vec<Token>, String> {
    let mut tokens = Vec::new();
    let chars: Vec<char> = input.chars().collect();
    let mut i = 0;
    while i < chars.len() {
        let c = chars[i];
        if c.is_whitespace() {
            i += 1;
        } else if c.is_digit(10) || c == '.' {
            let mut num_str = String::new();
            while i < chars.len() && (chars[i].is_digit(10) || chars[i] == '.') {
                num_str.push(chars[i]);
                i += 1;
            }
            let number = num_str.parse::<f64>().map_err(|_| format!("Invalid number: {}", num_str))?;
            tokens.push(Token::Number(number));
        } else if c.is_alphabetic() {
            let mut ident = String::new();
            while i < chars.len() && (chars[i].is_alphanumeric() || chars[i] == '_') {
                ident.push(chars[i]);
                i += 1;
            }
            tokens.push(Token::Identifier(ident));
        } else {
            match c {
                '+' => { tokens.push(Token::Plus); i += 1; },
                '-' => { tokens.push(Token::Minus); i += 1; },
                '*' => { tokens.push(Token::Star); i += 1; },
                '/' => { tokens.push(Token::Slash); i += 1; },
                '^' => { tokens.push(Token::Caret); i += 1; },
                '(' => { tokens.push(Token::LParen); i += 1; },
                ')' => { tokens.push(Token::RParen); i += 1; },
                '=' => { tokens.push(Token::Equal); i += 1; },
                _ => return Err(format!("Unexpected character: {}", c))
            }
        }
    }
    Ok(tokens)
}

struct Parser<'a> {
    tokens: &'a [Token],
    pos: usize,
}

impl<'a> Parser<'a> {
    fn new(tokens: &'a [Token]) -> Self {
        Parser { tokens, pos: 0 }
    }
    
    fn current(&self) -> Option<&Token> {
        self.tokens.get(self.pos)
    }
    
    fn eat(&mut self) -> Option<&Token> {
        let tok = self.tokens.get(self.pos);
        if tok.is_some() { self.pos += 1; }
        tok
    }
    
    fn parse_expression(&mut self) -> Result<f64, String> {
        let mut result = self.parse_term()?;
        while let Some(tok) = self.current() {
            match tok {
                Token::Plus => { self.eat(); result += self.parse_term()?; },
                Token::Minus => { self.eat(); result -= self.parse_term()?; },
                _ => break,
            }
        }
        Ok(result)
    }
    
    fn parse_term(&mut self) -> Result<f64, String> {
        let mut result = self.parse_factor()?;
        while let Some(tok) = self.current() {
            match tok {
                Token::Star => { self.eat(); result *= self.parse_factor()?; },
                Token::Slash => {
                    self.eat();
                    let denom = self.parse_factor()?;
                    if denom == 0.0 {
                        return Err("Division by zero".to_string());
                    }
                    result /= denom;
                },
                _ => break,
            }
        }
        Ok(result)
    }
    
    fn parse_factor(&mut self) -> Result<f64, String> {
        let result = self.parse_primary()?;
        if let Some(Token::Caret) = self.current() {
            self.eat();
            let exponent = self.parse_factor()?;
            Ok(result.powf(exponent))
        } else {
            Ok(result)
        }
    }
    
    fn parse_primary(&mut self) -> Result<f64, String> {
        let tok = self.eat().ok_or_else(|| "Unexpected end of input in primary".to_string())?;
        match tok {
            Token::Number(n) => Ok(*n),
            Token::Identifier(name) => Err(format!("Undefined variable: {}", name)),
            Token::LParen => {
                let result = self.parse_expression()?;
                match self.eat() {
                    Some(Token::RParen) => Ok(result),
                    _ => Err("Missing closing parenthesis".to_string()),
                }
            },
            _ => Err("Unexpected token in primary".to_string()),
        }
    }
}

fn main() {
    let mut variables: HashMap<String, f64> = HashMap::new();
    println!("Enter an expression (or assignment). Type 'exit' to quit.");
    loop {
        print!("> ");
        io::stdout().flush().unwrap();
        let mut input = String::new();
        if io::stdin().read_line(&mut input).unwrap() == 0 {
            break;
        }
        let input = input.trim();
        if input == "exit" {
            break;
        }
        
        if let Some(eq_pos) = input.find('=') {
            let var_name = input[..eq_pos].trim();
            let expr_str = input[eq_pos+1..].trim();
            if var_name.is_empty() {
                println!("Error: No variable name provided.");
                continue;
            }
            match tokenize(expr_str) {
                Ok(tokens) => {
                    let mut parser = Parser::new(&tokens);
                    match parser.parse_expression() {
                        Ok(val) => {
                            variables.insert(var_name.to_string(), val);
                            println!("{} defined with value: {}", var_name, val);
                        },
                        Err(e) => println!("Error: {}", e),
                    }
                },
                Err(e) => println!("Error: {}", e),
            }
        } else {
            match tokenize(input) {
                Ok(mut tokens) => {
                    for token in tokens.iter_mut() {
                        if let Token::Identifier(ref name) = token {
                            if let Some(val) = variables.get(name) {
                                *token = Token::Number(*val);
                            } else {
                                println!("Error: Undefined variable: {}", name);
                                continue;
                            }
                        }
                    }
                    let mut parser = Parser::new(&tokens);
                    match parser.parse_expression() {
                        Ok(val) => println!("Result: {}", val),
                        Err(e) => println!("Error: {}", e),
                    }
                },
                Err(e) => println!("Error: {}", e),
            }
        }
    }
}
