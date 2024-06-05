template<typename T>
inline T sind(T arg) {
	arg *= M_PI / 180; // Convert to radians
	return std::sin(arg);
}

template<typename T>
inline T cosd(T arg) {
	arg *= M_PI / 180; // Convert to radians
	return std::cos(arg);
}

template<typename T>
inline T atan2d(T y, T x) {
	y *= M_PI / 180; // Convert to radians
	x *= M_PI / 180; // Convert to radians
	return std::atan2(y, x);
}

template<typename T>
inline T floorDiv(T dividend, T divisor) {
	// Perform the division
	T quotient = dividend / divisor;
	// If the signs of dividend and divisor are different and there's a remainder
    if ((std::remainder(dividend, divisor) != 0) && (dividend < 0) != (divisor < 0)) {
        // Decrement the quotient to floor the result
        quotient -= 1;
    }

    return quotient;
}