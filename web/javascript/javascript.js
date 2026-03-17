console.log(Math.floor(Math.random()*11));

console.log("Hello, Students!");
A = 10;
B = 20;
C = A + B;
console.log("The sum of A and B is: " + C);

if (C > 25) {
    console.log("and C is, of course, greater than 25");
}else {
    console.log("and C is, of course, less than, or it might be equal to 25");
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

function multiply(a, b) {
    return a * b;
}

console.log("The product of A and B is: " + multiply(A, B));

function divide(a, b) {
    return a / b;
}

console.log("The quotient of A and B is: " + divide(A, B));

function subtract(a, b) {
    return a - b;
}   

console.log("The difference of A and B is: " + subtract(A, B));

function add(a, b) {
    return a + b;
}

console.log("The sum of A and B is: " + add(A, B));