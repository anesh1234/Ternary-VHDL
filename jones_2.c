balanced int rem, quo; /* the remainder and quotient, return values */
void div( balanced int ividend, balanced int divisor ) {
    balanced int one = 1; /* determines whether to negate bits of quotient */
    if (divisor < 0) { /* take absolute value of divisor */
        divisor = -divisor;
        one = -one;
    }
    quo = dividend;
    rem = 0;
    for (i = 0; i < trits_per_word; i++) {
        /* first shift rem-quo double register 1 trit left */
        (rem,quo) = (rem,quo) <<3 1;

        /* second, compute one trit of quotient */
        if (rem > 0) {
	    balanced int low = rem - divisor;
            if ( (-low < rem) || ((-low == rem) && (quo > 0)) ) {
                quo = quo + one;
                rem = low;
            }
        } 
        
        else if (rem < 0) {
	    balanced int high = rem + divisor;
            if ( (-high > rem) || ((-high == rem) && (quo < 0)) ) {
                quo = quo - one;
                rem = high;
            }
	    }
    }
}