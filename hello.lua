--全局变量
version = 2.1;
name = "eoe";

--table型数据
people = {
    name = "zhangsan",
    age = 20,
    sex = "男"
}

--Lua（无参）方法
function main()
    print("hello fun");
end

--Lua（有参）方法
function getString(name)
    return "hello "..name;
end

--Lua调用C（无参）方法
sayHello();

--Lua调用C（有参）方法
getStringFun("abc");

