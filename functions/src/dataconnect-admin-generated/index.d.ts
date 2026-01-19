import { ConnectorConfig, DataConnect, OperationOptions, ExecuteOperationResponse } from 'firebase-admin/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;


export interface Category_Key {
  id: UUIDString;
  __typename?: 'Category_Key';
}

export interface CreateRestaurantData {
  restaurant_insert: Restaurant_Key;
}

export interface DeliveryZone_Key {
  id: UUIDString;
  __typename?: 'DeliveryZone_Key';
}

export interface GetRestaurantCategoriesData {
  categories: ({
    id: UUIDString;
    name: string;
    description?: string | null;
  } & Category_Key)[];
}

export interface GetRestaurantCategoriesVariables {
  restaurantId: UUIDString;
}

export interface ListMenuItemsData {
  menuItems: ({
    id: UUIDString;
    name: string;
    description?: string | null;
    price: number;
  } & MenuItem_Key)[];
}

export interface MenuItem_Key {
  id: UUIDString;
  __typename?: 'MenuItem_Key';
}

export interface OrderItem_Key {
  id: UUIDString;
  __typename?: 'OrderItem_Key';
}

export interface Order_Key {
  id: UUIDString;
  __typename?: 'Order_Key';
}

export interface Restaurant_Key {
  id: UUIDString;
  __typename?: 'Restaurant_Key';
}

export interface UpdateOrderStatusData {
  order_update?: Order_Key | null;
}

export interface UpdateOrderStatusVariables {
  orderId: UUIDString;
  status: string;
}

/** Generated Node Admin SDK operation action function for the 'CreateRestaurant' Mutation. Allow users to execute without passing in DataConnect. */
export function createRestaurant(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateRestaurantData>>;
/** Generated Node Admin SDK operation action function for the 'CreateRestaurant' Mutation. Allow users to pass in custom DataConnect instances. */
export function createRestaurant(options?: OperationOptions): Promise<ExecuteOperationResponse<CreateRestaurantData>>;

/** Generated Node Admin SDK operation action function for the 'ListMenuItems' Query. Allow users to execute without passing in DataConnect. */
export function listMenuItems(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<ListMenuItemsData>>;
/** Generated Node Admin SDK operation action function for the 'ListMenuItems' Query. Allow users to pass in custom DataConnect instances. */
export function listMenuItems(options?: OperationOptions): Promise<ExecuteOperationResponse<ListMenuItemsData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateOrderStatus' Mutation. Allow users to execute without passing in DataConnect. */
export function updateOrderStatus(dc: DataConnect, vars: UpdateOrderStatusVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateOrderStatusData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateOrderStatus' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateOrderStatus(vars: UpdateOrderStatusVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateOrderStatusData>>;

/** Generated Node Admin SDK operation action function for the 'GetRestaurantCategories' Query. Allow users to execute without passing in DataConnect. */
export function getRestaurantCategories(dc: DataConnect, vars: GetRestaurantCategoriesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetRestaurantCategoriesData>>;
/** Generated Node Admin SDK operation action function for the 'GetRestaurantCategories' Query. Allow users to pass in custom DataConnect instances. */
export function getRestaurantCategories(vars: GetRestaurantCategoriesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetRestaurantCategoriesData>>;

