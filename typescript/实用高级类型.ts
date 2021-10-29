type Props = {
  a?: number;
  b: number;
};

/** Partial 将所有类型转换为可选类型 */
const a: Partial<Props> = { a: 1 };
// 等价于
type MyPartial<T> = { [P in keyof T]?: T[P] };

/** Required 将所有属性转换为必需 */
const b: Required<Props> = { a: 1, b: 2 };
// 等价于
type MyRequired<T> = { [P in keyof T]-?: T[P] };

/** Readonly 将所有属性设置为只读 */
const c: MyReadonly<Props> = { a: 1, b: 2 };
// 等价于
type MyReadonly<T> = { readonly [P in keyof T]: T[P] };

/** Record 构造属性键为Keys，属性值为Type的对象类型 */
const d: Record<keyof Props, number> = { a: 1, b: 1 };
// 等价于
type MyRecord<K extends string | number | symbol, T> = { [P in K]: T };

/** Pick 选择一组属性Keys（字符串文本或者字符串文本的并集）来构造类型 */
const e: Pick<Props, "a" | "b"> = { a: 2, b: 1 };
// 等价于
type MyPick<T, K extends keyof T> = { [P in K]: T[P] };

/** Omit 删除自定义的Keys  */
const f: Omit<Props, "b"> = { a: 1, b: 2 };
// 等价于
type MyOmit<T, K extends string | number | symbol> = {
  [P in Exclude<keyof T, K>]: T[P];
};
