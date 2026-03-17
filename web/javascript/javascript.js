console.log("Hello, World!");
A = 10;
B = 20;
C = A + B;
console.log("The sum of A and B is: " + C);

if (C > 25) {
    console.log("and C is greater than 25");
}else {
    console.log("and C is less than or equal to 25");
}

if (A > B) {
    console.log("and A is greater than B by " + (A - B));
}else if (A < B) {
    console.log("and A is less than B by " + (B - A));
}else {
    console.log("and A is equal to B");
}

console.log("So what is the value of A and B?");
console.log("The value of A is: " + A);
console.log("The value of B is: " + B);