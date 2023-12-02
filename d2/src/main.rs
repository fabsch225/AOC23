use std::{io::{BufReader, BufRead}, fs::File};

fn main() {
    let reader = BufReader::new(File::open("in.txt").expect("Cannot open file"));

    let mut val : i32 = 0;

    let mut a : char = ' ';
    let mut b : char = ' ';
    let mut c : char = ' ';
    let mut d : char = ' ';

    

    for (_i, line) in reader.lines().enumerate() {
        let ls = line.expect("");
        let s = ls.chars();

        let mut rm = 0;
        let mut gm = 0;
        let mut bm = 0;

        for ch in s {            
            d = c;
            c = b;
            b = a;

            a = ch;

            let d_ = c.is_digit(10); 
            let dd_ = c.is_digit(10) && d.is_digit(10);

          

            let mut v = 0;

            if dd_ {
                let v1 = c.to_digit(10).expect("");
                let v2 = d.to_digit(10).expect("");

                v = v2 * 10 + v1; 
            }
            else if d_ {
                let v1 = c.to_digit(10).expect("");

                v = v1;
            }

            if a == 'r' {
                if (v > rm) {
                    rm = v;
                }
            } 
            else if a == 'g' {
                if (v > gm) {
                    gm = v;
                }   
            }
            else if a == 'b' {
                if (v > bm) {
                    bm = v;
                }
            }
        }

        val = val + rm as i32 * bm as i32 * gm as i32;

        println!("{}", ls);
        println!("{}, {}, {} : {}", rm, gm, bm, rm as i32 * bm as i32 * gm as i32);

    }

    println!("{}", val);
}
