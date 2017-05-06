//
//  main.m
//  OC_lua
//
//  Created by BlueLutoFlower on 2017/5/5.
//  Copyright © 2017年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#pragma mark - Lua调用C语言代码
int sayHello(lua_State *L) {
    printf("无参C方法\n");
    return 0;
}

int getStringFun(lua_State *L) {
    const char * name = luaL_checkstring(L, 1);
    char buff[100];
    memset(buff, 0, 100);
    sprintf(buff, "Hello %s\n",name);
    
    lua_pushstring(L, buff);
    printf("有参C方法%s\n",lua_tostring(L, -1));
    lua_pop(L, 1);
    return 1;
}

#pragma mark - 访问Lua中的全局变量
void callglobelGaram(lua_State *L){
    printf("\n");
    printf("访问Lua中的全局变量: \n");
    
    //.获取全局变量
    lua_getglobal(L, "name");
    lua_getglobal(L, "version");
    
    printf("version:%s\n",lua_tostring(L, -1));
    lua_pop(L, 1);
    
    printf("name:%s\n",lua_tostring(L, -1));
    lua_pop(L, 1);
    
    //.获取table中的值
    printf("\n");
    printf("访问Lua中的全局变量table的值: \n");
    lua_getglobal(L, "people");
    lua_getfield(L, 1, "name");
    if (lua_isstring(L, -1)) {
        printf("people.name:%s\n",lua_tostring(L, -1));
        lua_pop(L, 1);
    }
    
    lua_getfield(L, 1, "age");
    if (lua_isstring(L, -1)) {
        printf("people.age:%s\n",lua_tostring(L, -1));
        lua_pop(L, 1);
    }
    
    lua_getfield(L, 1, "sex");
    if (lua_isstring(L, -1)) {
        printf("people.sex:%s\n",lua_tostring(L, -1));
        lua_pop(L, 1);
    }
    
    lua_pop(L, 1);

}

#pragma mark - C调用Lua方法
void callLua_Func(lua_State *L){
    
    printf("\n");
    printf("C调用Lua方法: \n");
    //调用lua方法无参数function
    lua_getglobal(L, "main");
    /*lua_call
     *
     *第一个参数：lua_State
     *第二个参数：func参数个数
     *第三个：func返回值
     */
    lua_call(L, 0, 0);
    
    //调用lua方法有参数function
    lua_getglobal(L, "getString");
    lua_pushstring(L, "ZhangSan");
    lua_call(L, 1, 1);
    if (lua_isstring(L, -1)) {
        printf("%s\n",lua_tostring(L, -1));
    }
    lua_pop(L, 1);
}

#pragma mark - Lua调用C方法
void callC_Fun(lua_State *L){
    
    printf("\n");
    printf("Lua调用C方法: \n");
    /*lua_register
     *第一个参数：lua_State
     *第二个参数：提供Lua的方法名
     *第三个参数：Lua访问的C方法名
     */
    lua_register(L, "sayHello", sayHello);//lua调用C方法(无参数）
    lua_register(L, "getStringFun", getStringFun);//lua调用C方法(有参数）
    
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        lua_State *L = luaL_newstate(); //打开lua
        luaL_openlibs(L);               //打开lua标准库
        char *str = "/Users/bluelutoflower/Documents/OC_lua/OC_lua/hello.lua";
        
        //1.lua调用C func
        callC_Fun(L);
        
        luaL_dofile(L, str);//lua调用C func必须在luaL_dofile调用之前
        
        //2.C调用Lua func
        callLua_Func(L);
        
        //3.访问Lua全局变量
        callglobelGaram(L);
        
        //关闭lua
        lua_close(L);
    }
    return 0;
}
