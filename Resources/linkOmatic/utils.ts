async function* makeValueStore<T>(
  initalValue: T
): AsyncGenerator<T, any, T | undefined> {
  let value = initalValue;
  while (true) {
    const response: T | undefined = yield value;
    if (typeof response !== "undefined") {
      value = response as T;
    }
  }
}

export function storeAndGetValue<T>(initalValue: T): StoreAndGetValue<T> {
  const gen = makeValueStore(initalValue);
  const setValue = gen.next.bind(gen);

  return async (callback) =>
    gen.next().then((current) => callback(current.value, setValue));
}

export type StoreAndGetValue<T> = (
  callback: (current: T, set: (value: T) => void) => Promise<any>
) => Promise<any>;
