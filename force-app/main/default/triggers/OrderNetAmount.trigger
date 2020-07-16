/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
trigger OrderNetAmount on Order (before update) {
        for( Order newOrder : Trigger.new){
        newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }
    }

