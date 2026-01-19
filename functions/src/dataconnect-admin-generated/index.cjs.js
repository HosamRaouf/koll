const { validateAdminArgs } = require('firebase-admin/data-connect');

const connectorConfig = {
  connector: 'example',
  serviceId: 'functions',
  location: 'us-east4'
};
exports.connectorConfig = connectorConfig;

function createRestaurant(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateRestaurant', undefined, inputOpts);
}
exports.createRestaurant = createRestaurant;

function listMenuItems(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('ListMenuItems', undefined, inputOpts);
}
exports.listMenuItems = listMenuItems;

function updateOrderStatus(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateOrderStatus', inputVars, inputOpts);
}
exports.updateOrderStatus = updateOrderStatus;

function getRestaurantCategories(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetRestaurantCategories', inputVars, inputOpts);
}
exports.getRestaurantCategories = getRestaurantCategories;

