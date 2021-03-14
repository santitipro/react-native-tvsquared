import { NativeModules } from 'react-native';

type TvsquaredType = {
  initialize(hostname: string, clientKey: string): void;
  track(): void;
  trackUser(userId: string): void;
  trackAction(
    actionName: string,
    product: string,
    actionId: string,
    renueve: number,
    promoCode: string
  ): void;
};

const { Tvsquared } = NativeModules;

export default Tvsquared as TvsquaredType;
