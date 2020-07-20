/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

/** Order Trigger
 *  1.before -> update the NetAmount based on the formula
 *  2.after -> update Account Annual Revenue for account that have Orders
 *  Set<Id> setAccountsId with OrderHandler
 * 
 * 
 * **/
trigger OrderTrigger on Order (before update, after update ) {
    if (Trigger.isAfter) {
            List<Order> triggerOrder = (List<Order>) Trigger.newMap;

        OrderTriggerHandler handler = new OrderTriggerHandler();
        handler.updateAccountsFromOrder(Trigger.oldMap, Trigger.newMap);
    }else {
        for(Order newOrder : Trigger.new){
            newOrder.NetAmount__c = newOrder.TotalAmount- newOrder.Shipment_Cost__c;
        }
        
    }

}