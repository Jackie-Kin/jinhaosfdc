declare module "@salesforce/apex/OrderStatusMgmtCtrl.loadOLs" {
  export default function loadOLs(param: {orderId: any}): Promise<any>;
}
declare module "@salesforce/apex/OrderStatusMgmtCtrl.rejectOLs" {
  export default function rejectOLs(param: {oiws: any, rejectReason: any}): Promise<any>;
}
declare module "@salesforce/apex/OrderStatusMgmtCtrl.unrejectOis" {
  export default function unrejectOis(param: {oiws: any}): Promise<any>;
}
