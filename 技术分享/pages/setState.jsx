import React, { useCallback, useState } from 'react';

// setState是同步还是异步
// export default class SetState extends React.Component {

//     state = {
//         count: 1
//     }

//     onClick = () => {
//         setTimeout(() => {
//             this.setState({ count: this.state.count + 1 });
//             this.setState({ count: this.state.count + 1 });
//             this.setState({ count: this.state.count + 1 });
//             this.setState({ count: this.state.count + 1 });
//              console.log(this);
//         });
//     }

//     render() {
//        return <div style={{fontSize:100}} onClick={this.onClick}>{this.state.count}</div>
//     }
// }

// export default () => {
//     const [count, setCount] = useState(1)

//     console.log('re-render');
//     const onClick = () => {
//     //    setTimeout(()=>{
//         setCount(1);
//         console.log('1111');
//         setCount(2);
//         console.log('2222');
//         setCount(3);
//         console.log('3333');
//         setCount(4);
//         console.log('4444');
//     //    })
//     }

//     return <div style={{fontSize:100}} onClick={onClick}>{count}</div>
// }

// 同时调用多个setState
export default () => {
    const [count, setCount] = useState(1)


    const onClick = () => {
        setCount(1);
        console.log(count);
        setCount(2);
        console.log(count);
        setCount(3);
        console.log(count);
        setCount(4);
        console.log(count);
    }

    return <div style={{fontSize:100}} onClick={onClick}>{count}</div>
}