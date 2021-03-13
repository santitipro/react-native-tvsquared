import { NativeModules } from 'react-native';

type TvsquaredType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Tvsquared } = NativeModules;

export default Tvsquared as TvsquaredType;
