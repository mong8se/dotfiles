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

export function storeAndGetValue<T>(initalValue: T) {
  const gen = makeValueStore(initalValue);
  gen.next();
  return async (value?: T) => {
    const v = await gen.next(value);
    return v.value;
  };
}
