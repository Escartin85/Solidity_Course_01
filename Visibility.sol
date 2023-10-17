// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Visibility {
    int public x = 10;
    int y = 20;

    function get_y() public view returns(int){
        return y;
    }
    function f1() private view returns(int){
        return x;
    }
    function f2() public view returns(int){
        int a;
        a = f1();
        return a;
    }
    function f3() internal view returns(int){
        return x;
    }
    function f4() external view returns(int){
        return x;
    }
    function f5() public pure returns(int){
        int b;
        // b = f4();  // f4() is external
        return b;
    }
}

contract B is Visibility{
    int public xx = f3();
    // int pulic yy = f1();  -> f1() is private and cannot be called from derived contracts
}

contract C{
    Visibility public contract_a = new Visibility();
    int public xx = contract_a.f4();
    // int public y = contract_a.f1();     // Error
    // int public yy = contract_a.f3();    // Error
}