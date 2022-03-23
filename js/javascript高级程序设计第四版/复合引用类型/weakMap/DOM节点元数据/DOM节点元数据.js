const wm = new WeakMap();

let box = document.querySelector('#box');

wm.set(box, { backgroundColor: 'red' });

box = null;


console.log(wm.get(box), wm);