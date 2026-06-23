@isTest
private class HelloWorldTest {
    @isTest
    static void greetsNamedUser() {
        System.assertEquals('Hello, Ada!', HelloWorld.greet('Ada'));
    }

    @isTest
    static void greetsWorldWhenBlank() {
        System.assertEquals('Hello, world!', HelloWorld.greet(null));
        System.assertEquals('Hello, world!', HelloWorld.greet(''));
        System.assertEquals('Hello, world!', HelloWorld.greet('   '));
    }
}
