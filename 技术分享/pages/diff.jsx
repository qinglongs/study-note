import React, { useState } from "react";

export default function App() {
    const [toggle, setToggle] = useState(true);

    /*** 单节点 */
    //  key&&type 相同 可以被复用
    //   const a = <div key="a">a</div>;
    //   const b = <div key="a">b</div>;

    //   有兄弟节点被删除
    //   const a = <><div key="a">a</div><div key="b">b</div></>;
    //   const b = <div key="a">b</div>;

    //   type不同不可复用,会创建一个全新的fiber
    //   const a = <div>a</div>;
    //   const b = <p>b</p>;

    //  属性变化 复用节点
    //   const a = <div key="a">a</div>;
    //   const b = <div key="a" name="b">a</div>;


    /** 多节点 */
    // 新增节点,会创建新的fiber对象
    // const a = <div key="a">a</div>;
    // const b = <><div key="a">a</div><div key="b">b</div></>;

    // 属性变化 复用并更新fiber对象
    // const a = <><div key="a" name="1">a</div><div key="b">b</div></>;
    // const b = <><div key="a" name="2">b</div><div key="b">a</div></>;
    
    // 删除节点,被删除的节点会被打上删除标记,等待commit阶段执行
    const a = <><div key="a">a</div><div key="b">b</div><div key="c">c</div></>;
    const b = <><div key="a">a</div><div key="b">b</div></>;

    return (
        <div
            onClick={() => {
                setToggle(!toggle);
            }}
        >
            {toggle ? a : b}
        </div>
    );
}
